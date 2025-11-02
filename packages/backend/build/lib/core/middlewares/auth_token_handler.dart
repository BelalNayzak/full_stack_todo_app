import 'package:backend_dart_frog/backend.dart';

Handler tokenAuthorizationHandler(Handler handler) {
  return handler.use(
    bearerAuthentication<int>(
      authenticator: (context, token) async {
        try {
          final userId = TokenHelper.verifyToken(token);
          if (userId == null) return null;

          final isUserExists =
              null != (await context.read<UserRepo>().getUserById(userId));
          if (!isUserExists) return null;

          return userId;
        } catch (e) {
          print('$e');
          return null;
        }
      },
    ),
  ).use(
    provider<UserRepo>((context) {
      final connPool = context.read<Pool>();
      return UserRepoImplSQL(connPool: connPool);
    }),
  );
}
