import 'package:backend_dart_frog/backend.dart';

Handler middleware(Handler handler) {
  return handler.use(provider<UserRepo>(
    (context) {
      final connPool = context.read<Pool>();
      return UserRepoImplSQL(connPool: connPool);
    },
  )).use(provider<AuthRepo>(
    (context) {
      final connPool = context.read<Pool>();
      return AuthRepoImplSQL(connPool: connPool);
    },
  ));
}
