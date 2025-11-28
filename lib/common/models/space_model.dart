class Space {
  final String id;
  final String studioId;
  final String name;
  final int capacity;
  final String floorType;
  final double? hourlyRateOverride;
  final bool isActive;

  Space({
    required this.id,
    required this.studioId,
    required this.name,
    required this.capacity,
    required this.floorType,
    this.hourlyRateOverride,
    required this.isActive,
  });

  factory Space.fromJson(Map<String, dynamic> json) => Space(
        id: json['id'] ?? '',
        studioId: json['studioId'] ?? '',
        name: json['name'] ?? '',
        capacity: (json['capacity'] ?? 0) as int,
        floorType: json['floorType'] ?? '',
        hourlyRateOverride: json['hourlyRate'] != null ? (json['hourlyRate'] as num).toDouble() : null,
        isActive: json['isActive'] ?? true,
      );

  Map<String, dynamic> toJson() => {
        'id': id.isEmpty ? null : id,
        'studioId': studioId,
        'name': name,
        'capacity': capacity,
        'floorType': floorType,
        'hourlyRate': hourlyRateOverride,
        'isActive': isActive,
      };
}
