import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/utils/form_submission_mixin.dart';
import '../../../core/widgets/pawseo_button.dart';
import '../data/auth_repository.dart';
import 'auth_strings.dart';

/// Login real vía Supabase Auth (solo email/contraseña por ahora — Google
/// queda pausado, ver docs/tecnico.md). Pantalla separada de `RegisterScreen`
/// a propósito, cada una con sus propios campos fijos.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with FormSubmissionMixin {
  final _formKey = GlobalKey<FormState>();
  // Precarga solo en debug -- comodidad de desarrollo, nunca en release.
  final _emailController = TextEditingController(
    text: kDebugMode ? 'kevin.delgado@pawseo.cl' : '',
  );
  final _passwordController = TextEditingController(text: kDebugMode ? 'hola123' : '');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    await submit(
      () => ref
          .read(authRepositoryProvider)
          .signInWithEmail(email: _emailController.text.trim(), password: _passwordController.text),
      onSuccess: (_) {}, // el router redirige solo al detectar la sesión nueva
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.pets_rounded, size: 64, color: colorScheme.primary),
                const SizedBox(height: 16),
                Text(
                  AuthStrings.loginTitle,
                  textAlign: TextAlign.center,
                  style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: AuthStrings.emailLabel),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return AuthStrings.requiredField;
                    if (!value.contains('@')) return AuthStrings.invalidEmail;
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  decoration: const InputDecoration(labelText: AuthStrings.passwordLabel),
                  validator: (value) {
                    if (value == null || value.isEmpty) return AuthStrings.requiredField;
                    if (value.length < 6) return AuthStrings.passwordTooShort;
                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.push(AppRoutes.forgotPassword),
                    child: const Text(AuthStrings.forgotPasswordLink),
                  ),
                ),
                if (errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(errorMessage!, style: TextStyle(color: colorScheme.error)),
                ],
                const SizedBox(height: 16),
                PawseoButton(
                  label: AuthStrings.loginButton,
                  onPressed: isSubmitting ? null : _submit,
                ),
                const SizedBox(height: 24),
                Text(
                  AuthStrings.noAccountText,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 8),
                PawseoButton(
                  label: AuthStrings.registerButton,
                  variant: PawseoButtonVariant.outlined,
                  onPressed: () => context.push(AppRoutes.register),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
