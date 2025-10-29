import 'package:frontend_flutter/frontend.dart';

enum TodoFilter { all, todo, inProgress, done }

// State classes for different UI states
class TodoState extends Equatable {
  final List<TodoModel> todos;
  final bool isLoading;
  final String? error;
  final String? message;
  final TodoFilter filter;

  const TodoState({
    this.todos = const [],
    this.isLoading = false,
    this.error,
    this.message,
    this.filter = TodoFilter.all,
  });

  List<TodoModel> get visibleTodos {
    switch (filter) {
      case TodoFilter.todo:
        return todos.where((t) => t.status == TodoStatus.todo).toList();
      case TodoFilter.inProgress:
        return todos.where((t) => t.status == TodoStatus.inProgress).toList();
      case TodoFilter.done:
        return todos.where((t) => t.status == TodoStatus.done).toList();
      case TodoFilter.all:
        return todos;
    }
  }

  TodoState copyWith({
    List<TodoModel>? todos,
    bool? isLoading,
    String? error,
    String? message,
    TodoFilter? filter,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      message: message,
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object?> get props => [todos, isLoading, error, message, filter];
}

// TodoCubit class
class TodoCubit extends Cubit<TodoState> {
  final TodoService _todoService;

  TodoCubit(this._todoService) : super(const TodoState());

  void setFilter(TodoFilter filter) => emit(state.copyWith(filter: filter));

  // Load all todos
  Future<void> loadAllTodos(int userId) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final response = await _todoService.getAllTodos(userId);
      emit(
        state.copyWith(
          todos: response,
          isLoading: false,
          message: 'All Tasks loaded successfully.',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e is NetworkException
              ? e.message
              : 'An unexpected error occurred',
        ),
      );
    }
  }

  // Create a new todo
  Future<void> createTodo({
    required String title,
    required String desc,
    required TodoPriority priority,
    required TodoStatus status,
    required int userId,
  }) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final todoModel = TodoModel(
        id: null,
        title: title,
        desc: desc,
        priority: priority,
        status: status,
        userIdFKey: userId,
      );

      final response = await _todoService.createTodo(todoModel);
      final updatedTodos = [response, ...state.todos];
      emit(
        state.copyWith(
          todos: updatedTodos,
          isLoading: false,
          message: 'Todo created successfully.',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e is NetworkException
              ? e.message
              : 'An unexpected error occurred',
        ),
      );
    }
  }

  // Update an existing todo
  Future<void> updateTodo({
    required int id,
    String? title,
    String? desc,
    TodoPriority? priority,
    TodoStatus? status,
  }) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final todoModel = TodoModel(
        id: id,
        userIdFKey: null,
        title: title,
        desc: desc,
        priority: priority,
        status: status,
      );

      final response = await _todoService.updateTodo(todoModel);
      final updatedTodos = state.todos.map((todo) {
        return todo.id == id ? response : todo;
      }).toList();

      emit(
        state.copyWith(
          todos: updatedTodos,
          isLoading: false,
          message: 'Todo updated successfully.',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e is NetworkException
              ? e.message
              : 'An unexpected error occurred',
        ),
      );
    }
  }

  // Delete a todo
  Future<void> deleteTodo(int id) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      await _todoService.deleteTodo(id);
      final updatedTodos = state.todos.where((todo) => todo.id != id).toList();
      emit(
        state.copyWith(
          todos: updatedTodos,
          isLoading: false,
          message: 'Todo deleted successfully.',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e is NetworkException
              ? e.message
              : 'An unexpected error occurred',
        ),
      );
    }
  }

  // Toggle todo status
  Future<void> toggleTodoStatus(TodoModel todo) async {
    TodoStatus newStatus;
    switch (todo.status) {
      case TodoStatus.todo:
        newStatus = TodoStatus.inProgress;
        break;
      case TodoStatus.inProgress:
        newStatus = TodoStatus.done;
        break;
      case TodoStatus.done:
        newStatus = TodoStatus.todo;
        break;
      default:
        newStatus = TodoStatus.inProgress;
        break;
    }

    await updateTodo(id: todo.id!, status: newStatus);
  }

  // Clear error message
  void clearError() {
    emit(state.copyWith(error: null));
  }

  // Clear success message
  void clearMessage() {
    emit(state.copyWith(message: null));
  }
}
