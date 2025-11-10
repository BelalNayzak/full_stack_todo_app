import 'package:frontend_flutter/frontend.dart';

class HomeScreenWeb extends StatelessWidget {
  const HomeScreenWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return ResponsiveScaffold(
          appBar: FancyAppBar(
            title:
                'Welcome back, ${context.read<UserCubit>().state.user?.name ?? ''}! 👋',
          ),
          sidebar: _Sidebar(),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: BlocBuilder<TodoCubit, TodoState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SkeletonBox(height: 24, width: 240),
                      SizedBox(height: 12),
                      Expanded(child: SkeletonGrid()),
                    ],
                  );
                }

                final todos = state.visibleTodos;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state.error != null)
                      _Banner(message: state.error!, isError: true),
                    if (state.message != null)
                      _Banner(message: state.message!, isError: false),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Wrap(
                          spacing: 8,
                          children: [
                            FilterChip(
                              label: const Text('All'),
                              selected: state.filter == TodoFilter.all,
                              onSelected: (_) => context
                                  .read<TodoCubit>()
                                  .setFilter(TodoFilter.all),
                            ),
                            FilterChip(
                              label: const Text('Todo'),
                              selected: state.filter == TodoFilter.todo,
                              onSelected: (_) => context
                                  .read<TodoCubit>()
                                  .setFilter(TodoFilter.todo),
                            ),
                            FilterChip(
                              label: const Text('In Progress'),
                              selected: state.filter == TodoFilter.inProgress,
                              onSelected: (_) => context
                                  .read<TodoCubit>()
                                  .setFilter(TodoFilter.inProgress),
                            ),
                            FilterChip(
                              label: const Text('Done'),
                              selected: state.filter == TodoFilter.done,
                              onSelected: (_) => context
                                  .read<TodoCubit>()
                                  .setFilter(TodoFilter.done),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Tooltip(
                          message: 'Switch view',
                          child: SegmentedButton<ViewMode>(
                            segments: const [
                              ButtonSegment(
                                value: ViewMode.list,
                                icon: Icon(Icons.view_agenda_outlined),
                                label: Text('List'),
                              ),
                              ButtonSegment(
                                value: ViewMode.grid,
                                icon: Icon(Icons.dashboard_outlined),
                                label: Text('Grid'),
                              ),
                              ButtonSegment(
                                value: ViewMode.board,
                                icon: Icon(Icons.view_kanban_outlined),
                                label: Text('Board'),
                              ),
                            ],
                            selected: {state.viewMode},
                            onSelectionChanged: (set) => context
                                .read<TodoCubit>()
                                .setViewMode(set.first),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: _buildBodyForMode(state, todos),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          floatingActionButton: ExpandableFab(
            onCreateTodo: () => showDialog(
              context: context,
              builder: (_) => const AddTodoDialog(),
            ),
            onChatWithData: () => showDialog(
              context: context,
              builder: (_) => const ChatDialogWeb(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBodyForMode(TodoState state, List<TodoModel> todos) {
    switch (state.viewMode) {
      case ViewMode.list:
        if (todos.isEmpty) return const _EmptyState();
        return ListView.separated(
          itemCount: todos.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) => TodoItemWidget(todo: todos[i]),
        );
      case ViewMode.grid:
        if (todos.isEmpty) return const _EmptyState();
        return LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth >= 1400 ? 3 : 2;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 4 / 2,
              ),
              itemCount: todos.length,
              itemBuilder: (_, i) => TodoItemWidget(todo: todos[i]),
            );
          },
        );
      case ViewMode.board:
        return Row(
          children: [
            Expanded(
              child: _BoardColumn(
                title: 'Todo',
                color: Colors.grey,
                items: state.todos
                    .where((t) => t.status == TodoStatus.todo)
                    .toList(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _BoardColumn(
                title: 'In Progress',
                color: Colors.blue,
                items: state.todos
                    .where((t) => t.status == TodoStatus.inProgress)
                    .toList(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _BoardColumn(
                title: 'Done',
                color: Colors.green,
                items: state.todos
                    .where((t) => t.status == TodoStatus.done)
                    .toList(),
              ),
            ),
          ],
        );
    }
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
              CircleAvatar(
                radius: 16,
                backgroundColor: scheme.primary,
                backgroundImage: AssetImage('assets/images/belal.jpeg'),
              ),
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
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () => _showLogoutConfirmation(context),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AuthCubit>().logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _BoardColumn extends StatelessWidget {
  final String title;
  final Color color;
  final List<TodoModel> items;
  const _BoardColumn({
    required this.title,
    required this.color,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                Tooltip(
                  message: 'Add',
                  child: IconButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => const AddTodoDialog(),
                    ),
                    icon: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (items.isEmpty)
              const Expanded(child: Center(child: Text('No items')))
            else
              Expanded(
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) => TodoItemWidget(todo: items[i]),
                ),
              ),
          ],
        ),
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
