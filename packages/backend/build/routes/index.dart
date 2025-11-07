import 'package:backend_dart_frog/backend.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _onGet(context),
    _ => Future.value(
      Response(
        statusCode: HttpStatus.methodNotAllowed,
        body: 'Method not allowed',
      ),
    ),
  };
}

Future<Response> _onGet(RequestContext context) async {
  try {
    final result = await context.read<Pool>().execute(
      Sql.named('SELECT * FROM "uptime_robot_msg" ORDER BY "id" ASC'),
    );

    // data processing
    final data = result.map((record) => record.toColumnMap()).toList();

    return Response.json(statusCode: HttpStatus.ok, body: '${data.toString()}');
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body:
          'If the backend is not working properly, Please try again after 1-2 minute(s). The api service could be in sleep-mode and is waking up...',
    );
  }
}
