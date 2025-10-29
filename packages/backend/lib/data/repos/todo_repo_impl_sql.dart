import 'package:backend_dart_frog/backend.dart';

class TodoRepoImplSQL implements TodoRepo {
  final Pool connPool;

  TodoRepoImplSQL({required this.connPool});

  @override
  Future<TodoModel> createTodo(TodoModel todoModel) async {
    // excecute query
    final result = await connPool.execute(
      Sql.named('''
      INSERT INTO "todo"("title", "desc", "status", "priority", "user_id")
        VALUES(@title, @desc, @status, @priority, @user_id)
      RETURNING *
    '''),
      parameters: {
        'title': todoModel.title,
        'desc': todoModel.desc,
        'status': todoModel.status?.name,
        'priority': todoModel.priority?.name,
        'user_id': todoModel.userIdFKey,
      },
    );

    // data processing
    final data = result
        .map((record) => TodoModel.fromJson(record.toColumnMap()))
        .toList();

    return data.first;
  }

  @override
  Future<TodoModel?> deleteTodo(int id) async {
    final result = await connPool.execute(
      Sql.named('DELETE FROM "todo" WHERE "id"=@id RETURNING *'),
      parameters: {
        'id': id,
      },
    );

    if (result.isEmpty) return null; // means no todo item with the passed id

    // data processing
    final data = result
        .map((record) => TodoModel.fromJson(record.toColumnMap()))
        .toList();

    return data.first;
  }

  @override
  Future<List<TodoModel>> getAllTodos(int userId) async {
    final result = await connPool.execute(
      Sql.named(
          'SELECT * FROM "todo" WHERE "user_id"=@user_id ORDER BY "id" ASC'),
      parameters: {'user_id': userId},
    ); // all user todos

    // data processing
    final data = result
        .map((record) => TodoModel.fromJson(record.toColumnMap()))
        .toList();

    return data;
  }

  @override
  Future<TodoModel?> getTodo(int id) async {
    final result = await connPool.execute(
      Sql.named('SELECT * FROM "todo" WHERE "id"=@id'),
      parameters: {'id': id},
    );

    if (result.isEmpty) return null; // means no todo item with the passed id

    // data processing
    final data = result
        .map((record) => TodoModel.fromJson(record.toColumnMap()))
        .toList();

    return data.first;
  }

  @override
  Future<TodoModel?> updateTodo(TodoModel updatedTodoModel) async {
    // excecute query
    final result = await connPool.execute(
      Sql.named('''
        UPDATE "todo" 
        SET "title" = COALESCE(@title, "title"), 
          "desc" = COALESCE(@desc, "desc"),
          "status" = COALESCE(@status, "status"),
          "priority" = COALESCE(@priority, "priority")
        WHERE "id"=@id RETURNING *
      '''),
      parameters: {
        'id': updatedTodoModel.id,
        'title': updatedTodoModel.title,
        'desc': updatedTodoModel.desc,
        'status': updatedTodoModel.status?.name,
        'priority': updatedTodoModel.priority?.name,
      },
    );

    if (result.isEmpty) return null; // means no todo item with the passed id

    // data processing
    final data = result
        .map((record) => TodoModel.fromJson(record.toColumnMap()))
        .toList();

    return data.first;
  }
}
