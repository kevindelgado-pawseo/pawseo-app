import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/form_submission_mixin.dart';
import '../../../core/widgets/pawseo_button.dart';
import '../data/mascotas_repository.dart';
import 'mascotas_strings.dart';

/// Solo pide `nombre` -- el resto de la ficha (foto, raza, nacimiento,
/// color, sexo, peso) se completa después en una ficha editable aparte
/// (ver docs/modelo_datos.md). Ese editor todavía no existe.
class CrearMascotaScreen extends ConsumerStatefulWidget {
  const CrearMascotaScreen({super.key});

  @override
  ConsumerState<CrearMascotaScreen> createState() => _CrearMascotaScreenState();
}

class _CrearMascotaScreenState extends ConsumerState<CrearMascotaScreen>
    with FormSubmissionMixin {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    await submit(
      () => ref.read(mascotasRepositoryProvider).crearMascota(_nombreController.text.trim()),
      onSuccess: (_) {
        ref.invalidate(misMascotasProvider);
        if (context.mounted) context.pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text(MascotasStrings.crearMascotaTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nombreController,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  decoration: const InputDecoration(labelText: MascotasStrings.nombreLabel),
                  validator: (value) =>
                      (value == null || value.trim().isEmpty)
                          ? MascotasStrings.requiredField
                          : null,
                ),
                if (errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(errorMessage!, style: TextStyle(color: colorScheme.error)),
                ],
                const SizedBox(height: 24),
                PawseoButton(
                  label: MascotasStrings.crearMascotaButton,
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
