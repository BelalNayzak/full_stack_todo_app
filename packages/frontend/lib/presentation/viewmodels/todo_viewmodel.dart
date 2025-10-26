import 'package:frontend_flutter/frontend.dart';

// State classes for different UI states
class TodoState extends Equatable {
  final List<TodoModel> todos;
  final bool isLoading;
  final String? error;
  final String? message;

  const TodoState({
    this.todos = const [],
    this.isLoading = false,
    this.error,
    this.message,
  });

  TodoState copyWith({
    List<TodoModel>? todos,
    bool? isLoading,
    String? error,
    String? message,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      message: message,
    );
  }

  @override
  List<Object?> get props => [todos, isLoading, error, message];
}

// TodoCubit class
class TodoCubit extends Cubit<TodoState> {
  final TodoService _todoService;

  TodoCubit(this._todoService) : super(const TodoState());

  // Load all todos
  Future<void> loadTodos() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final response = await _todoService.getAllTodos();
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

      final response = await _todoService.addTodo(todoModel);
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
