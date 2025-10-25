// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodoModel _$TodoModelFromJson(Map<String, dynamic> json) => TodoModel(
  id: (json['id'] as num?)?.toInt(),
  userIdFKey: (json['user_id'] as num?)?.toInt(),
  title: json['title'] as String?,
  desc: json['desc'] as String?,
  priority: $enumDecodeNullable(_$TodoPriorityEnumMap, json['priority']),
  status: $enumDecodeNullable(_$TodoStatusEnumMap, json['status']),
);

Map<String, dynamic> _$TodoModelToJson(TodoModel instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userIdFKey,
  'title': instance.title,
  'desc': instance.desc,
  'priority': _$TodoPriorityEnumMap[instance.priority],
  'status': _$TodoStatusEnumMap[instance.status],
};

const _$TodoPriorityEnumMap = {
  TodoPriority.low: 'low',
  TodoPriority.medium: 'medium',
  TodoPriority.high: 'high',
};

const _$TodoStatusEnumMap = {
  TodoStatus.todo: 'todo',
  TodoStatus.inProgress: 'inProgress',
  TodoStatus.done: 'done',
};
