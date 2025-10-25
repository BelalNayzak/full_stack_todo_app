import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../viewmodels/todo_viewmodel.dart';
import 'todo_item_widget.dart';

class TodoListWidget extends StatelessWidget {
  const TodoListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoCubit, TodoState>(
      builder: (context, todoState) {
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: todoState.todos.length,
          itemBuilder: (context, index) {
            final todo = todoState.todos[index];
            return TodoItemWidget(todo: todo);
          },
        );
      },
    );
  }
}
