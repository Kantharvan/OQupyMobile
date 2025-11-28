import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/data/auth_repository.dart';
import '../data/booking_repository.dart';

class MyBookingsScreen extends ConsumerWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserDocProvider).asData?.value;
    final bookings = ref.watch(instructorBookingsProvider(user?.id ?? ''));
    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: bookings.when(
        data: (list) => ListView(
          children: list
              .map((b) => ListTile(
                    title: Text('${b.eventName ?? 'Booking'}'),
                    subtitle: Text('${b.dateTime.toLocal()} • Status: ${b.status.name}'),
                  ))
              .toList(),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
