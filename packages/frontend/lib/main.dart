import 'package:frontend_flutter/frontend.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TodoCubit>(create: (context) => TodoCubit(TodoService())),
        BlocProvider<UserCubit>(create: (context) => UserCubit(UserService())),
        BlocProvider<AuthCubit>(create: (context) => AuthCubit(AuthService())),
      ],
      child: RequestsInspector(
        navigatorKey: navigatorKey,
        enabled: true,
        showInspectorOn: ShowInspectorOn.Both,
        child: MaterialApp(
          title: 'Todo App - Full Stack',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(centerTitle: true, elevation: 2),
            cardTheme: CardThemeData(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              elevation: 4,
            ),
          ),
          home: const LoginScreen(),
        ),
      ),
    );
  }
}
