import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/theme/map_style.dart';
import '../../../core/utils/duration_format.dart';
import '../../../core/utils/map_defaults.dart';
import '../../../core/widgets/pawseo_button.dart';
import '../../../core/widgets/pawseo_floating_button.dart';
import '../../mascotas/data/mascotas_repository.dart';
import '../../mascotas/domain/mascota.dart';
import '../../mascotas/presentation/mascotas_empty_state.dart';
import '../../mascotas/presentation/mascotas_strings.dart';
import '../../pois/data/pois_repository.dart';
import '../../pois/domain/limite_pois_cercanos.dart';
import '../../pois/domain/poi.dart';
import '../../pois/presentation/poi_detalle_sheet.dart';
import '../../pois/presentation/poi_marker_icon.dart';
import '../domain/paseo_mascota_selection.dart';
import 'paseo_controller.dart';
import 'paseo_mascotas_selector.dart';
import 'paseos_strings.dart';
import 'pasos_permiso.dart';
import 'requisito_paseo_sheet.dart';

class PaseoScreen extends ConsumerWidget {
  const PaseoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mascotasAsync = ref.watch(misMascotasProvider);

    return Scaffold(
      body: mascotasAsync.when(
        data: (mascotas) => mascotas.isEmpty
            ? const SafeArea(child: MascotasEmptyState())
            : _PaseoMapaSection(mascotas: mascotas),
        loading: () =>
            const SafeArea(child: Center(child: CircularProgressIndicator())),
        error: (_, _) => SafeArea(
          child: Center(child: Text(MascotasStrings.errorCargandoMascotas)),
        ),
      ),
    );
  }
}

/// El mapa y los POIs se muestran siempre, sin depender de tener permiso de
/// ubicación. El marcador de "mi ubicación" y el paseo en sí son distintos:
/// exigen no solo permiso concedido sino ubicación **precisa** (nunca
/// aproximada) -- ver `_asegurarUbicacionPrecisa`. Ninguna plataforma deja
/// forzar esa elección en el diálogo del sistema, así que se pide el
/// permiso normal y se valida la precisión después (mismo criterio que usan
/// apps de navegación como Waze).
class _PaseoMapaSection extends ConsumerStatefulWidget {
  const _PaseoMapaSection({required this.mascotas});

  final List<Mascota> mascotas;

  @override
  ConsumerState<_PaseoMapaSection> createState() => _PaseoMapaSectionState();
}

class _PaseoMapaSectionState extends ConsumerState<_PaseoMapaSection> {
  GoogleMapController? _mapController;
  Timer? _ticker;
  Duration _elapsed = Duration.zero;
  final Map<String, BitmapDescriptor> _markerIcons = {};
  final Set<String> _iconosPendientes = {};
  bool _ubicacionPrecisaConcedida = false;
  StreamSubscription<Position>? _seguimientoCamara;

  @override
  void initState() {
    super.initState();
    unawaited(_actualizarEstadoUbicacion());
  }

  /// Chequeo silencioso (nunca pide permiso, solo lee el estado actual) --
  /// si ya se había concedido precisa en una sesión anterior, el punto azul
  /// aparece de entrada sin que el usuario tenga que tocar "Pawsear" de
  /// nuevo. En la primera instalación da `false` y el mapa se ve sin él.
  Future<void> _actualizarEstadoUbicacion() async {
    final concedida = await _tieneUbicacionPrecisa();
    if (!mounted) return;
    setState(() => _ubicacionPrecisaConcedida = concedida);
  }

  Future<bool> _tieneUbicacionPrecisa() async {
    if (!await Geolocator.isLocationServiceEnabled()) return false;

    final permiso = await Geolocator.checkPermission();
    if (permiso != LocationPermission.always &&
        permiso != LocationPermission.whileInUse) {
      return false;
    }

    return await Geolocator.getLocationAccuracy() ==
        LocationAccuracyStatus.precise;
  }

