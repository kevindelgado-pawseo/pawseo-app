import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/utils/result.dart';
import '../../../core/widgets/pawseo_button.dart';
import '../data/auth_repository.dart';
import 'auth_strings.dart';

enum _AuthMode { login, register }

/// Login e registro real vía Supabase Auth. Login y registro piden
/// exactamente los mismos campos (correo + contraseña) — el nombre se pide
/// después, en `CompleteProfileScreen`, así el formulario nunca cambia de
/// forma al alternar entre modos. El botón de Google queda visible pero sin
/// autenticar todavía — depende de credenciales OAuth que aún no existen
/// (ver docs/specs/auth.md).
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  var _mode = _AuthMode.login;
  var _isSubmitting = false;
  var _confirmationEmailSent = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final repository = ref.read(authRepositoryProvider);
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (_mode == _AuthMode.login) {
      final result = await repository.signInWithEmail(email: email, password: password);
      if (!mounted) return;
      switch (result) {
        case Success():
          break; // el router redirige solo al detectar la sesión nueva
        case Failure(:final message):
          setState(() {
            _isSubmitting = false;
            _errorMessage = message;
          });
      }
      return;
    }

    final result = await repository.signUpWithEmail(email: email, password: password);
    if (!mounted) return;
    switch (result) {
      case Success(value: SignUpOutcome.signedIn):
        break; // el router redirige solo (y luego a completar perfil)
      case Success(value: SignUpOutcome.confirmationEmailSent):
        setState(() {
          _isSubmitting = false;
          _confirmationEmailSent = true;
        });
      case Failure(:final message):
        setState(() {
          _isSubmitting = false;
          _errorMessage = message;
        });
    }
  }

  void _showGooglePendingSnackBar() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text(AuthStrings.googlePendingConfig)));
  }

  @override
  Widget build(BuildContext context) {
    if (_confirmationEmailSent) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.mark_email_read_rounded,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AuthStrings.confirmationEmailSentTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(AuthStrings.confirmationEmailSentBody, textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isRegister = _mode == _AuthMode.register;

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
                  AuthStrings.welcomeTitle,
                  textAlign: TextAlign.center,
                  style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  AuthStrings.welcomeSubtitle,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 32),
                PawseoButton(
                  label: AuthStrings.continueWithGoogle,
                  icon: const Icon(Icons.g_mobiledata_rounded, size: 28),
                  onPressed: _showGooglePendingSnackBar,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('o', style: TextStyle(color: colorScheme.onSurfaceVariant)),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 24),
                SegmentedButton<_AuthMode>(
                  segments: const [
                    ButtonSegment(value: _AuthMode.login, label: Text(AuthStrings.loginButton)),
                    ButtonSegment(value: _AuthMode.register, label: Text(AuthStrings.registerButton)),
                  ],
                  selected: {_mode},
                  onSelectionChanged: (selection) => setState(() {
                    _mode = selection.first;
                    _errorMessage = null;
                  }),
                ),
                const SizedBox(height: 24),
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
                if (!isRegister)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.push(AppRoutes.forgotPassword),
                      child: const Text(AuthStrings.forgotPasswordLink),
                    ),
                  )
                else
                  const SizedBox(height: 16),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(_errorMessage!, style: TextStyle(color: colorScheme.error)),
                ],
                const SizedBox(height: 16),
                PawseoButton(
                  label: isRegister ? AuthStrings.registerButton : AuthStrings.loginButton,
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
