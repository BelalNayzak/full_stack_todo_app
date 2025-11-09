// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, implicit_dynamic_list_literal

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';


import '../routes/index.dart' as index;
import '../routes/user/index.dart' as user_index;
import '../routes/user/[id].dart' as user_$id;
import '../routes/todo/index.dart' as todo_index;
import '../routes/todo/[id].dart' as todo_$id;
import '../routes/chat_with_data/index.dart' as chat_with_data_index;
import '../routes/auth/register.dart' as auth_register;
import '../routes/auth/logout.dart' as auth_logout;
import '../routes/auth/login.dart' as auth_login;

import '../routes/_middleware.dart' as middleware;
import '../routes/user/_middleware.dart' as user_middleware;
import '../routes/todo/_middleware.dart' as todo_middleware;
import '../routes/chat_with_data/_middleware.dart' as chat_with_data_middleware;
import '../routes/auth/_middleware.dart' as auth_middleware;

void main() async {
  final address = InternetAddress.anyIPv6;
  final port = int.tryParse(Platform.environment['PORT'] ?? '8080') ?? 8080;
  createServer(address, port);
}

Future<HttpServer> createServer(InternetAddress address, int port) async {
  final handler = Cascade().add(buildRootHandler()).handler;
  final server = await serve(handler, address, port);
  print('\x1B[92m✓\x1B[0m Running on http://${server.address.host}:${server.port}');
  return server;
}

Handler buildRootHandler() {
  final pipeline = const Pipeline().addMiddleware(middleware.middleware);
  final router = Router()
    ..mount('/auth', (context) => buildAuthHandler()(context))
    ..mount('/chat_with_data', (context) => buildChatWithDataHandler()(context))
    ..mount('/todo', (context) => buildTodoHandler()(context))
    ..mount('/user', (context) => buildUserHandler()(context))
    ..mount('/', (context) => buildHandler()(context));
  return pipeline.addHandler(router);
}

Handler buildAuthHandler() {
  final pipeline = const Pipeline().addMiddleware(auth_middleware.middleware);
  final router = Router()
    ..all('/register', (context) => auth_register.onRequest(context,))..all('/logout', (context) => auth_logout.onRequest(context,))..all('/login', (context) => auth_login.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildChatWithDataHandler() {
  final pipeline = const Pipeline().addMiddleware(chat_with_data_middleware.middleware);
  final router = Router()
    ..all('/', (context) => chat_with_data_index.onRequest(context,));
  return pipeline.addHandler(router);
}

Handler buildTodoHandler() {
  final pipeline = const Pipeline().addMiddleware(todo_middleware.middleware);
  final router = Router()
    ..all('/', (context) => todo_index.onRequest(context,))..all('/<id>', (context,id,) => todo_$id.onRequest(context,id,));
  return pipeline.addHandler(router);
}

Handler buildUserHandler() {
  final pipeline = const Pipeline().addMiddleware(user_middleware.middleware);
  final router = Router()
    ..all('/', (context) => user_index.onRequest(context,))..all('/<id>', (context,id,) => user_$id.onRequest(context,id,));
  return pipeline.addHandler(router);
}

Handler buildHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => index.onRequest(context,));
  return pipeline.addHandler(router);
}

