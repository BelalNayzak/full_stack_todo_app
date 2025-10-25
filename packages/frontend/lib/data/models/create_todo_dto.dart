import 'package:shared/shared.dart';

class CreateTodoDto {
  final String title;
  final String desc;
  final TodoPriority priority;
  final TodoStatus status;
  final int userIdFKey;

  const CreateTodoDto({
    required this.title,
    required this.desc,
    required this.priority,
    required this.status,
    required this.userIdFKey,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'desc': desc,
    'priority': priority.name,
    'status': status.name,
    'user_id': userIdFKey,
  };
}
