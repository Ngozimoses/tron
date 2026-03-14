import 'package:equatable/equatable.dart';

class Resident extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String blockNumber;
  final String unitNumber;
  final String? profileImage;
  final DateTime? moveInDate;
  final bool isOwner;

  const Resident({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.blockNumber,
    required this.unitNumber,
    this.profileImage,
    this.moveInDate,
    this.isOwner = false,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    blockNumber,
    unitNumber,
    profileImage,
    moveInDate,
    isOwner,
  ];

  Resident copyWith({
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
    return Resident(
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

  String get fullAddress => 'Block $blockNumber, Unit $unitNumber';
}