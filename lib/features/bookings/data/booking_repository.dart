import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/models/booking_model.dart';
import '../../../common/network/api_client.dart';
import '../../auth/data/auth_repository.dart';

final bookingRepositoryProvider = Provider<BookingRepository>((ref) => BookingRepository(ref));

final instructorBookingsProvider = FutureProvider.family<List<Booking>, String>((ref, instructorId) {
  return ref.read(bookingRepositoryProvider).fetchBookingsByUser(instructorId);
});

final ownerBookingsProvider = FutureProvider.family<List<Booking>, List<String>>((ref, studioIds) {
  return ref.read(bookingRepositoryProvider).fetchBookingsByStudios(studioIds);
});

class BookingRepository {
  BookingRepository(this._ref);
  final Ref _ref;

  Dio get _dio => _ref.read(dioProvider);
  Options _options() {
    final token = _ref.read(authRepositoryProvider).token;
    return Options(headers: {if (token != null) 'Authorization': 'Bearer $token'});
  }

  Future<String> createBooking({
    required String studioId,
    required String instructorId,
    required String eventName,
    String? eventDescription,
    required DateTime dateTime,
    required double durationHours,
    required BookingClient client,
    PaymentDetails? paymentDetails,
  }) async {
    final res = await _dio.post('/api/bookings', data: {
      'studioId': studioId,
      'instructorId': instructorId,
      'eventName': eventName,
      'eventDescription': eventDescription,
      'dateTime': dateTime.toIso8601String(),
      'durationHours': durationHours,
      'client': client.toJson(),
      'paymentDetails': paymentDetails?.toJson(),
    }, options: _options());
    return res.data['bookingId'] ?? '';
  }

  Future<List<Booking>> fetchAllBookings() async {
    final res = await _dio.get('/api/bookings', options: _options());
    return (res.data as List).map((e) => Booking.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Booking>> fetchBookingsByStudio(String studioId) async {
    if (studioId.isEmpty) return [];
    final res = await _dio.get('/api/bookings/studio/$studioId', options: _options());
    return (res.data as List).map((e) => Booking.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Booking>> fetchBookingsByStudios(List<String> studioIds) async {
    if (studioIds.isEmpty) return [];
    final results = <Booking>[];
    for (final id in studioIds) {
      results.addAll(await fetchBookingsByStudio(id));
    }
    return results;
  }

  Future<List<Booking>> fetchBookingsByUser(String userId) async {
    if (userId.isEmpty) return [];
    final res = await _dio.get('/api/bookings/user/$userId', options: _options());
    return (res.data as List).map((e) => Booking.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Booking> fetchBooking(String id) async {
    final res = await _dio.get('/api/bookings/$id', options: _options());
    return Booking.fromJson(res.data as Map<String, dynamic>);
  }

  Future<void> updateStatus(String bookingId, BookingStatus status) async {
    await _dio.put('/api/bookings/$bookingId', data: {'status': Booking.statusToApi(status)}, options: _options());
  }

  Future<void> deleteBooking(String bookingId) async {
    await _dio.delete('/api/bookings/$bookingId', options: _options());
  }
}
