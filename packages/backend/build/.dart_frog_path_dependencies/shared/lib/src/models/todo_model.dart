import 'package:shared/shared.dart';

part 'todo_model.g.dart';

@JsonSerializable()
class TodoModel extends Equatable {
  final int? id;
  @JsonKey(name: 'user_id')
  final int? userIdFKey;
  final String? title;
  final String? desc;
  final TodoPriority? priority;
  final TodoStatus? status;

  const TodoModel({
    required this.id,
    required this.userIdFKey,
    required this.title,
    required this.desc,
    required this.priority,
    required this.status,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);

  Map<String, dynamic> toJson() => _$TodoModelToJson(this);

  @override
  List<Object?> get props => [id, userIdFKey, title, desc, priority, status];
}
