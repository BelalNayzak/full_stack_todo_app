import 'package:frontend_flutter/frontend.dart';

class UserSelectorWidget extends StatelessWidget {
  const UserSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        if (userState.users.isEmpty && !userState.isLoading) {
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: const Row(
              children: [
                Icon(Icons.info, color: Colors.blue),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'No users available. Please add a user first.',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select User:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<UserModel>(
                value: userState.selectedUser,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                hint: const Text('Choose a user'),
                items: userState.users.map((user) {
                  return DropdownMenuItem<UserModel>(
                    value: user,
                    child: Text('${user.name} (${user.email})'),
                  );
                }).toList(),
                onChanged: (UserModel? selectedUser) {
                  if (selectedUser != null) {
                    context.read<UserCubit>().selectUser(selectedUser);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
