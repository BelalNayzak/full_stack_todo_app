import 'package:backend_dart_frog/backend.dart';

class AuthRepoImplSQL implements AuthRepo {
  final Pool connPool;

  AuthRepoImplSQL({required this.connPool});

  @override
  Future<UserModel> register(UserModel userModel) async {
    // excecute query
    final result = await connPool.execute(
      Sql.named(
          'INSERT INTO "user"("name", "email", "password") VALUES(@name, @email, @password) RETURNING *'),
      parameters: {
        'name': userModel.name,
        'email': userModel.email,
        'password': userModel.password,
      },
    );

    final data = result
        .map((record) => UserModel.fromJson(record.toColumnMap()))
        .toList();

    return data.first;
  }

  @override
  Future<String?> login(UserModel userModel) async {
    // just create and return the token here
    return TokenHelper.generateToken(userModel.id!);
  }

  @override
  Future<void> logout() async {
    // JWT-based logout does not require server action
    // Client should simply delete the token locally
    // Note: for better experience, you can utilize a refresh token mechanism
    return;
  }
}