  /// A diferencia de `_tieneUbicacionPrecisa`, acá sí se puede pedir el
  /// permiso (`requestPermission`) porque es en respuesta a una acción
  /// explícita del usuario. Ninguna plataforma deja forzar "precisa" en el
  /// diálogo del sistema -- el usuario siempre puede elegir "aproximada" --
  /// así que se pide el permiso normal y se valida la precisión después,
  /// bloqueando el paseo con una explicación si no alcanza (mismo criterio
  /// que usan apps de navegación como Waze).
  Future<bool> _asegurarUbicacionPrecisa() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      if (mounted) {
        await mostrarRequisitoPaseo(
          context,
          icono: Icons.location_on_outlined,
          mensaje: PaseosStrings.ubicacionServicioDesactivadoMensaje,
          onAbrirAjustes: Geolocator.openLocationSettings,
        );
      }
      return false;
    }

    var permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }
    if (permiso == LocationPermission.denied ||
        permiso == LocationPermission.deniedForever) {
      if (mounted) {
        await mostrarRequisitoPaseo(
          context,
          icono: Icons.location_on_outlined,
          mensaje: PaseosStrings.ubicacionPermisoRequeridoMensaje,
          onAbrirAjustes: Geolocator.openAppSettings,
        );
      }
      return false;
    }

    if (await Geolocator.getLocationAccuracy() != LocationAccuracyStatus.precise) {
      if (mounted) {
        await mostrarRequisitoPaseo(
          context,
          icono: Icons.location_on_outlined,
          mensaje: PaseosStrings.ubicacionPrecisaRequeridaMensaje,
          onAbrirAjustes: Geolocator.openAppSettings,
        );
      }
      return false;
    }

    if (mounted) setState(() => _ubicacionPrecisaConcedida = true);
    return true;
  }

  static const _tiempoEsperaSensorPasos = Duration(seconds: 5);

  /// Igual criterio que `_asegurarUbicacionPrecisa`, pero para el sensor de
  /// pasos -- pedido explícito de Kevin (2026-07-26): un paseo nunca se
  /// guarda sin pasos, los dispositivos sin el sensor quedan fuera de esta
  /// función. Permiso denegado es corregible (Ajustes); sensor inexistente
  /// no lo es -- por eso ese caso no ofrece ningún botón (ver
  /// `requisito_paseo_sheet.dart`).
  Future<bool> _asegurarPodometroDisponible() async {
    final status = await permisoPodometro().request();
    if (!status.isGranted) {
      if (mounted) {
        await mostrarRequisitoPaseo(
          context,
          icono: Icons.directions_walk,
          mensaje: PaseosStrings.podometroPermisoRequeridoMensaje,
          onAbrirAjustes: openAppSettings,
        );
      }
      return false;
    }

    if (!await _sensorDePasosDisponible()) {
      if (mounted) {
        await mostrarRequisitoPaseo(
          context,
          icono: Icons.directions_walk,
          mensaje: PaseosStrings.podometroNoDisponibleMensaje,
        );
      }
      return false;
    }

    return true;
  }

  /// `pedometer` no expone un chequeo directo de "¿existe el sensor?" -- la
  /// única señal confiable es intentar suscribirse: un primer evento
  /// confirma que existe, un error confirma que no (ver
  /// `SensorStreamHandler.kt` del plugin, citado en
  /// `docs/specs/podometro.md`). Si no llega ninguna de las dos cosas
  /// dentro de `_tiempoEsperaSensorPasos`, se trata como no disponible.
  Future<bool> _sensorDePasosDisponible() async {
    final completer = Completer<bool>();
    late final StreamSubscription<StepCount> subscription;

    subscription = Pedometer.stepCountStream.listen(
      (_) {
        if (!completer.isCompleted) completer.complete(true);
      },
      onError: (_) {
        if (!completer.isCompleted) completer.complete(false);
      },
    );

    final timer = Timer(_tiempoEsperaSensorPasos, () {
      if (!completer.isCompleted) completer.complete(false);
    });

    final disponible = await completer.future;
    timer.cancel();
    await subscription.cancel();
    return disponible;
  }

  void _startTicker(DateTime iniciadoEn) {
    _ticker?.cancel();
    _updateElapsed(iniciadoEn);
    _ticker = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateElapsed(iniciadoEn),
    );
  }

  void _updateElapsed(DateTime iniciadoEn) {
    if (!mounted) return;
    setState(
      () => _elapsed = DateTime.now().toUtc().difference(iniciadoEn.toUtc()),
    );
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
    if (mounted) setState(() => _elapsed = Duration.zero);
  }

  /// A diferencia de la suscripción al podómetro (que vive en
  /// `PaseoController` porque su lectura base debe sobrevivir a un rebuild),
  /// el seguimiento de cámara está atado a `_mapController`, que es del
  /// widget -- no hay forma de moverlo desde el controller. Permiso y
  /// precisión ya quedaron garantizados por `_asegurarUbicacionPrecisa`
  /// antes de que exista un paseo activo, así que no se re-chequean acá.
  ///
  /// `moveCamera` (instantáneo), no `animateCamera` -- con actualizaciones
  /// seguidas, cada `animateCamera` dispara su propia animación nativa, y si
  /// llega una lectura nueva antes de que la anterior termine, se apilan y
  /// se siente como lag. `animateCamera` sigue siendo lo correcto para el
  /// centrado inicial en `_geolocalizarYCentrar` -- ahí es un solo
  /// movimiento deliberado, no una sucesión continua.
  void _iniciarSeguimientoCamara() {
    _seguimientoCamara?.cancel();
    _seguimientoCamara =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 5,
          ),
        ).listen((posicion) {
          unawaited(
            _mapController?.moveCamera(
              CameraUpdate.newLatLng(
                LatLng(posicion.latitude, posicion.longitude),
              ),
            ),
          );
        }, onError: (_) {});
  }

  void _detenerSeguimientoCamara() {
    _seguimientoCamara?.cancel();
    _seguimientoCamara = null;
  }

  /// Solo centra la cámara -- el permiso y la precisión ya quedaron
  /// garantizados por `_asegurarUbicacionPrecisa` antes de llamar acá.
  ///
  /// Si hay POI a menos de `MapDefaults.radioPoisCercanosMetros`, encuadra
  /// la posición del usuario junto con ellos (se ve la ruta hacia el POI
  /// más cercano, no solo la calle inmediata) -- sin POI cerca, cae a un
  /// zoom fijo centrado en el usuario.
  Future<void> _geolocalizarYCentrar() async {
    try {
      final posicion = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 8),
        ),
      );

      final pois = ref.read(poisProvider).value ?? const <Poi>[];
      final limite = limiteParaPoisCercanos(
        latitudUsuario: posicion.latitude,
        longitudUsuario: posicion.longitude,
        pois: pois,
        radioMetros: MapDefaults.radioPoisCercanosMetros,
      );

      final cameraUpdate = limite == null
          ? CameraUpdate.newLatLngZoom(
              LatLng(posicion.latitude, posicion.longitude),
              MapDefaults.ubicacionZoom,
            )
          : CameraUpdate.newLatLngBounds(
              LatLngBounds(
                southwest: LatLng(limite.suroesteLat, limite.suroesteLng),
                northeast: LatLng(limite.noresteLat, limite.noresteLng),
              ),
              64,
            );

      await _mapController?.animateCamera(cameraUpdate);
    } catch (_) {
      // Sin señal a tiempo o servicio no disponible -- el mapa se queda en
      // el fallback, no es un error que deba bloquear el paseo.
    }
  }

  Future<void> _iniciarFlujo() async {
    if (!await _asegurarUbicacionPrecisa() || !mounted) return;
    if (!await _asegurarPodometroDisponible() || !mounted) return;

    final List<String> ids;
    if (debeMostrarSelectorMascotas(widget.mascotas)) {
      final seleccionadas = await elegirMascotasParaPasear(
        context,
        widget.mascotas,
      );
      if (seleccionadas == null) return;
      ids = seleccionadas;
    } else {
      ids = widget.mascotas.map((m) => m.id).toList();
    }

    unawaited(_geolocalizarYCentrar());
    unawaited(ref.read(paseoControllerProvider.notifier).iniciar(ids));
  }

  Future<void> _generarIconosFaltantes(List<Poi> pois) async {
    final faltantes = pois
        .where(
          (p) =>
              !_markerIcons.containsKey(p.id) &&
              !_iconosPendientes.contains(p.id),
        )
        .toList();
    if (faltantes.isEmpty) return;

    final colorFondo = Theme.of(context).colorScheme.primary;
    _iconosPendientes.addAll(faltantes.map((p) => p.id));

    final iconos = await Future.wait(
      faltantes.map((poi) => buildPoiMarkerIcon(poi, colorFondo: colorFondo)),
    );

    if (!mounted) return;
    setState(() {
      for (var i = 0; i < faltantes.length; i++) {
        _markerIcons[faltantes[i].id] = iconos[i];
        _iconosPendientes.remove(faltantes[i].id);
      }
    });
  }

  Marker _markerFromPoi(Poi poi) {
    return Marker(
      markerId: MarkerId(poi.id),
      position: LatLng(poi.latitud, poi.longitud),
      anchor: const Offset(0.5, 0.5),
      icon: _markerIcons[poi.id] ?? BitmapDescriptor.defaultMarker,
      onTap: () => mostrarDetallePoi(context, poi),
    );
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _seguimientoCamara?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(paseoControllerProvider, (previous, next) {
      final wasActivo = previous?.paseoActivo;
      final nowActivo = next.paseoActivo;
      if (nowActivo != null && nowActivo.id != wasActivo?.id) {
        _startTicker(nowActivo.iniciadoEn);
        _iniciarSeguimientoCamara();
      } else if (nowActivo == null && wasActivo != null) {
        _stopTicker();
        _detenerSeguimientoCamara();
      }
    });

    final controllerState = ref.watch(paseoControllerProvider);
    final paseoActivo = controllerState.paseoActivo;
    final poisAsync = ref.watch(poisProvider);
    final pois = poisAsync.value ?? const <Poi>[];
    final colorScheme = Theme.of(context).colorScheme;

    if (pois.isNotEmpty) {
      unawaited(_generarIconosFaltantes(pois));
    }

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: MapDefaults.fallbackCenter,
            zoom: MapDefaults.fallbackZoom,
          ),
          style: MapStyle.cozy,
          myLocationEnabled: _ubicacionPrecisaConcedida,
          myLocationButtonEnabled: _ubicacionPrecisaConcedida,
          onMapCreated: (controller) => _mapController = controller,
          markers: pois.map(_markerFromPoi).toSet(),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                if (paseoActivo != null)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            PaseosStrings.paseandoCon(
                              widget.mascotas.map((m) => m.nombre).join(', '),
                            ),
                            style: Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            DurationFormat.elapsed(_elapsed),
                            style: Theme.of(context).textTheme.displayMedium,
                            textAlign: TextAlign.center,
                          ),
                          if (controllerState.pasosActuales != null)
                            Text(
                              PaseosStrings.pasos(
                                controllerState.pasosActuales!,
                              ),
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                        ],
                      ),
                    ),
                  ),
                if (controllerState.errorMessage != null)
                  Card(
                    color: colorScheme.errorContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        controllerState.errorMessage!,
                        style: TextStyle(color: colorScheme.onErrorContainer),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: PawseoFloatingButton(
                label: paseoActivo == null
                    ? PaseosStrings.vamosAPawsearButton
                    : PaseosStrings.detenerPaseoButton,
                icon: Icon(
                  paseoActivo == null
                      ? Icons.pets_rounded
                      : Icons.stop_circle_outlined,
                ),
                variant: paseoActivo == null
                    ? PawseoButtonVariant.filled
                    : PawseoButtonVariant.outlined,
                onPressed: controllerState.isProcessing
                    ? null
                    : () {
                        if (paseoActivo == null) {
                          unawaited(_iniciarFlujo());
                        } else {
                          unawaited(
                            ref
                                .read(paseoControllerProvider.notifier)
                                .detener(),
                          );
                        }
                      },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
