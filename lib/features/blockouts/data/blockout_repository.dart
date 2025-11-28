import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/models/blockout_model.dart';
import '../../../common/network/api_client.dart';
import '../../auth/data/auth_repository.dart';

final blockoutRepositoryProvider = Provider<BlockoutRepository>((ref) => BlockoutRepository(ref));

final blockoutsByStudioProvider = FutureProvider.family<List<Blockout>, String>((ref, studioId) {
  return ref.read(blockoutRepositoryProvider).fetchByStudio(studioId);
});

class BlockoutRepository {
  BlockoutRepository(this._ref);
  final Ref _ref;

  Dio get _dio => _ref.read(dioProvider);
  Options _options() {
    final token = _ref.read(authRepositoryProvider).token;
    return Options(headers: {if (token != null) 'Authorization': 'Bearer $token'});
  }

  Future<List<Blockout>> fetchAll() async {
    final res = await _dio.get('/api/blockouts', options: _options());
    return (res.data as List).map((e) => Blockout.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Blockout>> fetchByStudio(String studioId) async {
    if (studioId.isEmpty) return [];
    final res = await _dio.get('/api/blockouts/studio/$studioId', options: _options());
    return (res.data as List).map((e) => Blockout.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Blockout> fetchOne(String id) async {
    final res = await _dio.get('/api/blockouts/$id', options: _options());
    return Blockout.fromJson(res.data as Map<String, dynamic>);
  }

  Future<String> create(Blockout blockout) async {
    final res = await _dio.post('/api/blockouts', data: blockout.toJson(), options: _options());
    return res.data['id'] ?? '';
  }

  Future<void> update(Blockout blockout) async {
    await _dio.put('/api/blockouts/${blockout.id}', data: blockout.toJson(), options: _options());
  }

  Future<void> delete(String id) async {
    await _dio.delete('/api/blockouts/$id', options: _options());
  }
}
