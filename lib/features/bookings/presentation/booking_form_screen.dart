import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/data/auth_repository.dart';
import '../data/booking_repository.dart';
import '../../studios/data/studio_repository.dart';
import '../../../common/models/booking_model.dart';

class BookingFormScreen extends ConsumerStatefulWidget {
  final String studioId;
  final String? spaceId;
  const BookingFormScreen({super.key, required this.studioId, this.spaceId});

  @override
  ConsumerState<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends ConsumerState<BookingFormScreen> {
  DateTime? date;
  TimeOfDay? start;
  TimeOfDay? end;
  String? selectedSpaceId;
  final eventNameCtrl = TextEditingController();
  final eventDescCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedSpaceId = widget.spaceId;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserDocProvider).asData?.value;
    final studioAsync = ref.watch(_studioProvider(widget.studioId));
    final spaces = ref.watch(spacesByStudioProvider(widget.studioId));

    double? durationHours() {
      if (start == null || end == null) return null;
      final duration = (end!.hour + end!.minute / 60) - (start!.hour + start!.minute / 60);
      return duration > 0 ? duration : null;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Request Booking')),
      body: studioAsync.when(
        data: (studio) => Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(children: [
            TextField(controller: eventNameCtrl, decoration: const InputDecoration(labelText: 'Event name')),
            TextField(controller: eventDescCtrl, decoration: const InputDecoration(labelText: 'Event description (optional)')),
            ListTile(
              title: Text(date == null ? 'Select date' : date!.toIso8601String().split('T').first),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 90)),
                  initialDate: DateTime.now(),
                );
                if (picked != null) setState(() => date = picked);
              },
            ),
            ListTile(
              title: Text(start == null ? 'Start time' : start!.format(context)),
              onTap: () async {
                final picked = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 9, minute: 0));
                if (picked != null) setState(() => start = picked);
              },
            ),
            ListTile(
              title: Text(end == null ? 'End time' : end!.format(context)),
              onTap: () async {
                final picked = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 10, minute: 0));
                if (picked != null) setState(() => end = picked);
              },
            ),
            const SizedBox(height: 12),
            if (spaces.isNotEmpty)
              DropdownButtonFormField<String>(
                value: selectedSpaceId ?? (spaces.isNotEmpty ? spaces.first.id : null),
                items: spaces.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name))).toList(),
                onChanged: (val) => setState(() => selectedSpaceId = val),
                decoration: const InputDecoration(labelText: 'Space (optional, not sent to API)'),
              ),
            const SizedBox(height: 16),
            Text('Duration: ${durationHours()?.toStringAsFixed(1) ?? '-'} hrs'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: user == null
                  ? null
                  : () async {
                      final dur = durationHours();
                      if (date == null || start == null || end == null || dur == null || eventNameCtrl.text.trim().isEmpty) return;
                      final startDateTime = DateTime(
                        date!.year,
                        date!.month,
                        date!.day,
                        start!.hour,
                        start!.minute,
                      );
                      await ref.read(bookingRepositoryProvider).createBooking(
                            studioId: studio.id,
                            instructorId: user.id,
                            eventName: eventNameCtrl.text.trim(),
                            eventDescription: eventDescCtrl.text.trim().isEmpty ? null : eventDescCtrl.text.trim(),
                            dateTime: startDateTime,
                            durationHours: dur,
                            client: BookingClient(name: user.name, phone: user.phone),
                          );
                      if (!mounted) return;
                      Navigator.pop(context);
                    },
              child: const Text('Request Booking'),
            )
          ]),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

final _studioProvider = FutureProvider.family.autoDispose((ref, String id) {
  return ref.read(studioRepositoryProvider).fetchStudio(id);
});
