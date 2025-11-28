import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/studio_repository.dart';
import '../../../common/models/studio_model.dart';
import '../../../common/models/space_model.dart';
import '../../auth/data/auth_repository.dart';
import '../../../common/models/user_model.dart';

class StudioDetailScreen extends ConsumerWidget {
  final String studioId;
  const StudioDetailScreen({super.key, required this.studioId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studioFuture = ref.watch(_studioFutureProvider(studioId));
    final spaces = ref.watch(spacesByStudioProvider(studioId));
    final currentUser = ref.watch(currentUserDocProvider).asData?.value;

    return Scaffold(
      appBar: AppBar(title: const Text('Studio Details')),
      body: studioFuture.when(
        data: (studio) => ListView(
          children: [
            _Header(studio: studio),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(studio.location),
                const SizedBox(height: 8),
                Wrap(spacing: 8, children: studio.amenities.map((a) => Chip(label: Text(a))).toList()),
                const SizedBox(height: 16),
                const Text('Spaces', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Column(
                  children: spaces
                      .map((s) => SpaceCard(
                            space: s,
                            baseRate: studio.price,
                            isOwner: currentUser?.role == UserRole.studioOwner,
                          ))
                      .toList(),
                ),
                if (currentUser?.role == UserRole.studioOwner && currentUser?.id == studio.ownerId)
                  TextButton(
                    onPressed: () => context.go('/owner/studios/${studio.id}/space/new'),
                    child: const Text('Add Space'),
                  ),
              ]),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

final _studioFutureProvider = FutureProvider.family<Studio, String>((ref, id) {
  return ref.read(studioRepositoryProvider).fetchStudio(id);
});

class _Header extends StatelessWidget {
  final Studio studio;
  const _Header({required this.studio});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PageView(
        children: (studio.images.isNotEmpty ? studio.images : ['https://placehold.co/600x400/000000/FFF?text=OQUPY'])
            .map((url) => Image.network(url, fit: BoxFit.cover))
            .toList(),
      ),
    );
  }
}

class SpaceCard extends ConsumerWidget {
  final Space space;
  final double baseRate;
  final bool isOwner;
  const SpaceCard({super.key, required this.space, required this.baseRate, required this.isOwner});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rate = space.hourlyRateOverride ?? baseRate;
    return Card(
      child: ListTile(
        title: Text(space.name),
        subtitle: Text('Capacity: ${space.capacity} • \$${rate.toStringAsFixed(0)}/hr'),
        trailing: isOwner
            ? null
            : ElevatedButton(
                onPressed: () => context.go('/studios/${space.studioId}/book', extra: space.id),
                child: const Text('Book'),
              ),
      ),
    );
  }
}
