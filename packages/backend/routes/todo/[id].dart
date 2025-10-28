import 'package:backend_dart_frog/backend.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  return switch (context.request.method) {
    HttpMethod.get => _onGet(context, id),
    HttpMethod.put => _onPut(context, id),
    HttpMethod.delete => _onDelete(context, id),
    _ => Future.value(
        Response(
          statusCode: HttpStatus.methodNotAllowed,
          body: 'Method not allowed',
        ),
      ),
  };
}

// read todo
Future<Response> _onGet(RequestContext context, String id) async {
  // validate entered data
  if (id.isEmptyOrNull) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'success': false,
        'message': 'Enter proper todo id to get this todo.',
      },
    );
  }

  final data = await context.read<TodoRepo>().getTodo(int.parse(id));

  // data list is empty if todo not exist
  // we can't get an unexist todo!
  if (data == null) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'success': false,
        'message': 'Todo with id:$id not exists.',
      },
    );
  }

  return Response.json(
    body: {
      "success": true,
      "message": "Todo $id",
      "data": data,
    },
  );
}

// update todo
Future<Response> _onPut(RequestContext context, String id) async {
  // validate entered data
  if (id.isEmptyOrNull) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'success': false,
        'message': 'Enter proper todo id to get this todo.',
      },
    );
  }

  final reqBody = await context.request.json() as Map<String, dynamic>;
  reqBody['id'] =
      int.parse(id); // assign the id to the reqBody from the named param id

  final TodoModel updatedTodoModel = TodoModel.fromJson(reqBody);

  final data = await context.read<TodoRepo>().updateTodo(updatedTodoModel);

  // data list is empty if todo not exist
  // we can't delete an unexist todo!
  if (data == null) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'success': false,
        'message': 'Todo with id:$id not exists.',
      },
    );
  }

  return Response.json(
    statusCode: HttpStatus.ok,
    body: {
      'success': true,
      'message': 'Todo updated successfully',
      'todo': data,
    },
  );
}

// delete todo
Future<Response> _onDelete(RequestContext context, String id) async {
  // validate entered data
  if (id.isEmptyOrNull) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'success': false,
        'message': 'Enter proper todo id to delete this todo.',
      },
    );
  }

  final data = await context.read<TodoRepo>().deleteTodo(int.parse(id));

  // data list is empty if todo not exist
  // we can't delete an unexist todo!
  if (data == null) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'success': false,
        'message': 'Todo with id:$id not exists.',
      },
    );
  }

  return Response.json(
    statusCode: HttpStatus.ok,
    body: {
      'success': true,
      'message': 'Todo deleted successfully',
      'todo': data,
    },
  );
}
