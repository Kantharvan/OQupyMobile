import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/studio_repository.dart';
import 'package:go_router/go_router.dart';

class SpaceFormScreen extends ConsumerStatefulWidget {
  final String studioId;
  const SpaceFormScreen({super.key, required this.studioId});

  @override
  ConsumerState<SpaceFormScreen> createState() => _SpaceFormScreenState();
}

class _SpaceFormScreenState extends ConsumerState<SpaceFormScreen> {
  final nameCtrl = TextEditingController();
  final capacityCtrl = TextEditingController();
  final floorCtrl = TextEditingController();
  final rateCtrl = TextEditingController();
  bool isActive = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Space')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(children: [
          TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
          TextField(controller: capacityCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Capacity')),
          TextField(controller: floorCtrl, decoration: const InputDecoration(labelText: 'Floor type')),
          TextField(controller: rateCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Hourly rate (optional)')),
          SwitchListTile(
            value: isActive,
            onChanged: (v) => setState(() => isActive = v),
            title: const Text('Active'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(studioRepositoryProvider).addSpace(
                    studioId: widget.studioId,
                    name: nameCtrl.text.trim(),
                    capacity: int.tryParse(capacityCtrl.text) ?? 0,
                    floorType: floorCtrl.text.trim(),
                    hourlyRate: double.tryParse(rateCtrl.text),
                    isActive: isActive,
                  );
              if (!mounted) return;
              context.pop();
            },
            child: const Text('Save'),
          )
        ]),
      ),
    );
  }
}
