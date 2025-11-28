import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import '../../../common/models/user_model.dart';
import '../../../common/network/api_client.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository(ref));

/// Emits auth token changes to refresh router/redraw screens.
final authStateChangesProvider = StreamProvider<String?>((ref) {
  return ref.read(authRepositoryProvider).tokenStream;
});

/// Fetches the current user profile from /api/auth/me using the stored token.
final currentUserDocProvider = FutureProvider<AppUser?>((ref) async {
  final token = ref.watch(authStateChangesProvider).asData?.value;
  if (token == null) return null;
  return ref.read(authRepositoryProvider).fetchCurrentUser();
});

class AuthRepository {
  AuthRepository(this._ref);
  final Ref _ref;
  String? _token;
  final _tokenController = StreamController<String?>.broadcast()..add(null);

  String? get token => _token;
  Stream<String?> get tokenStream => _tokenController.stream;

  Dio get _dio => _ref.read(dioProvider);
  Options _authOptions() => Options(headers: {if (_token != null) 'Authorization': 'Bearer $_token'});

  Future<void> login(String email, String password) async {
    final res = await _dio.post('/api/auth/login', data: {'email': email, 'password': password});
    // Adjust key name if backend responds differently.
    _token = res.data['token'] as String?;
    _tokenController.add(_token);
  }

  /// Placeholder phone OTP request; hook to your backend endpoint.
  Future<void> requestOtp(String phone) async {
    // TODO: replace with real API call, e.g., _dio.post('/api/auth/send-otp', data: {'phone': phone});
    _token = null;
    _tokenController.add(_token);
  }

  /// Placeholder phone OTP verification; expects backend to return token.
  Future<void> verifyOtp(String phone, String code) async {
    // TODO: replace with real API call. Here we simulate success with a dummy token.
    // final res = await _dio.post('/api/auth/verify-otp', data: {'phone': phone, 'code': code});
    // _token = res.data['token'] as String?;
    _token = 'mock-token-$phone';
    _tokenController.add(_token);
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required UserRole role,
  }) async {
    final res = await _dio.post('/api/auth/register', data: {
      'email': email,
      'password': password,
      'name': name,
      'phone': phone,
      'role': _roleToApi(role),
    });
    _token = res.data['token'] as String?;
    _tokenController.add(_token);
    // If backend does not return token, auto-login with provided credentials.
    if (_token == null) {
      await login(email, password);
    }
  }

  Future<AppUser?> fetchCurrentUser() async {
    if (_token == null) return null;
    final res = await _dio.get('/api/auth/me', options: _authOptions());
    return AppUser.fromJson(res.data as Map<String, dynamic>);
  }

  Future<void> logout() async {
    try {
      await _dio.post('/api/auth/logout', options: _authOptions());
    } catch (_) {
      // Ignore logout failures; just clear locally.
    }
    _token = null;
    _tokenController.add(_token);
  }

  Future<void> resetPassword(String email) async {
    await _dio.post('/api/auth/reset-password', data: {'email': email});
  }

  Future<void> saveUserProfile({
    required String name,
    required String phone,
    String? email,
    UserRole? role,
    String? businessName,
    String? businessAddress,
  }) async {
    // Update via /api/users or /api/auth/me equivalent; here we assume /api/auth/me supports PUT.
    await _dio.put(
      '/api/auth/me',
      data: {
        'name': name,
        'phone': phone,
        'email': email,
        'role': role != null ? _roleToApi(role) : null,
        'businessName': businessName,
        'businessAddress': businessAddress,
      },
      options: _authOptions(),
    );
  }

  String _roleToApi(UserRole role) {
    switch (role) {
      case UserRole.studioOwner:
        return 'studio_owner';
      case UserRole.instructor:
        return 'instructor';
      case UserRole.student:
        return 'student';
    }
  }
}
