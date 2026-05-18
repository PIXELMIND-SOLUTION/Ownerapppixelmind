// lib/models/client_model.dart

class ClientModel {
  final String id;
  final String clientNumber;
  final String name;
  final String email;
  final String phone;

  ClientModel({
    required this.id,
    required this.clientNumber,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id:           json['_id']          as String,
      clientNumber: json['clientNumber'] as String,
      name:         json['name']         as String,
      email:        json['email']        as String,
      phone:        json['phone']        as String,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id':          id,
        'clientNumber': clientNumber,
        'name':         name,
        'email':        email,
        'phone':        phone,
      };

  ClientModel copyWith({
    String? id,
    String? clientNumber,
    String? name,
    String? email,
    String? phone,
  }) {
    return ClientModel(
      id:           id           ?? this.id,
      clientNumber: clientNumber ?? this.clientNumber,
      name:         name         ?? this.name,
      email:        email        ?? this.email,
      phone:        phone        ?? this.phone,
    );
  }
}