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
  final reqBody = await context.request.json() as Map<String, dynamic>;
  final String userEmail = reqBody['email'];
  final String userPassword = reqBody['password']; // user normal password

  // validate entered data
  if (userEmail.isEmptyOrNull || userPassword.isEmptyOrNull) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'success': false,
        'message': 'Email and Password are required.',
      },
    );
  }

  final data = await context
      .read<UserRepo>()
      .getUserByEmail(userEmail); // contains user hash password

  // return no user exist with that email, just in case
  if (data == null) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'success': false,
        'message': 'Email is not exist.',
      },
    );
  }

  // check normal & hash passwords are equals
  final bool isCorrectPassword = BCrypt.checkpw(userPassword, data.password!);

  // return incorrect password, just in case
  if (!isCorrectPassword) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {
        'success': false,
        'message': 'Incorrect password.',
      },
    );
  }

  // Login!
  final String? token = await context.read<AuthRepo>().login(data.id!);

  if (token == null) {
    return Response.json(
      statusCode: HttpStatus.unauthorized,
      body: {
        'success': false,
        'message': 'Not Authorized.',
      },
    );
  }

  //
  return Response.json(
    statusCode: HttpStatus.ok,
    body: {
      'success': true,
      'message': 'Logged in successfully',
      'token': token, // token (String)
    },
  );
}
