import 'package:flutter/widgets.dart';

import 'result.dart';

/// Maneja el ceremonial repetido de "validar → loading → llamar repository →
/// reaccionar a Result" que se repite en cada pantalla con formulario.
mixin FormSubmissionMixin<T extends StatefulWidget> on State<T> {
  var isSubmitting = false;
  String? errorMessage;

  Future<void> submit<R>(
    Future<Result<R>> Function() action, {
    required void Function(R value) onSuccess,
  }) async {
    setState(() {
      isSubmitting = true;
      errorMessage = null;
    });

    final result = await action();
    if (!mounted) return;

    switch (result) {
      case Success(:final value):
        setState(() => isSubmitting = false);
        onSuccess(value);
      case Failure(:final message):
        setState(() {
          isSubmitting = false;
          errorMessage = message;
        });
    }
  }
}
