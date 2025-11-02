import 'package:backend_dart_frog/backend.dart';

class UserRepoImplSQL implements UserRepo {
  final Pool connPool;

  UserRepoImplSQL({required this.connPool});

  @override
  Future<UserModel> createUser(UserModel userModel) async {
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
  Future<UserModel?> deleteUser(int id) async {
    final result = await connPool.execute(
      Sql.named('DELETE FROM "user" WHERE "id"=@id RETURNING *'),
      parameters: {
        'id': id,
      },
    );

    if (result.isEmpty) return null; // means no user item with the passed id

    // data processing
    final data = result
        .map((record) => UserModel.fromJson(record.toColumnMap()))
        .toList();

    return data.first;
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    final result =
        await connPool.execute('SELECT * FROM "user" ORDER BY "id" ASC'); // all

    final data = result
        .map((record) => UserModel.fromJson(record.toColumnMap()))
        .toList();

    return data;
  }

  @override
  Future<UserModel?> getUserById(int id) async {
    final result = await connPool.execute(
      Sql.named('SELECT * FROM "user" WHERE "id"=@id'),
      parameters: {'id': id},
    );

    if (result.isEmpty) return null; // means no user item with the passed id

    final data = result
        .map((record) => UserModel.fromJson(record.toColumnMap()))
        .toList();

    return data.first;
  }

  @override
  Future<UserModel?> getUserByToken(String token) async {
    final userId = TokenHelper.verifyToken(token);
    final user = await getUserById(userId!);
    return user;
  }

  @override
  Future<UserModel?> getUserByEmail(String email) async {
    final result = await connPool.execute(
      Sql.named('SELECT * FROM "user" WHERE "email"=@email'),
      parameters: {'email': email},
    );

    if (result.isEmpty) return null; // means no user item with the passed id

    final data = result
        .map((record) => UserModel.fromJson(record.toColumnMap()))
        .toList();

    return data.first;
  }

  @override
  Future<UserModel?> updateUser(UserModel updatedUserModel) async {
    final result = await connPool.execute(
      Sql.named(
          'UPDATE "user" SET "name" = COALESCE(@name, "name"), "password" = COALESCE(@password, "password") WHERE "id"=@id RETURNING *'),
      parameters: {
        'id': updatedUserModel.id,
        'name': updatedUserModel.name,
        'password': updatedUserModel.password,
      },
    );

    if (result.isEmpty) return null; // means no user item with the passed id

    // data processing
    final data = result
        .map((record) => UserModel.fromJson(record.toColumnMap()))
        .toList();

    return data.first;
  }
}
