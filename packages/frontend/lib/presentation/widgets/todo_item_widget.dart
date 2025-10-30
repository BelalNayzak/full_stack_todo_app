import 'package:frontend_flutter/frontend.dart';


class TodoItemWidget extends StatelessWidget {
  final TodoModel todo;

  const TodoItemWidget({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ElevatedHoverCard(
      onTap: () => _handleMenuAction(context, 'toggle'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: _getPriorityColor(todo.priority),
                child: Text(
                  _getPriorityIcon(todo.priority),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${todo.title}',
                      style: textTheme.titleMedium?.copyWith(
                        decoration: todo.status == TodoStatus.done
                            ? TextDecoration.lineThrough
                            : null,
                        color: todo.status == TodoStatus.done
                            ? Colors.grey
                            : null,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('${todo.desc}', style: textTheme.bodySmall),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        _buildStatusChip(todo.status),
                        _buildPriorityChip(todo.priority),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) => _handleMenuAction(context, value),
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'toggle',
                    child: Row(
                      children: [
                        Icon(Icons.toggle_on),
                        SizedBox(width: 8),
                        Text('Toggle Status'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(TodoPriority? priority) {
    switch (priority) {
      case TodoPriority.low:
        return Colors.green;
      case TodoPriority.medium:
        return Colors.orange;
      case TodoPriority.high:
        return Colors.red;
      default:
        return Colors.green;
    }
  }

  String _getPriorityIcon(TodoPriority? priority) {
    switch (priority) {
      case TodoPriority.low:
        return 'L';
      case TodoPriority.medium:
        return 'M';
      case TodoPriority.high:
        return 'H';
      default:
        return 'L';
    }
  }

  Widget _buildStatusChip(TodoStatus? status) {
    Color color;
    String text;

    switch (status) {
      case TodoStatus.todo:
        color = Colors.grey;
        text = 'Todo';
        break;
      case TodoStatus.inProgress:
        color = Colors.blue;
        text = 'In Progress';
        break;
      case TodoStatus.done:
        color = Colors.green;
        text = 'Done';
        break;
      default:
        color = Colors.grey;
        text = 'Todo';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPriorityChip(TodoPriority? priority) {
    Color color;
    String text;

    switch (priority) {
      case TodoPriority.low:
        color = Colors.green;
        text = 'Low';
        break;
      case TodoPriority.medium:
        color = Colors.orange;
        text = 'Medium';
        break;
      case TodoPriority.high:
        color = Colors.red;
        text = 'High';
        break;
      default:
        color = Colors.green;
        text = 'Low';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'toggle':
        context.read<TodoCubit>().toggleTodoStatus(todo);
        break;
      case 'edit':
        _showEditDialog(context);
        break;
      case 'delete':
        _showDeleteConfirmation(context);
        break;
    }
  }

  void _showEditDialog(BuildContext context) {
    final titleController = TextEditingController(text: todo.title);
    final descController = TextEditingController(text: todo.desc);
    TodoPriority? selectedPriority = todo.priority;
    TodoStatus? selectedStatus = todo.status;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Todo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<TodoPriority>(
                    value: selectedPriority,
                    decoration: const InputDecoration(
                      labelText: 'Priority',
                      border: OutlineInputBorder(),
                    ),
                    items: TodoPriority.values
                        .map(
                          (priority) => DropdownMenuItem(
                            value: priority,
                            child: Text(priority.name.toUpperCase()),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => selectedPriority = value,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<TodoStatus>(
                    value: selectedStatus,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    items: TodoStatus.values
                        .map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: Text(status.name.toUpperCase()),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => selectedStatus = value,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty &&
                  descController.text.isNotEmpty) {
                context.read<TodoCubit>().updateTodo(
                  id: todo.id!,
                  title: titleController.text,
                  desc: descController.text,
                  priority: selectedPriority,
                  status: selectedStatus,
                );
                Navigator.of(context).pop();
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Todo'),
        content: Text('Are you sure you want to delete "${todo.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<TodoCubit>().deleteTodo(todo.id!);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
