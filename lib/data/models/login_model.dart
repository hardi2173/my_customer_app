import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String username;
  final String status;
  final ProfileModel? profile;

  const UserModel({
    required this.id,
    required this.username,
    required this.status,
    this.profile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      username: json['username'] as String? ?? '',
      status: json['status'] as String? ?? '',
      profile: json['profile'] != null
          ? ProfileModel.fromJson(json['profile'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  List<Object?> get props => [id, username, status, profile];
}

class ProfileModel extends Equatable {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? pob;
  final String? dob;
  final String? nationality;
  final String? religion;

  const ProfileModel({
    required this.id,
    this.firstName,
    this.lastName,
    this.pob,
    this.dob,
    this.nationality,
    this.religion,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String? ?? '',
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      pob: json['pob'] as String?,
      dob: json['dob'] as String?,
      nationality: json['nationality'] as String?,
      religion: json['religion'] as String?,
    );
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

class LoginResponseModel extends Equatable {
  final String accessToken;
  final String refreshToken;
  final UserModel user;

  const LoginResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return LoginResponseModel(
      accessToken: data['accessToken'] as String? ?? '',
      refreshToken: data['refreshToken'] as String? ?? '',
      user: UserModel.fromJson(data['user'] as Map<String, dynamic>? ?? {}),
    );
  }

  @override
  List<Object?> get props => [accessToken, refreshToken, user];
}

class LoginRequestModel extends Equatable {
  final String username;
  final String password;

  const LoginRequestModel({required this.username, required this.password});

  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password};
  }

  @override
  List<Object?> get props => [username, password];
}
