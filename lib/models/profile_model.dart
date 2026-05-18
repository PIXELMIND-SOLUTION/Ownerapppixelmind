// lib/models/client_model.dart

class ProfileModel {
  final String id;
  final String clientNumber;
  final String name;
  final String email;
  final String phone;
  final String? appName;
  final String? contactAdmin;
  final String? credentials;
  final String? memberSince;
  final String? projects;
  final String? version;
  final String? profileImage;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProfileModel({
    required this.id,
    required this.clientNumber,
    required this.name,
    required this.email,
    required this.phone,
    this.appName,
    this.contactAdmin,
    this.credentials,
    this.memberSince,
    this.projects,
    this.version,
    this.profileImage,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['_id'] as String,
      clientNumber: json['clientNumber'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      appName: json['appName'] as String?,
      contactAdmin: json['contactAdmin'] as String?,
      credentials: json['credentials'] as String?,
      memberSince: json['memberSince'] as String?,
      projects: json['projects'] as String?,
      version: json['version'] as String?,
      profileImage: json['profileImage'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'clientNumber': clientNumber,
        'name': name,
        'email': email,
        'phone': phone,
        'appName': appName,
        'contactAdmin': contactAdmin,
        'credentials': credentials,
        'memberSince': memberSince,
        'projects': projects,
        'version': version,
        'profileImage': profileImage,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  ProfileModel copyWith({
    String? id,
    String? clientNumber,
    String? name,
    String? email,
    String? phone,
    String? appName,
    String? contactAdmin,
    String? credentials,
    String? memberSince,
    String? projects,
    String? version,
    String? profileImage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      clientNumber: clientNumber ?? this.clientNumber,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      appName: appName ?? this.appName,
      contactAdmin: contactAdmin ?? this.contactAdmin,
      credentials: credentials ?? this.credentials,
      memberSince: memberSince ?? this.memberSince,
      projects: projects ?? this.projects,
      version: version ?? this.version,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
