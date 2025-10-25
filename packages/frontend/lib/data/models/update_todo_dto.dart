import 'package:shared/shared.dart';

class UpdateTodoDto {
  final int id;
  final String? title;
  final String? desc;
  final TodoPriority? priority;
  final TodoStatus? status;

  const UpdateTodoDto({
    required this.id,
    this.title,
    this.desc,
    this.priority,
    this.status,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {'id': id};
    if (title != null) json['title'] = title;
    if (desc != null) json['desc'] = desc;
    if (priority != null) json['priority'] = priority!.name;
    if (status != null) json['status'] = status!.name;
    return json;
  }
}
