import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/utils/result.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  AuthRepository(this._auth);

  final GoTrueClient _auth;

  static const passwordResetRedirect = 'pawseo://reset-password';

  Session? get currentSession => _auth.currentSession;

  Stream<AuthState> get authStateChanges => _auth.onAuthStateChange;

  Future<Result<void>> signUpWithEmail({
    required String email,
    required String password,
    required String nombre,
  }) async {
    try {
      await _auth.signUp(
        email: email,
        password: password,
        data: {'nombre': nombre},
      );
      return const Success(null);
    } on AuthException catch (e) {
      return Failure(_mapAuthError(e));
    } catch (_) {
      return const Failure('No se pudo crear la cuenta. Intenta de nuevo.');
    }
  }

  Future<Result<void>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithPassword(email: email, password: password);
      return const Success(null);
    } on AuthException catch (e) {
      return Failure(_mapAuthError(e));
    } catch (_) {
      return const Failure('No se pudo iniciar sesión. Intenta de nuevo.');
    }
  }

  Future<Result<void>> sendPasswordResetEmail(String email) async {
    try {
      await _auth.resetPasswordForEmail(email, redirectTo: passwordResetRedirect);
      return const Success(null);
    } on AuthException catch (e) {
      return Failure(_mapAuthError(e));
    } catch (_) {
      return const Failure('No se pudo enviar el correo. Intenta de nuevo.');
    }
  }

  Future<Result<void>> updatePassword(String newPassword) async {
    try {
      await _auth.updateUser(UserAttributes(password: newPassword));
      return const Success(null);
    } on AuthException catch (e) {
      return Failure(_mapAuthError(e));
    } catch (_) {
      return const Failure('No se pudo actualizar la contraseña. Intenta de nuevo.');
    }
  }

  Future<void> signOut() => _auth.signOut();

  String _mapAuthError(AuthException e) {
    return switch (e.code) {
      'invalid_credentials' => 'Email o contraseña incorrectos.',
      'user_already_exists' => 'Ese correo ya tiene una cuenta — intenta iniciar sesión.',
      'weak_password' => 'La contraseña es muy débil, usa al menos 6 caracteres.',
      'over_email_send_rate_limit' => 'Espera un momento antes de volver a intentar.',
      _ => e.message,
    };
  }
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(Supabase.instance.client.auth);
}

@riverpod
Stream<AuthState> authStateChanges(Ref ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
}
