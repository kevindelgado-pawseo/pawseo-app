import 'dart:async';

import 'package:flutter/foundation.dart';

/// Adapta un Stream a Listenable para que go_router pueda re-evaluar sus
/// rutas (`redirect`) cada vez que cambia el estado de auth.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
