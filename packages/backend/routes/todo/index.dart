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

// read todo
Future<Response> _onGet(RequestContext context) async {
  final reqBody = await context.request.json() as Map<String, dynamic>;
  final userId = reqBody['user_id'];

  final data = await context.read<TodoRepo>().getAllTodos(userId);

  return Response.json(
    body: {
      "success": true,
      "message": "All Todos",
      "data": data,
    },
  );
}

// create todo
Future<Response> _onPost(RequestContext context) async {
  final reqBody = await context.request.json() as Map<String, dynamic>;

  final TodoModel todoModel = TodoModel.fromJson(reqBody);

  // validate entered data
  if (todoModel.title.isEmptyOrNull || todoModel.userIdFKey.isEmptyOrNull) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'success': false,
        'message': 'Title, Status, and Priotity are all required.',
      },
    );
  }

  final data = await context.read<TodoRepo>().createTodo(todoModel);

  return Response.json(
    statusCode: HttpStatus.ok,
    body: {
      'success': true,
      'message': 'Todo created successfully',
      'data': data,
    },
  );
}
