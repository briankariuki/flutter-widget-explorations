import 'package:dart_either/dart_either.dart';

import '../models/models.dart';

typedef Result<T> = Either<AppError, T>;

typedef Function0<T> = T Function();

typedef Function1<P0, R> = R Function(P0);

typedef Function2<P0, P1, R> = R Function(P0, P1);

typedef Function3<P0, P1, P2, R> = R Function(P0, P1, P2);

extension PipeFunction1Extension<T, R> on Function1<T, R> {
  Function1<T, S> pipe<S>(Function1<R, S> other) => (t) => other(this(t));
}

/// Base class for all bloc
abstract class BaseController {
  /// close stream controllers, cancel subscriptions
  void dispose();
}

/// Base bloc that implements [BaseController.dispose] by passing callback to constructor,
/// and call it when [BaseController.dispose] called.
class DisposeCallbackBaseController implements BaseController {
  final void Function() _dispose;

  /// Create a [DisposeCallbackBaseController] by a dispose callback.
  DisposeCallbackBaseController(this._dispose);

  @override
  void dispose() => _dispose();
}
