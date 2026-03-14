import '../../domain/entities/resident.dart';

class ResidentModel extends Resident {
  ResidentModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    required super.blockNumber,
    required super.unitNumber,
    super.profileImage,
    super.moveInDate,
    super.isOwner,
  });

  factory ResidentModel.fromJson(Map<String, dynamic> json) {
    return ResidentModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      blockNumber: json['block_number'] ?? '',
      unitNumber: json['unit_number'] ?? '',
      profileImage: json['profile_image'],
      moveInDate: json['move_in_date'] != null
          ? DateTime.parse(json['move_in_date'])
          : null,
      isOwner: json['is_owner'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'block_number': blockNumber,
      'unit_number': unitNumber,
      'profile_image': profileImage,
      'move_in_date': moveInDate?.toIso8601String(),
      'is_owner': isOwner,
    };
  }

  ResidentModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? blockNumber,
    String? unitNumber,
    String? profileImage,
    DateTime? moveInDate,
    bool? isOwner,
  }) {
    return ResidentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      blockNumber: blockNumber ?? this.blockNumber,
      unitNumber: unitNumber ?? this.unitNumber,
      profileImage: profileImage ?? this.profileImage,
      moveInDate: moveInDate ?? this.moveInDate,
      isOwner: isOwner ?? this.isOwner,
    );
  }
}