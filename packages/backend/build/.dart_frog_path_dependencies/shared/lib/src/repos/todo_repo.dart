import 'package:shared/shared.dart';

abstract class TodoRepo {
  Future<TodoModel> createTodo(TodoModel todoModel);
  Future<List<TodoModel>> getAllTodos(int userId);
  Future<TodoModel?> getTodo(int id);
  Future<TodoModel?> updateTodo(TodoModel updatedTodoModel);
  Future<TodoModel?> deleteTodo(int id);
}
