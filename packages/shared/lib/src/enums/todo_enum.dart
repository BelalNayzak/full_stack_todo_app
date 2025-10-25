enum TodoPriority {
  low,
  medium,
  high;

  static TodoPriority fromName(String name) {
    return switch (name) {
      'low' => TodoPriority.low,
      'medium' => TodoPriority.medium,
      'high' => TodoPriority.high,
      _ => TodoPriority.low,
    };
  }
}

enum TodoStatus {
  todo,
  inProgress,
  done;

  static TodoStatus fromName(String name) {
    return switch (name) {
      'todo' => TodoStatus.todo,
      'inProgress' => TodoStatus.inProgress,
      'done' => TodoStatus.done,
      _ => TodoStatus.todo,
    };
  }
}
