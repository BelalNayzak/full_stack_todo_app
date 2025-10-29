import 'package:backend_dart_frog/backend.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => _onPost(context),
    _ => Future.value(
        Response(
          statusCode: HttpStatus.methodNotAllowed,
          body: 'Method not allowed',
        ),
      ),
  };
}

// login
Future<Response> _onPost(RequestContext context) async {
  await context.read<AuthRepo>().logout();

  // return response
  return Response.json(
    statusCode: HttpStatus.ok,
    body: {
      'success': true,
      'message': 'Logged out successfully',
    },
  );
}
