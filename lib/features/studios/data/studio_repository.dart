import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/models/studio_model.dart';
import '../../../common/models/space_model.dart';
import '../../../common/network/api_client.dart';
import '../../auth/data/auth_repository.dart';

final studioRepositoryProvider = Provider<StudioRepository>((ref) => StudioRepository(ref));

final studiosProvider = FutureProvider.family<List<Studio>, Map<String, dynamic>>((ref, filters) {
  return ref.read(studioRepositoryProvider).fetchStudios(
        amenities: (filters['amenities'] as List<String>? ?? const <String>[]),
      );
});

final ownerStudiosProvider = FutureProvider.family<List<Studio>, String>((ref, ownerId) {
  return ref.read(studioRepositoryProvider).fetchOwnerStudios(ownerId);
});

// Spaces are not represented in the backend Swagger; kept locally for UI compatibility.
final spacesByStudioProvider = Provider.family<List<Space>, String>((ref, studioId) => const []);

class StudioRepository {
  StudioRepository(this._ref);
  final Ref _ref;
  Map<String, String> _headers() {
    final token = _ref.read(authRepositoryProvider).token;
    return {if (token != null) 'Authorization': 'Bearer $token'};
  }

  Future<List<Studio>> fetchStudios({List<String> amenities = const []}) async {
    final dio = _ref.read(dioProvider);
    final res = await dio.get('/api/studios',
        queryParameters: {
      // Add filters if backend supports (not specified in swagger)
      if (amenities.isNotEmpty) 'amenities': amenities,
    }, options: Options(headers: _headers()));
    final list = (res.data as List).map((e) => Studio.fromJson(e as Map<String, dynamic>)).toList();
    return list;
  }

  Future<List<Studio>> fetchOwnerStudios(String ownerId) async {
    if (ownerId.isEmpty) return [];
    final dio = _ref.read(dioProvider);
    final res = await dio.get('/api/studios/owner/$ownerId', options: Options(headers: _headers()));
    return (res.data as List).map((e) => Studio.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Studio> fetchStudio(String id) async {
    final dio = _ref.read(dioProvider);
    final res = await dio.get('/api/studios/$id', options: Options(headers: _headers()));
    return Studio.fromJson(res.data as Map<String, dynamic>);
  }

  Future<String> createStudio(Studio studio) async {
    final dio = _ref.read(dioProvider);
    final res = await dio.post('/api/studios', data: studio.toJson(), options: Options(headers: _headers()));
    return res.data['studioId'] ?? '';
  }

  Future<void> updateStudio(Studio studio) async {
    final dio = _ref.read(dioProvider);
    await dio.put('/api/studios/${studio.id}', data: studio.toJson(), options: Options(headers: _headers()));
  }

  Future<void> deleteStudio(String id) async {
    final dio = _ref.read(dioProvider);
    await dio.delete('/api/studios/$id', options: Options(headers: _headers()));
  }

  Future<void> addInstructor(String studioId, String instructorId) async {
    final dio = _ref.read(dioProvider);
    await dio.post('/api/studios/$studioId/instructors', data: {'instructorId': instructorId}, options: Options(headers: _headers()));
  }

  Future<void> removeInstructor(String studioId, String instructorId) async {
    final dio = _ref.read(dioProvider);
    await dio.delete('/api/studios/$studioId/instructors', data: {'instructorId': instructorId}, options: Options(headers: _headers()));
  }

  // Spaces are not covered by the REST API; this is a no-op placeholder to keep the UI flow compiling.
  Future<void> addSpace({
    required String studioId,
    required String name,
    required int capacity,
    required String floorType,
    double? hourlyRate,
    bool isActive = true,
  }) async {
    // TODO: wire to backend when a spaces endpoint is available.
  }
}
