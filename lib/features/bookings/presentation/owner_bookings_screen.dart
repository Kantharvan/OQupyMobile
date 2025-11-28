import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/data/auth_repository.dart';
import '../../studios/data/studio_repository.dart';
import '../data/booking_repository.dart';
import '../../../common/models/booking_model.dart';

class OwnerBookingsScreen extends ConsumerWidget {
  const OwnerBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final owner = ref.watch(currentUserDocProvider).asData?.value;
    final studios = ref.watch(ownerStudiosProvider(owner?.id ?? ''));
    return Scaffold(
      appBar: AppBar(title: const Text('Bookings')),
      body: studios.when(
        data: (studios) {
          final bookings = ref.watch(ownerBookingsProvider(studios.map((s) => s.id).toList()));
          return bookings.when(
            data: (list) => ListView(
              children: list
                  .map(
                  (b) => Card(
                    child: ListTile(
                      title: Text(b.eventName ?? 'Booking'),
                      subtitle: Text('${b.dateTime.toLocal()} • Status: ${b.status.name}'),
                      trailing: PopupMenuButton<BookingStatus>(
                        onSelected: (status) => ref.read(bookingRepositoryProvider).updateStatus(b.id, status),
                        itemBuilder: (_) => BookingStatus.values.map((s) => PopupMenuItem(value: s, child: Text(s.name))).toList(),
                      ),
                    ),
                    ),
                  )
                  .toList(),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
