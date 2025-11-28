enum UserRole { studioOwner, instructor, student }

class AppUser {
  final String id;
  final UserRole role;
  final String name;
  final String? email;
  final String phone;
  final String? avatar;
  final String? businessName;
  final String? businessAddress;
  final List<String> ownedStudios;
  final List<String> associatedStudios;
  final List<String> specialties;
  final DateTime? createdAt;
  final DateTime? lastActive;
  final bool isActive;

  AppUser({
    required this.id,
    required this.role,
    required this.name,
    this.email,
    required this.phone,
    this.avatar,
    this.businessName,
    this.businessAddress,
    this.ownedStudios = const [],
    this.associatedStudios = const [],
    this.specialties = const [],
    this.createdAt,
    this.lastActive,
    this.isActive = true,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] ?? '',
      role: _roleFromString(json['role']),
      name: json['name'] ?? '',
      email: json['email'],
      phone: json['phone'] ?? '',
      avatar: json['avatar'],
      businessName: json['businessName'],
      businessAddress: json['businessAddress'],
      ownedStudios: List<String>.from(json['ownedStudios'] ?? []),
      associatedStudios: List<String>.from(json['associatedStudios'] ?? []),
      specialties: List<String>.from(json['specialties'] ?? []),
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      lastActive: json['lastActive'] != null ? DateTime.tryParse(json['lastActive']) : null,
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'role': _roleToString(role),
        'name': name,
        'email': email,
        'phone': phone,
        'avatar': avatar,
        'businessName': businessName,
        'businessAddress': businessAddress,
        'ownedStudios': ownedStudios,
        'associatedStudios': associatedStudios,
        'specialties': specialties,
        'createdAt': createdAt?.toIso8601String(),
        'lastActive': lastActive?.toIso8601String(),
        'isActive': isActive,
      };

  static UserRole _roleFromString(String? value) {
    switch (value) {
      case 'studio_owner':
        return UserRole.studioOwner;
      case 'student':
        return UserRole.student;
      case 'instructor':
      default:
        return UserRole.instructor;
    }
  }

  static String _roleToString(UserRole role) {
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
