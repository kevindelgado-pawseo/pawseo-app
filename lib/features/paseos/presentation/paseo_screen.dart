import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/utils/duration_format.dart';
import '../../../core/utils/map_defaults.dart';
import '../../../core/widgets/pawseo_button.dart';
import '../../../core/widgets/pawseo_floating_button.dart';
import '../../mascotas/data/mascotas_repository.dart';
import '../../mascotas/domain/mascota.dart';
import '../../mascotas/presentation/mascotas_empty_state.dart';
import '../../mascotas/presentation/mascotas_strings.dart';
import '../../pois/data/pois_repository.dart';
import '../../pois/domain/poi.dart';
import '../domain/paseo_mascota_selection.dart';
import 'paseo_controller.dart';
import 'paseo_mascotas_selector.dart';
import 'paseos_strings.dart';

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
/// ubicación -- geolocalizar solo mejora el centrado del mapa al arrancar un
/// paseo, nunca es un prerequisito para ver el mapa ni para pasear.
class _PaseoMapaSection extends ConsumerStatefulWidget {
  const _PaseoMapaSection({required this.mascotas});

  final List<Mascota> mascotas;

  @override
  ConsumerState<_PaseoMapaSection> createState() => _PaseoMapaSectionState();
}

class _PaseoMapaSectionState extends ConsumerState<_PaseoMapaSection> {
  final _mapController = MapController();
  Timer? _ticker;
  Duration _elapsed = Duration.zero;

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

  Future<void> _geolocalizarYCentrar() async {
    if (!await Geolocator.isLocationServiceEnabled()) return;

    var permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }
    if (permiso == LocationPermission.denied ||
        permiso == LocationPermission.deniedForever) {
      return;
    }

    try {
      final posicion = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 8),
        ),
      );
      _mapController.move(LatLng(posicion.latitude, posicion.longitude), 16);
    } catch (_) {
      // Sin señal a tiempo o servicio no disponible -- el mapa se queda en
      // el fallback, no es un error que deba bloquear el paseo.
    }
  }

  Future<void> _iniciarFlujo() async {
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

  Marker _markerFromPoi(Poi poi) {
    return Marker(
      point: LatLng(poi.latitud, poi.longitud),
      width: 36,
      height: 36,
      child: Tooltip(
        message: poi.nombre,
        child: Icon(
          Icons.location_on_rounded,
          color: Theme.of(context).colorScheme.primary,
          size: 36,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(paseoControllerProvider, (previous, next) {
      final wasActivo = previous?.paseoActivo;
      final nowActivo = next.paseoActivo;
      if (nowActivo != null && nowActivo.id != wasActivo?.id) {
        _startTicker(nowActivo.iniciadoEn);
      } else if (nowActivo == null && wasActivo != null) {
        _stopTicker();
      }
    });

    final controllerState = ref.watch(paseoControllerProvider);
    final paseoActivo = controllerState.paseoActivo;
    final poisAsync = ref.watch(poisProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: const MapOptions(
            initialCenter: MapDefaults.fallbackCenter,
            initialZoom: MapDefaults.fallbackZoom,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'cl.pawseo.app',
            ),
            MarkerLayer(
              markers: poisAsync.value?.map(_markerFromPoi).toList() ?? [],
            ),
          ],
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
