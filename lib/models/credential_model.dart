// lib/models/credential_model.dart

class CredentialModel {
  final String name;
  final Map<String, String> data;

  CredentialModel({
    required this.name,
    required this.data,
  });

  factory CredentialModel.fromJson(Map<String, dynamic> json) {
    return CredentialModel(
      name: json['name'] as String,
      data: Map<String, String>.from(
        (json['data'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'data': data,
      };
}

class CredentialsResponse {
  final bool success;
  final int count;
  final List<CredentialModel> credentials;

  CredentialsResponse({
    required this.success,
    required this.count,
    required this.credentials,
  });

  factory CredentialsResponse.fromJson(Map<String, dynamic> json) {
    return CredentialsResponse(
      success: json['success'] as bool,
      count: json['count'] as int,
      credentials: (json['credentials'] as List<dynamic>)
          .map((e) => CredentialModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}