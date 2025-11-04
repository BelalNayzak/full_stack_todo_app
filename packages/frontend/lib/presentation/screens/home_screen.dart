import 'package:frontend_flutter/frontend.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userCubit = context.read<UserCubit>();
      final todoCubit = context.read<TodoCubit>();

      userCubit.loadUserData().then(
        (_) => todoCubit.loadAllTodos(userCubit.state.user!.id!),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (context.isDesktop) return const HomeScreenWeb();

    return BlocBuilder<TodoCubit, TodoState>(
      builder: (context, state) {
        final todos = state.visibleTodos;
        return Scaffold(
          appBar: FancyAppBar(
            title:
                'Welcome back, ${context.read<UserCubit>().state.user?.name ?? ''}! 👋',
            actions: [
              IconButton(
                tooltip: state.viewMode == ViewMode.list ? 'Grid' : 'List',
                onPressed: () => context.read<TodoCubit>().setViewMode(
                  state.viewMode == ViewMode.list
                      ? ViewMode.grid
                      : ViewMode.list,
                ),
                icon: Icon(
                  state.viewMode == ViewMode.list
                      ? Icons.grid_view_rounded
                      : Icons.view_agenda_rounded,
                ),
              ),
              IconButton(
                onPressed: () => _showLogoutConfirmation(context),
                icon: const Icon(Icons.logout),
                tooltip: 'Logout',
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Wrap(
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
              ),

              if (state.error != null)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error, color: Colors.red.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          state.error!,
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),
                      IconButton(
                        onPressed: () => context.read<TodoCubit>().clearError(),
                        icon: Icon(Icons.close, color: Colors.red.shade700),
                      ),
                    ],
                  ),
                ),

              if (state.message != null)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          state.message!,
                          style: TextStyle(color: Colors.green.shade700),
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            context.read<TodoCubit>().clearMessage(),
                        icon: Icon(Icons.close, color: Colors.green.shade700),
                      ),
                    ],
                  ),
                ),

              if (state.isLoading) const LinearProgressIndicator(),

              Expanded(
                child: Builder(
                  builder: (_) {
                    if (todos.isEmpty && !state.isLoading) {
                      return const Center(child: Text('No todos yet'));
                    }
                    if (state.viewMode == ViewMode.grid) {
                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio:
                                  3 / 3, // Increased height for mobile
                            ),
                        itemCount: todos.length,
                        itemBuilder: (_, i) => TodoItemWidget(todo: todos[i]),
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: todos.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, i) => TodoItemWidget(todo: todos[i]),
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddTodoDialog(context),
            tooltip: 'Add Todo',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => const AddTodoDialog());
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
