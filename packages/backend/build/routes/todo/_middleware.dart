import 'package:backend_dart_frog/backend.dart';

Handler middleware(Handler handler) {
  return handler.use(
    provider<TodoRepo>((context) {
      final connPool = context.read<Pool>();
      return TodoRepoImplSQL(connPool: connPool);
    }),
  ).use(tokenAuthorizationHandler);
}
