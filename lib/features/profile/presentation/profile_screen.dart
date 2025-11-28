import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/data/auth_repository.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserDocProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: user.when(
        data: (u) {
          if (u == null) return const Center(child: Text('No profile'));
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${u.name}'),
                Text('Phone: ${u.phone}'),
                Text('Role: ${u.role.name}'),
                if (u.businessName != null) Text('Business: ${u.businessName}'),
                if (u.businessAddress != null) Text('Address: ${u.businessAddress}'),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => ref.read(authRepositoryProvider).logout(),
                  child: const Text('Logout'),
                )
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
