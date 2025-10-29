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
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.message != null && state.error == null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message!)));

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        }
      },
      child: BlocBuilder<TodoCubit, TodoState>(
        builder: (context, todoState) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Todo App'),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              actions: [
                // Add User Button
                IconButton(
                  onPressed: () => _showLogoutConfirmation(context),
                  icon: const Icon(Icons.logout),
                  tooltip: 'Logout',
                ),
              ],
            ),
            body: Column(
              children: [
                // Error and Success Messages
                if (todoState.error != null)
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
                            todoState.error!,
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              context.read<TodoCubit>().clearError(),
                          icon: Icon(Icons.close, color: Colors.red.shade700),
                        ),
                      ],
                    ),
                  ),

                if (todoState.message != null)
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
                            todoState.message!,
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

                // Loading Indicator
                if (todoState.isLoading) const LinearProgressIndicator(),

                // Todo List
                Expanded(
                  child: todoState.todos.isEmpty && !todoState.isLoading
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.task_alt,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No todos yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Tap the + button to add your first todo',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : const TodoListWidget(),
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
      ),
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
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AuthCubit>().logout();
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
