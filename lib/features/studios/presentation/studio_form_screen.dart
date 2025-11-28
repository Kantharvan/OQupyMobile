import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/studio_repository.dart';
import '../../../common/models/studio_model.dart';
import '../../auth/data/auth_repository.dart';
import 'package:go_router/go_router.dart';

class StudioFormScreen extends ConsumerStatefulWidget {
  final String? studioId;
  const StudioFormScreen({super.key, this.studioId});

  @override
  ConsumerState<StudioFormScreen> createState() => _StudioFormScreenState();
}

class _StudioFormScreenState extends ConsumerState<StudioFormScreen> {
  final nameCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final typeCtrl = TextEditingController(text: 'Dance,Yoga');
  final priceCtrl = TextEditingController();
  final amenitiesCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final startCtrl = TextEditingController(text: '08:00');
  final endCtrl = TextEditingController(text: '22:00');
  bool published = true;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDocProvider).asData?.value;
    return Scaffold(
      appBar: AppBar(title: Text(widget.studioId == null ? 'Add Studio' : 'Edit Studio')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(children: [
          TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
          TextField(controller: locationCtrl, decoration: const InputDecoration(labelText: 'Location (address/city)')),
          TextField(controller: typeCtrl, decoration: const InputDecoration(labelText: 'Type (comma separated, e.g. Dance,Yoga)')),
          TextField(controller: priceCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Price (per hour or session)')),
          TextField(controller: amenitiesCtrl, decoration: const InputDecoration(labelText: 'Amenities (comma separated)')),
          TextField(controller: descriptionCtrl, decoration: const InputDecoration(labelText: 'Description')),
          TextField(controller: startCtrl, decoration: const InputDecoration(labelText: 'Opens at (HH:mm)')),
          TextField(controller: endCtrl, decoration: const InputDecoration(labelText: 'Closes at (HH:mm)')),
          SwitchListTile(
            value: published,
            onChanged: (v) => setState(() => published = v),
            title: const Text('Published'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: loading
                ? null
                : () async {
                    setState(() => loading = true);
                    final repo = ref.read(studioRepositoryProvider);
                    final studio = Studio(
                      id: widget.studioId ?? '',
                      ownerId: currentUser?.id ?? '',
                      name: nameCtrl.text.trim(),
                      location: locationCtrl.text.trim(),
                      type: typeCtrl.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
                      amenities: amenitiesCtrl.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
                      price: double.tryParse(priceCtrl.text) ?? 0,
                      images: const [],
                      description: descriptionCtrl.text.trim(),
                      cancellationPolicyHours: 24,
                      published: published,
                      operationalStart: startCtrl.text.trim(),
                      operationalEnd: endCtrl.text.trim(),
                    );
                    if (widget.studioId == null) {
                      await repo.createStudio(studio);
                    } else {
                      await repo.updateStudio(studio);
                    }
                    if (!mounted) return;
                    context.pop();
                  },
            child: loading ? const CircularProgressIndicator() : const Text('Save'),
          )
        ]),
      ),
    );
  }
}
