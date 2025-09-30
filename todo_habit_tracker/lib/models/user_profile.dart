class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? profileImagePath;
  final DateTime createdAt;
  final DateTime lastActiveAt;
  final Map<String, dynamic> preferences;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.profileImagePath,
    required this.createdAt,
    required this.lastActiveAt,
    this.preferences = const {},
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImagePath,
    DateTime? createdAt,
    DateTime? lastActiveAt,
    Map<String, dynamic>? preferences,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      preferences: preferences ?? this.preferences,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImagePath': profileImagePath,
      'createdAt': createdAt.toIso8601String(),
      'lastActiveAt': lastActiveAt.toIso8601String(),
      'preferences': preferences,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      profileImagePath: json['profileImagePath'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastActiveAt: DateTime.parse(json['lastActiveAt'] as String),
      preferences: Map<String, dynamic>.from(
          json['preferences'] as Map<String, dynamic>? ?? {}),
    );
  }

  static UserProfile defaultProfile() {
    return UserProfile(
      id: 'default_user',
      name: 'User',
      email: 'user@example.com',
      createdAt: DateTime.now(),
      lastActiveAt: DateTime.now(),
      preferences: {
        'theme': 'light',
        'notifications': true,
        'dailyReminder': true,
      },
    );
  }
}
