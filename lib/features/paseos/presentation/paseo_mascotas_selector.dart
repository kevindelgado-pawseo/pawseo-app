import 'package:flutter/material.dart';

import '../../../core/widgets/pawseo_button.dart';
import '../../mascotas/domain/mascota.dart';
import 'paseos_strings.dart';

/// Bottom sheet para elegir con cuáles mascotas se sale a pasear -- todas
/// premarcadas por defecto, porque pasear con todas a la vez es el caso
/// común (ver docs/modelo_datos.md). Devuelve `null` si se descarta sin
/// confirmar.
Future<List<String>?> elegirMascotasParaPasear(
  BuildContext context,
  List<Mascota> mascotas,
) {
  return showModalBottomSheet<List<String>?>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _PaseoMascotasSelectorSheet(mascotas: mascotas),
  );
}

class _PaseoMascotasSelectorSheet extends StatefulWidget {
  const _PaseoMascotasSelectorSheet({required this.mascotas});

  final List<Mascota> mascotas;

  @override
  State<_PaseoMascotasSelectorSheet> createState() =>
      _PaseoMascotasSelectorSheetState();
}

class _PaseoMascotasSelectorSheetState
    extends State<_PaseoMascotasSelectorSheet> {
  late final Set<String> _seleccionadas = widget.mascotas
      .map((m) => m.id)
      .toSet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              PaseosStrings.elegirMascotasTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...widget.mascotas.map(
              (mascota) => CheckboxListTile(
                value: _seleccionadas.contains(mascota.id),
                title: Text(mascota.nombre),
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (value) => setState(() {
                  if (value ?? false) {
                    _seleccionadas.add(mascota.id);
                  } else {
                    _seleccionadas.remove(mascota.id);
                  }
                }),
              ),
            ),
            const SizedBox(height: 8),
            PawseoButton(
              label: PaseosStrings.confirmarSeleccionButton,
              onPressed: _seleccionadas.isEmpty
                  ? null
                  : () => Navigator.of(context).pop(_seleccionadas.toList()),
            ),
          ],
        ),
      ),
    );
  }
}
