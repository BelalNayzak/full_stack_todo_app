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

// chat with data
Future<Response> _onPost(RequestContext context) async {
  final reqBody = await context.request.json() as Map<String, dynamic>;
  final userMsg = reqBody['message'] as String;
  final userId = reqBody['user_id'] as int;

  try {
    final data = await context.read<ChatWithDataRepo>().chatWithData(
      userId,
      userMsg,
    );

    // 5️⃣ Return to Flutter
    return Response.json(
      statusCode: HttpStatus.ok,
      body: {
        'success': true,
        'message': data.responseMsg,
        'data': data.responseData,
      },
    );
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'success': false,
        'message':
            'Unsafe SQL Query. It seems you\'re requesting a heavy or a non authorized data',
        'ERR': e.toString(),
      },
    );
  }
}
