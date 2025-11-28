import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/models/studio_model.dart';
import '../data/studio_repository.dart';
import 'package:go_router/go_router.dart';

class StudioListScreen extends ConsumerWidget {
  const StudioListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = {'amenities': <String>[]};
    final studiosAsync = ref.watch(studiosProvider(filters));
    return Scaffold(
      appBar: AppBar(title: const Text('Find Studios')),
      body: studiosAsync.when(
        data: (studios) => ListView.builder(
          itemCount: studios.length,
          itemBuilder: (_, i) => StudioCard(studio: studios[i]),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (i) {
          if (i == 1) context.go('/bookings');
          if (i == 2) context.go('/profile');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Browse'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class StudioCard extends ConsumerWidget {
  final Studio studio;
  const StudioCard({super.key, required this.studio});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        title: Text(studio.name),
        subtitle: Text('${studio.location} • \$${studio.price}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.go('/studios/${studio.id}'),
      ),
    );
  }
}
