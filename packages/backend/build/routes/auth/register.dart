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

// register
Future<Response> _onPost(RequestContext context) async {
  final reqBody = await context.request.json() as Map<String, dynamic>;

  // hash the password before saving in db (if it's not null)
  final hashPassword = reqBody['password'] == null
      ? null
      : BCrypt.hashpw(reqBody['password'], BCrypt.gensalt());

  reqBody['password'] = hashPassword;

  final UserModel userModel = UserModel.fromJson(reqBody);

  // validate entered data
  if (userModel.name.isEmptyOrNull ||
      userModel.email.isEmptyOrNull ||
      userModel.password.isEmptyOrNull) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'success': false,
        'message': 'Name, Email and Password are required.',
      },
    );
  }

  try {
    // Register!
    final data = await context.read<AuthRepo>().register(userModel);

    // return response
    return Response.json(
      statusCode: HttpStatus.ok,
      body: {
        'success': true,
        'message': 'User registered successfully',
        'data': data,
      },
    );
  } catch (e) {
    // Check for unique constraint violation
    if (e.toString().contains('unique_email')) {
      return Response.json(
        statusCode: HttpStatus.conflict,
        body: {'error': 'Email already exists'},
      );
    }

    // For all other errors
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Something went wrong', 'details': e.toString()},
    );
  }
}
