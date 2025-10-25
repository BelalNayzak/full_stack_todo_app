import 'package:shared/src/models/todo_model.dart';

abstract class TodoRepo {
  Future<List<TodoModel>> getAllTodos();
  Future<TodoModel?> getTodo(int id);
  Future<TodoModel?> deleteTodo(int id);
  Future<TodoModel> addTodo(TodoModel todoModel);
  Future<TodoModel> updateTodo(TodoModel updatedTodoModel);
}
