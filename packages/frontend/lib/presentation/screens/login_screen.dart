import 'package:frontend_flutter/frontend.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = context.isDesktop || context.width >= Breakpoints.md;

    return ResponsiveScaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
          }
          if (state.user != null ||
              (state.token != null && state.token!.isNotEmpty)) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (!isWide) {
            return _AuthForm(
              title: 'Welcome back',
              subtitle: 'Sign in to continue',
              form: _buildForm(state),
              footer: _buildFooterLink(toSignup: true),
            );
          }

          return Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primaryContainer,
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.task_alt_rounded,
                          size: 96,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Your tasks, organized beautifully',
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Manage todos across devices with a modern, responsive UI',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: _AuthForm(
                      title: 'Welcome back',
                      subtitle: 'Sign in to continue',
                      form: _buildForm(state),
                      footer: _buildFooterLink(toSignup: true),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildForm(AuthState state) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Enter email';
              final ok = RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(v);
              return ok ? null : 'Enter valid email';
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Enter password' : null,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.isLoading ? null : _onLogin,
              child: state.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Login'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink({required bool toSignup}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) =>
                toSignup ? const SignupScreen() : const LoginScreen(),
          ),
        ),
        child: Text(
          toSignup
              ? "Don't have an account? Sign up"
              : 'Have an account? Login',
        ),
      ),
    );
  }

  void _onLogin() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().login(
      userModel: UserModel(
        id: null,
        name: null,
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }
}

class _AuthForm extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget form;
  final Widget footer;

  const _AuthForm({
    required this.title,
    required this.subtitle,
    required this.form,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            form,
            const SizedBox(height: 12),
            footer,
          ],
        ),
      ),
    );
  }
}
