import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../common/models/user_model.dart';
import '../data/auth_repository.dart';

class RoleSelectionScreen extends ConsumerStatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  ConsumerState<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends ConsumerState<RoleSelectionScreen> {
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  UserRole? selected;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserDocProvider).asData?.value;
    return Scaffold(
      appBar: AppBar(title: const Text('I am a...')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Full name')),
          const SizedBox(height: 12),
          TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Phone')),
          const SizedBox(height: 12),
          TextField(controller: cityCtrl, decoration: const InputDecoration(labelText: 'Business name or city (optional)')),
          const SizedBox(height: 20),
          Wrap(spacing: 12, children: [
            ChoiceChip(
              label: const Text('Studio Owner'),
              selected: selected == UserRole.studioOwner,
              onSelected: (_) => setState(() => selected = UserRole.studioOwner),
            ),
            ChoiceChip(
              label: const Text('Instructor'),
              selected: selected == UserRole.instructor,
              onSelected: (_) => setState(() => selected = UserRole.instructor),
            ),
          ]),
          const Spacer(),
          ElevatedButton(
            onPressed: selected == null
                ? null
                : () async {
                    await ref.read(authRepositoryProvider).saveUserProfile(
                          name: nameCtrl.text.trim(),
                          phone: phoneCtrl.text.trim(),
                          email: user?.email,
                          role: selected,
                          businessName: selected == UserRole.studioOwner ? cityCtrl.text.trim() : null,
                        );
                    if (!mounted) return;
                    context.go(selected == UserRole.studioOwner ? '/home-owner' : '/home-instructor');
                  },
            child: const Text('Continue'),
          )
        ]),
      ),
    );
  }
}
