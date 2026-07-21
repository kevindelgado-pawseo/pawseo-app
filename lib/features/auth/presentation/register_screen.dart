import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/form_submission_mixin.dart';
import '../../../core/widgets/pawseo_button.dart';
import '../data/auth_repository.dart';
import 'auth_strings.dart';

/// Pantalla de registro, separada de `LoginScreen` a propósito — cada una
/// con sus propios campos fijos, sin lógica condicional de mostrar/ocultar.
///
/// El estado de "revisa tu correo" (OTP) queda implementado pero dormido:
/// con la verificación de email desactivada en Supabase, `signUpWithEmail`
/// siempre devuelve `SignUpOutcome.signedIn` y este estado nunca se activa.
/// No requiere cambios cuando se reactive la verificación más adelante
/// (ver docs/specs/auth.md).
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> with FormSubmissionMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _otpController = TextEditingController();

  var _awaitingOtp = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    await submit(
      () => ref
          .read(authRepositoryProvider)
          .signUpWithEmail(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            nombre: _nameController.text.trim(),
          ),
      onSuccess: (outcome) {
        if (outcome == SignUpOutcome.confirmationEmailSent) {
          setState(() => _awaitingOtp = true);
        }
        // SignUpOutcome.signedIn: el router redirige solo.
      },
    );
  }

  Future<void> _verifyOtp() async {
    await submit(
      () => ref
          .read(authRepositoryProvider)
          .verifySignUpOtp(email: _emailController.text.trim(), token: _otpController.text.trim()),
      onSuccess: (_) {}, // el router redirige solo
    );
  }

  Future<void> _resendOtp() async {
    await submit(
      () => ref.read(authRepositoryProvider).resendSignUpOtp(_emailController.text.trim()),
      onSuccess: (_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text(AuthStrings.resendCodeSent)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_awaitingOtp) {
      return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.mark_email_read_rounded, size: 64, color: colorScheme.primary),
                  const SizedBox(height: 16),
                  Text(
                    AuthStrings.otpTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(AuthStrings.otpInstructions, textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 6,
                    style: Theme.of(context).textTheme.headlineSmall,
                    decoration: const InputDecoration(
                      labelText: AuthStrings.otpCodeLabel,
                      counterText: '',
                    ),
                    onSubmitted: (_) => _verifyOtp(),
                  ),
                  if (errorMessage != null) ...[
                    const SizedBox(height: 8),
                    Text(errorMessage!, style: TextStyle(color: colorScheme.error)),
                  ],
                  const SizedBox(height: 16),
                  PawseoButton(
                    label: AuthStrings.verifyCodeButton,
                    onPressed: isSubmitting ? null : _verifyOtp,
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: isSubmitting ? null : _resendOtp,
                    child: const Text(AuthStrings.resendCodeLink),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text(AuthStrings.registerTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: AuthStrings.nameLabel),
                  validator: (value) =>
                      (value == null || value.trim().isEmpty) ? AuthStrings.requiredField : null,
                ),
                const SizedBox(height: 16),
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
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: AuthStrings.passwordLabel),
                  validator: (value) {
                    if (value == null || value.isEmpty) return AuthStrings.requiredField;
                    if (value.length < 6) return AuthStrings.passwordTooShort;
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  decoration: const InputDecoration(labelText: AuthStrings.confirmPasswordLabel),
                  validator: (value) {
                    if (value == null || value.isEmpty) return AuthStrings.requiredField;
                    if (value != _passwordController.text) return AuthStrings.passwordMismatch;
                    return null;
                  },
                ),
                if (errorMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(errorMessage!, style: TextStyle(color: colorScheme.error)),
                ],
                const SizedBox(height: 24),
                PawseoButton(
                  label: AuthStrings.registerButton,
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
