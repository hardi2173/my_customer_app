import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String status;
  final UserProfile? profile;

  const User({
    required this.id,
    required this.username,
    required this.status,
    this.profile,
  });

  @override
  List<Object?> get props => [id, username, status, profile];
}

class UserProfile extends Equatable {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? pob;
  final String? dob;
  final String? nationality;
  final String? religion;

  const UserProfile({
    required this.id,
    this.firstName,
    this.lastName,
    this.pob,
    this.dob,
    this.nationality,
    this.religion,
  });

  String get fullName {
    final parts = <String>[];
    if (firstName != null && firstName!.isNotEmpty) parts.add(firstName!);
    if (lastName != null && lastName!.isNotEmpty) parts.add(lastName!);
    return parts.isEmpty ? '' : parts.join(' ');
  }

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    pob,
    dob,
    nationality,
    religion,
  ];
}
