import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/auth/presentation/role_selection_screen.dart';
import 'features/auth/presentation/otp_screen.dart';
import 'features/studios/presentation/studio_list_screen.dart';
import 'features/studios/presentation/studio_detail_screen.dart';
import 'features/studios/presentation/studio_form_screen.dart';
import 'features/studios/presentation/owner_studios_screen.dart';
import 'features/studios/presentation/space_form_screen.dart';
import 'features/bookings/presentation/booking_form_screen.dart';
import 'features/bookings/presentation/my_bookings_screen.dart';
import 'features/bookings/presentation/owner_bookings_screen.dart';
import 'features/profile/presentation/profile_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  final tokenStream = ref.read(authRepositoryProvider).tokenStream;
  // Router listens to auth changes for redirects.
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: GoRouterRefreshStream(tokenStream),
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/otp', builder: (_, state) => OtpScreen(phone: state.uri.queryParameters['phone'] ?? '')),
      GoRoute(path: '/role-select', builder: (_, __) => const RoleSelectionScreen()),
      GoRoute(path: '/home-instructor', builder: (_, __) => const StudioListScreen()),
      GoRoute(path: '/home-owner', builder: (_, __) => const OwnerStudiosScreen()),
      GoRoute(path: '/studios/:id', builder: (_, state) => StudioDetailScreen(studioId: state.pathParameters['id']!)),
      GoRoute(
        path: '/studios/:id/book',
        builder: (_, state) => BookingFormScreen(studioId: state.pathParameters['id']!, spaceId: state.extra as String?),
      ),
      GoRoute(path: '/owner/studios/new', builder: (_, __) => const StudioFormScreen()),
      GoRoute(path: '/owner/studios/:id/edit', builder: (_, state) => StudioFormScreen(studioId: state.pathParameters['id']!)),
      GoRoute(path: '/owner/studios/:id/space/new', builder: (_, state) => SpaceFormScreen(studioId: state.pathParameters['id']!)),
      GoRoute(path: '/bookings', builder: (_, __) => const MyBookingsScreen()),
      GoRoute(path: '/owner/bookings', builder: (_, __) => const OwnerBookingsScreen()),
      GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
    ],
    redirect: (context, state) {
      final loggedIn = authState.asData?.value != null;
      final atLogin = state.uri.path == '/login';
      if (!loggedIn && !atLogin) return '/login';
      return null;
    },
  );
});

/// Simple ChangeNotifier that notifies GoRouter when the auth stream emits.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
