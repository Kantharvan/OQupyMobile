class Studio {
  final String id;
  final String name;
  final String location;
  final List<String> type; // e.g., ["Dance", "Yoga"]
  final List<String> amenities;
  final double price;
  final List<String> images;
  final String? description;
  final int? cancellationPolicyHours;
  final String ownerId;
  final bool published;
  final String? operationalStart;
  final String? operationalEnd;

  Studio({
    required this.id,
    required this.name,
    required this.location,
    required this.type,
    required this.amenities,
    required this.price,
    required this.images,
    required this.ownerId,
    this.description,
    this.cancellationPolicyHours,
    this.published = true,
    this.operationalStart,
    this.operationalEnd,
  });

  factory Studio.fromJson(Map<String, dynamic> json) {
    return Studio(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      type: List<String>.from(json['type'] ?? []),
      amenities: List<String>.from(json['amenities'] ?? []),
      price: (json['price'] ?? 0).toDouble(),
      images: List<String>.from(json['images'] ?? []),
      description: json['description'],
      cancellationPolicyHours: json['cancellationPolicy'] != null ? (json['cancellationPolicy'] as num).toInt() : null,
      ownerId: json['ownerId'] ?? '',
      published: json['published'] ?? true,
      operationalStart: (json['operationalHours'] ?? const {})['start'],
      operationalEnd: (json['operationalHours'] ?? const {})['end'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id.isEmpty ? null : id,
        'name': name,
        'location': location,
        'type': type,
        'amenities': amenities,
        'price': price,
        'images': images,
        'description': description,
        'cancellationPolicy': cancellationPolicyHours,
        'ownerId': ownerId,
        'published': published,
        'operationalHours': {
          'start': operationalStart,
          'end': operationalEnd,
        },
      };
}
