import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  return Response.json(
    body:
        '''|   Backend is running successfully 🎉   |   Made with ❤️ by Belal Ashraf   |''',
  );
}
