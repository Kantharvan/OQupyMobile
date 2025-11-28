import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/studio_repository.dart';
import '../../auth/data/auth_repository.dart';
import 'package:go_router/go_router.dart';

class OwnerStudiosScreen extends ConsumerWidget {
  const OwnerStudiosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserDocProvider).asData?.value;
    final studios = ref.watch(ownerStudiosProvider(user?.id ?? ''));
    return Scaffold(
      appBar: AppBar(title: const Text('My Studios')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/owner/studios/new'),
        child: const Icon(Icons.add),
      ),
      body: studios.when(
        data: (list) => ListView(
          children: list
              .map((s) => Card(
                    child: ListTile(
                      title: Text(s.name),
                      subtitle: Text('${s.location}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => context.go('/owner/studios/${s.id}/edit'),
                      ),
                      onTap: () => context.go('/studios/${s.id}'),
                    ),
                  ))
              .toList(),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (i) {
          if (i == 1) context.go('/owner/bookings');
          if (i == 2) context.go('/profile');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Studios'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
