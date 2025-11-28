class Blockout {
  final String id;
  final String studioId;
  final String eventName;
  final String? eventDescription;
  final DateTime dateTime;
  final bool allDay;
  final double? durationHours;
  final String? recurringType;
  final List<String> recurringDays;
  final DateTime? recurringUntil;
  final bool? recurringIndefinite;
  final bool isRecurring;

  Blockout({
    required this.id,
    required this.studioId,
    required this.eventName,
    required this.dateTime,
    this.eventDescription,
    this.allDay = false,
    this.durationHours,
    this.recurringType,
    this.recurringDays = const [],
    this.recurringUntil,
    this.recurringIndefinite,
    this.isRecurring = false,
  });

  factory Blockout.fromJson(Map<String, dynamic> json) {
    return Blockout(
      id: json['id'] ?? '',
      studioId: json['studio'] ?? '',
      eventName: json['eventName'] ?? '',
      eventDescription: json['eventDescription'],
      dateTime: DateTime.parse(json['dateTime']),
      allDay: json['allDay'] ?? false,
      durationHours: json['durationHours'] != null ? (json['durationHours'] as num).toDouble() : null,
      recurringType: json['recurringType'],
      recurringDays: List<String>.from(json['recurringDays'] ?? []),
      recurringUntil: json['recurringUntil'] != null ? DateTime.tryParse(json['recurringUntil']) : null,
      recurringIndefinite: json['recurringIndefinite'],
      isRecurring: json['isRecurring'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id.isEmpty ? null : id,
        'studio': studioId,
        'eventName': eventName,
        'eventDescription': eventDescription,
        'dateTime': dateTime.toIso8601String(),
        'allDay': allDay,
        'durationHours': durationHours,
        'recurringType': recurringType,
        'recurringDays': recurringDays,
        'recurringUntil': recurringUntil?.toIso8601String(),
        'recurringIndefinite': recurringIndefinite,
        'isRecurring': isRecurring,
      };
}
