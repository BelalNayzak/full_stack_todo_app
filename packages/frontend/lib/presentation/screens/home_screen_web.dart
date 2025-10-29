import 'package:frontend_flutter/frontend.dart';

class HomeScreenWeb extends StatelessWidget {
  const HomeScreenWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: AppBar(title: const Text('Todo App'), actions: const []),
      sidebar: _Sidebar(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: BlocBuilder<TodoCubit, TodoState>(
          builder: (context, state) {
            final todos = state.visibleTodos;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.isLoading) const LinearProgressIndicator(),
                if (state.error != null)
                  _Banner(message: state.error!, isError: true),
                if (state.message != null)
                  _Banner(message: state.message!, isError: false),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: [
                    FilterChip(
                      label: const Text('All'),
                      selected: state.filter == TodoFilter.all,
                      onSelected: (_) =>
                          context.read<TodoCubit>().setFilter(TodoFilter.all),
                    ),
                    FilterChip(
                      label: const Text('Todo'),
                      selected: state.filter == TodoFilter.todo,
                      onSelected: (_) =>
                          context.read<TodoCubit>().setFilter(TodoFilter.todo),
                    ),
                    FilterChip(
                      label: const Text('In Progress'),
                      selected: state.filter == TodoFilter.inProgress,
                      onSelected: (_) => context.read<TodoCubit>().setFilter(
                        TodoFilter.inProgress,
                      ),
                    ),
                    FilterChip(
                      label: const Text('Done'),
                      selected: state.filter == TodoFilter.done,
                      onSelected: (_) =>
                          context.read<TodoCubit>().setFilter(TodoFilter.done),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isGrid = constraints.maxWidth >= 900;
                      if (todos.isEmpty && !state.isLoading) {
                        return const _EmptyState();
                      }
                      if (isGrid) {
                        final crossAxisCount = constraints.maxWidth >= 1400
                            ? 3
                            : 2;
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 4 / 2,
                              ),
                          itemCount: todos.length,
                          itemBuilder: (_, i) => TodoItemWidget(todo: todos[i]),
                        );
                      }
                      return ListView.separated(
                        itemCount: todos.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, i) => TodoItemWidget(todo: todos[i]),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            showDialog(context: context, builder: (_) => const AddTodoDialog()),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final state = context.watch<TodoCubit>().state;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 16, backgroundColor: scheme.primary),
              const SizedBox(width: 8),
              Text('Tasks', style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.list_alt_outlined),
            title: const Text('All Todos'),
            selected: state.filter == TodoFilter.all,
            onTap: () => context.read<TodoCubit>().setFilter(TodoFilter.all),
          ),
          ListTile(
            leading: const Icon(Icons.playlist_add_check_circle_outlined),
            title: const Text('Todo'),
            selected: state.filter == TodoFilter.todo,
            onTap: () => context.read<TodoCubit>().setFilter(TodoFilter.todo),
          ),
          ListTile(
            leading: const Icon(Icons.alarm),
            title: const Text('In Progress'),
            selected: state.filter == TodoFilter.inProgress,
            onTap: () =>
                context.read<TodoCubit>().setFilter(TodoFilter.inProgress),
          ),
          ListTile(
            leading: const Icon(Icons.done_all_outlined),
            title: const Text('Completed'),
            selected: state.filter == TodoFilter.done,
            onTap: () => context.read<TodoCubit>().setFilter(TodoFilter.done),
          ),
          const Spacer(),
          OutlinedButton.icon(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => const AddTodoDialog(),
            ),
            icon: const Icon(Icons.add),
            label: const Text('New Todo'),
          ),
        ],
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  final String message;
  final bool isError;
  const _Banner({required this.message, required this.isError});

  @override
  Widget build(BuildContext context) {
    final color = isError ? Colors.red : Colors.green;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.check_circle,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message, style: TextStyle(color: color)),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.task_alt, size: 96, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No todos yet',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Tap the + button to add your first todo',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
