import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/result.dart';
import '../../../core/widgets/pawseo_button.dart';
import '../data/auth_repository.dart';
import 'auth_strings.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  var _isSubmitting = false;
  var _emailSent = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
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
        .sendPasswordResetEmail(_emailController.text.trim());

    if (!mounted) return;

    switch (result) {
      case Success():
        setState(() {
          _isSubmitting = false;
          _emailSent = true;
        });
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
      appBar: AppBar(title: const Text(AuthStrings.forgotPasswordTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _emailSent
              ? Center(
                  child: Text(
                    AuthStrings.resetEmailSent,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                )
              : Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(AuthStrings.forgotPasswordInstructions),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(labelText: AuthStrings.emailLabel),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AuthStrings.requiredField;
                          }
                          if (!value.contains('@')) return AuthStrings.invalidEmail;
                          return null;
                        },
                      ),
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 8),
                        Text(_errorMessage!, style: TextStyle(color: colorScheme.error)),
                      ],
                      const SizedBox(height: 24),
                      PawseoButton(
                        label: AuthStrings.sendResetEmailButton,
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
