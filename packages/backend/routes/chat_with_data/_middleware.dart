import 'package:backend_dart_frog/backend.dart';

Handler middleware(Handler handler) {
  return handler.use(
    provider<ChatWithDataRepo>((context) {
      final connPool = context.read<Pool>();
      return ChatWithDataRepoImplSQL(connPool: connPool);
    }),
  );
}
