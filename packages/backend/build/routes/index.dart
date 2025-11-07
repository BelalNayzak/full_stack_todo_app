import 'package:backend_dart_frog/backend.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _onGet(context),
    HttpMethod.post => _onPost(context),
    _ => Future.value(
      Response(
        statusCode: HttpStatus.methodNotAllowed,
        body: 'Method not allowed',
      ),
    ),
  };
}

Future<Response> _onGet(RequestContext context) async {
  return Response.json(
    body:
        '''|   Backend is running successfully 🎉   |   Made with ❤️ by Belal Ashraf   |''',
  );
}

Future<Response> _onPost(RequestContext context) async {
  try {
    final result = await context.read<Pool>().execute(
      Sql.named('SELECT * FROM "uptime_robot_msg" ORDER BY "id" ASC'),
    );

    // data processing
    final data = result.map((record) => record.toColumnMap()).toList();

    return Response.json(
      statusCode: HttpStatus.ok,
      body: '${data.first['msg']}',
    );
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body:
          'Sorry, Please try again after in 1-2 minute(s). The api was in sleep-mode and it\'s waking up now...',
    );
  }
}
