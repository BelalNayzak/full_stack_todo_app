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
  //! NOTE that on flutter mobile you use "dart.io" for handling http requests
  //! "dart.io" allows GET to have a body (josn)
  //! BUT on flutter web you use browser's "XMLHttpRequest" for handling http requests
  //! "XMLHttpRequest" DON'T allow GET to have a body (josn)
  //!
  //! SO, If we want it to work on both mobile & web,
  //! we use "queryParameters" instead of "json / body / data" (in case we're targetting web)
  //!
  //! Code Examples:
  //! --------------
  //! CORRECT!    final reqQueryParams = context.request.uri.queryParameters;
  //! WRONG!      final reqBody = await context.request.json();
  //! WRONG!      final reqBody = await context.request.body();

  final reqQueryParams = context.request.uri.queryParameters;
  final userId = reqQueryParams['user_id'];

  final data = await context.read<TodoRepo>().getAllTodos(int.parse(userId!));

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
