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

// read user
Future<Response> _onGet(RequestContext context, String id) async {
  // validate entered data
  if (id.isEmptyOrNull) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'success': false,
        'message': 'Enter proper user id to get this user.',
      },
    );
  }

  final data = await context.read<UserRepo>().getUserById(int.parse(id));

  // data list is empty if user not exist
  // we can't get an unexist user!
  if (data == null) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'success': false,
        'message': 'User with id:$id not exists.',
      },
    );
  }

  return Response.json(
    body: {
      "success": true,
      "message": "User $id",
      "data": data,
    },
  );
}

// update user
Future<Response> _onPut(RequestContext context, String id) async {
  // validate entered data
  if (id.isEmptyOrNull) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'success': false,
        'message': 'Enter proper user id to edit this user.',
      },
    );
  }

  final reqBody = await context.request.json() as Map<String, dynamic>;
  reqBody['id'] =
      int.parse(id); // assign the id to the reqBody from the named param id

  final updatedUserModel = UserModel.fromJson(reqBody);

  final data = await context.read<UserRepo>().updateUser(updatedUserModel);

  // data list is empty if user not exist
  // we can't delete an unexist user!
  if (data == null) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'success': false,
        'message': 'User with id:$id not exists.',
      },
    );
  }

  return Response.json(
    statusCode: HttpStatus.ok,
    body: {
      'success': true,
      'message': 'User updated successfully',
      'data': data,
    },
  );
}

// delete user
Future<Response> _onDelete(RequestContext context, String id) async {
  // validate entered data
  if (id.isEmptyOrNull) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'success': false,
        'message': 'Enter proper user id to delete this user.',
      },
    );
  }

  final data = await context.read<UserRepo>().deleteUser(int.parse(id));

  // data list is empty if user not exist
  // we can't delete an unexist user!
  if (data == null) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'success': false,
        'message': 'User with id:$id not exists.',
      },
    );
  }

  return Response.json(
    statusCode: HttpStatus.ok,
    body: {
      'success': true,
      'message': 'User deleted successfully',
      'data': data,
    },
  );
}
