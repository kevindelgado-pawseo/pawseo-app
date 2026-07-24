import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/date_format.dart';
import '../../../core/utils/form_submission_mixin.dart';
import '../../../core/widgets/pawseo_button.dart';
import '../data/mascotas_repository.dart';
import '../domain/mascota.dart';
import 'mascotas_strings.dart';

class EditarMascotaScreen extends ConsumerStatefulWidget {
  const EditarMascotaScreen({required this.mascota, super.key});

  final Mascota mascota;

  @override
  ConsumerState<EditarMascotaScreen> createState() =>
      _EditarMascotaScreenState();
}

class _EditarMascotaScreenState extends ConsumerState<EditarMascotaScreen>
    with FormSubmissionMixin {
  final _formKey = GlobalKey<FormState>();
  late final _nombreController = TextEditingController(
    text: widget.mascota.nombre,
  );
  late final _caracteristicasController = TextEditingController(
    text: widget.mascota.caracteristicas,
  );
  late final _pesoController = TextEditingController(
    text: widget.mascota.peso?.toString(),
  );

  String? _razaId;
  String? _colorId;
  String? _sexo;
  DateTime? _fechaNacimiento;
  late bool _fechaAproximada;

  @override
  void initState() {
    super.initState();
    _razaId = widget.mascota.razaId;
    _colorId = widget.mascota.colorId;
    _sexo = widget.mascota.sexo;
    _fechaNacimiento = widget.mascota.fechaNacimiento;
    _fechaAproximada = widget.mascota.fechaNacimientoAproximada;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _caracteristicasController.dispose();
    _pesoController.dispose();
    super.dispose();
  }

  Future<void> _elegirFecha() async {
    final ahora = DateTime.now();
    final elegida = await showDatePicker(
      context: context,
      initialDate: _fechaNacimiento ?? ahora,
      firstDate: DateTime(ahora.year - 30),
      lastDate: ahora,
    );
    if (elegida != null) setState(() => _fechaNacimiento = elegida);
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final pesoTexto = _pesoController.text.trim();

    await submit(
      () => ref
          .read(mascotasRepositoryProvider)
          .actualizarFicha(
            widget.mascota.id,
            nombre: _nombreController.text.trim(),
            razaId: _razaId,
            fechaNacimiento: _fechaNacimiento,
            fechaNacimientoAproximada: _fechaAproximada,
            colorId: _colorId,
            caracteristicas: _caracteristicasController.text.trim().isEmpty
                ? null
                : _caracteristicasController.text.trim(),
            sexo: _sexo,
            peso: pesoTexto.isEmpty ? null : double.tryParse(pesoTexto),
          ),
      onSuccess: (_) {
        ref.invalidate(misMascotasProvider);
        if (context.mounted) context.pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final razasAsync = ref.watch(razasProvider);
    final coloresAsync = ref.watch(coloresProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(MascotasStrings.editarFichaTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nombreController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: MascotasStrings.nombreLabel,
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? MascotasStrings.requiredField
                      : null,
                ),
                const SizedBox(height: 16),
                razasAsync.when(
                  data: (razas) => DropdownButtonFormField<String?>(
                    initialValue: _razaId,
                    decoration: const InputDecoration(
                      labelText: MascotasStrings.razaLabel,
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text(MascotasStrings.sinEspecificar),
                      ),
                      ...razas.map(
                        (raza) => DropdownMenuItem(
                          value: raza.id,
                          child: Text(raza.nombre),
                        ),
                      ),
                    ],
                    onChanged: (value) => setState(() => _razaId = value),
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 16),
                coloresAsync.when(
                  data: (colores) => DropdownButtonFormField<String?>(
                    initialValue: _colorId,
                    decoration: const InputDecoration(
                      labelText: MascotasStrings.colorLabel,
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text(MascotasStrings.sinEspecificar),
                      ),
                      ...colores.map(
                        (color) => DropdownMenuItem(
                          value: color.id,
                          child: Text(color.nombre),
                        ),
                      ),
                    ],
                    onChanged: (value) => setState(() => _colorId = value),
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _elegirFecha,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: MascotasStrings.fechaNacimientoLabel,
                      suffixIcon: Icon(Icons.calendar_today_outlined),
                    ),
                    child: Text(
                      _fechaNacimiento == null
                          ? MascotasStrings.seleccionarFecha
                          : AppDateFormat.short(_fechaNacimiento!),
                    ),
                  ),
                ),
                CheckboxListTile(
                  value: _fechaAproximada,
                  onChanged: (value) =>
                      setState(() => _fechaAproximada = value ?? false),
                  title: const Text(
                    MascotasStrings.fechaNacimientoAproximadaLabel,
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 8),
                Text(
                  MascotasStrings.sexoLabel,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text(MascotasStrings.machoLabel),
                      selected: _sexo == 'Macho',
                      onSelected: (selected) =>
                          setState(() => _sexo = selected ? 'Macho' : null),
                    ),
                    ChoiceChip(
                      label: const Text(MascotasStrings.hembraLabel),
                      selected: _sexo == 'Hembra',
                      onSelected: (selected) =>
                          setState(() => _sexo = selected ? 'Hembra' : null),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _pesoController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: MascotasStrings.pesoLabel,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return null;
                    return double.tryParse(value.trim()) == null
                        ? MascotasStrings.pesoInvalido
                        : null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _caracteristicasController,
                  maxLength: 50,
                  decoration: const InputDecoration(
                    labelText: MascotasStrings.caracteristicasLabel,
                  ),
                ),
                if (errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    errorMessage!,
                    style: TextStyle(color: colorScheme.error),
                  ),
                ],
                const SizedBox(height: 16),
                PawseoButton(
                  label: MascotasStrings.guardarFichaButton,
                  onPressed: isSubmitting ? null : _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
