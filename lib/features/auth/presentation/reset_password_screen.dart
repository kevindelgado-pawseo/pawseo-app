import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/utils/result.dart';
import '../../../core/widgets/pawseo_button.dart';
import '../data/auth_repository.dart';
import 'auth_strings.dart';

/// Se llega acá solo vía el deep link de recuperar contraseña
/// (ver app_router.dart — escucha AuthChangeEvent.passwordRecovery).
class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  var _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final result = await ref
        .read(authRepositoryProvider)
        .updatePassword(_passwordController.text);

    if (!mounted) return;

    switch (result) {
      case Success():
        context.go(AppRoutes.home);
      case Failure(:final message):
        setState(() {
          _isSubmitting = false;
          _errorMessage = message;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text(AuthStrings.resetPasswordTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(AuthStrings.resetPasswordInstructions),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  onFieldSubmitted: (_) => _submit(),
                  decoration: const InputDecoration(labelText: AuthStrings.newPasswordLabel),
                  validator: (value) {
                    if (value == null || value.isEmpty) return AuthStrings.requiredField;
                    if (value.length < 6) return AuthStrings.passwordTooShort;
                    return null;
                  },
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(_errorMessage!, style: TextStyle(color: colorScheme.error)),
                ],
                const SizedBox(height: 24),
                PawseoButton(
                  label: AuthStrings.updatePasswordButton,
                  onPressed: _isSubmitting ? null : _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
