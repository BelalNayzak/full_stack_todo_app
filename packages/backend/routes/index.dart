import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  return Response.json(
    body:
        '''|   Made with ❤️ by Belal Ashraf   |   Backend is running successfully 🎉   |''',
  );
}
