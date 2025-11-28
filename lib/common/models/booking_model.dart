enum BookingStatus { pending, confirmed, cancelled, completed }

class BookingClient {
  final String name;
  final String? phone;
  BookingClient({required this.name, this.phone});

  factory BookingClient.fromJson(Map<String, dynamic> json) {
    return BookingClient(
      name: json['name'] ?? '',
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
      };
}

class PaymentDetails {
  final String? method;
  final String? status;
  final double? amount;
  final String? transactionId;

  PaymentDetails({this.method, this.status, this.amount, this.transactionId});

  factory PaymentDetails.fromJson(Map<String, dynamic>? json) {
    if (json == null) return PaymentDetails();
    return PaymentDetails(
      method: json['method'],
      status: json['status'],
      amount: json['amount'] != null ? (json['amount'] as num).toDouble() : null,
      transactionId: json['transactionId'],
    );
  }

  Map<String, dynamic> toJson() => {
        'method': method,
        'status': status,
        'amount': amount,
        'transactionId': transactionId,
      };
}

class Booking {
  final String id;
  final String studioId;
  final String? studioName;
  final String instructorId;
  final String? eventName;
  final String? eventDescription;
  final DateTime dateTime;
  final BookingStatus status;
  final double? durationHours;
  final BookingClient? client;
  final PaymentDetails? paymentDetails;

  Booking({
    required this.id,
    required this.studioId,
    required this.instructorId,
    required this.dateTime,
    this.studioName,
    this.eventName,
    this.eventDescription,
    this.status = BookingStatus.pending,
    this.durationHours,
    this.client,
    this.paymentDetails,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] ?? '',
      studioId: json['studioId'] ?? '',
      studioName: json['studioName'],
      instructorId: json['instructorId'] ?? '',
      eventName: json['eventName'],
      eventDescription: json['eventDescription'],
      dateTime: DateTime.parse(json['dateTime']),
      status: _statusFromString(json['status']),
      durationHours: json['durationHours'] != null ? (json['durationHours'] as num).toDouble() : null,
      client: json['client'] != null ? BookingClient.fromJson(json['client']) : null,
      paymentDetails: PaymentDetails.fromJson(json['paymentDetails']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id.isEmpty ? null : id,
        'studioId': studioId,
        'studioName': studioName,
        'instructorId': instructorId,
        'eventName': eventName,
        'eventDescription': eventDescription,
        'dateTime': dateTime.toIso8601String(),
        'status': _statusToString(status),
        'durationHours': durationHours,
        'client': client?.toJson(),
        'paymentDetails': paymentDetails?.toJson(),
      };

  static BookingStatus _statusFromString(String? status) {
    switch (status) {
      case 'Confirmed':
        return BookingStatus.confirmed;
      case 'Cancelled':
        return BookingStatus.cancelled;
      case 'Completed':
        return BookingStatus.completed;
      case 'Pending':
      default:
        return BookingStatus.pending;
    }
  }

  static String _statusToString(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.pending:
        return 'Pending';
    }
  }

  static String statusToApi(BookingStatus status) => _statusToString(status);
}
