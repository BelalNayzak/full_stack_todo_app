import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  return Response.json(
    body: {
      'status': 'ok',
      'message':
          'Backend is running successfully 🎉\n Made with ❤️ By Belal Ashraf',
    },
  );
}
