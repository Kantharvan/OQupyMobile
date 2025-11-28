import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/auth_repository.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String phone;
  const OtpScreen({super.key, required this.phone});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final codeCtrl = TextEditingController();
  bool loading = false;
  String? error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A0A0A), Color(0xFF141414)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              decoration: BoxDecoration(
                color: const Color(0xFF0F0F0F).withOpacity(0.92),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.45),
                    blurRadius: 24,
                    offset: const Offset(0, 14),
                  ),
                ],
                border: Border.all(color: Colors.white.withOpacity(0.04)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'OQUPY',
                    style: TextStyle(
                      color: Color(0xFFFF7A21),
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Enter the code sent to your phone', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(widget.phone, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 24),
                  Text('Verify OTP', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 12),
                  TextField(
                    controller: codeCtrl,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textAlign: TextAlign.center,
                    style: const TextStyle(letterSpacing: 8, fontSize: 18),
                    decoration: const InputDecoration(
                      counterText: '',
                      filled: true,
                      hintText: 'Enter the 6-digit code',
                    ),
                  ),
                  if (error != null) ...[
                    const SizedBox(height: 8),
                    Text(error!, style: const TextStyle(color: Colors.red)),
                  ],
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: loading
                          ? null
                          : () async {
                              setState(() {
                                loading = true;
                                error = null;
                              });
                              try {
                                await ref.read(authRepositoryProvider).verifyOtp(widget.phone, codeCtrl.text.trim());
                                if (!mounted) return;
                                context.go('/role-select');
                              } catch (e) {
                                setState(() => error = e.toString());
                              } finally {
                                if (mounted) setState(() => loading = false);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF7A21),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: loading
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('Verify OTP'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      // TODO: wire to resend endpoint.
                      setState(() => error = 'Resend not wired yet.');
                    },
                    child: const Text('Resend OTP'),
                  ),
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('Back to Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
