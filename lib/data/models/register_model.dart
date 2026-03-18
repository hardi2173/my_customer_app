import 'package:equatable/equatable.dart';

class RegisterRequestModel extends Equatable {
  final String username;
  final String password;
  final String? firstName;
  final String? lastName;
  final String? pob;
  final String? dob;
  final String? nationality;
  final String? religion;
  final List<AddressRequest>? addresses;
  final List<ContactRequest> contacts;

  const RegisterRequestModel({
    required this.username,
    required this.password,
    this.firstName,
    this.lastName,
    this.pob,
    this.dob,
    this.nationality,
    this.religion,
    this.addresses,
    required this.contacts,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      if (pob != null) 'pob': pob,
      if (dob != null) 'dob': dob,
      if (nationality != null) 'nationality': nationality,
      if (religion != null) 'religion': religion,
      if (addresses != null)
        'addresses': addresses!.map((a) => a.toJson()).toList(),
      'contacts': contacts.map((c) => c.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
    username,
    password,
    firstName,
    lastName,
    pob,
    dob,
    nationality,
    religion,
    addresses,
    contacts,
  ];
}

class AddressRequest extends Equatable {
  final String? addressType;
  final String? addressProvince;
  final String? addressCity;
  final String? addressDistrict;
  final String? addressSubDistrict;
  final String? addressLine1;
  final String? addressLine2;

  const AddressRequest({
    this.addressType,
    this.addressProvince,
    this.addressCity,
    this.addressDistrict,
    this.addressSubDistrict,
    this.addressLine1,
    this.addressLine2,
  });

  Map<String, dynamic> toJson() {
    return {
      if (addressType != null) 'addressType': addressType,
      if (addressProvince != null) 'addressProvince': addressProvince,
      if (addressCity != null) 'addressCity': addressCity,
      if (addressDistrict != null) 'addressDistrict': addressDistrict,
      if (addressSubDistrict != null) 'addressSubDistrict': addressSubDistrict,
      if (addressLine1 != null) 'addressLine1': addressLine1,
      if (addressLine2 != null) 'addressLine2': addressLine2,
    };
  }

  @override
  List<Object?> get props => [
    addressType,
    addressProvince,
    addressCity,
    addressDistrict,
    addressSubDistrict,
    addressLine1,
    addressLine2,
  ];
}

class ContactRequest extends Equatable {
  final String contactType;
  final String contactNumber;

  const ContactRequest({
    required this.contactType,
    required this.contactNumber,
  });

  Map<String, dynamic> toJson() {
    return {'contactType': contactType, 'contactNumber': contactNumber};
  }

  @override
  List<Object?> get props => [contactType, contactNumber];
}

class RegisterResponseModel extends Equatable {
  final String id;
  final String username;
  final String status;
  final RegisterProfileModel? profile;

  const RegisterResponseModel({
    required this.id,
    required this.username,
    required this.status,
    this.profile,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return RegisterResponseModel(
      id: data['id'] as String? ?? '',
      username: data['username'] as String? ?? '',
      status: data['status'] as String? ?? '',
      profile: data['profile'] != null
          ? RegisterProfileModel.fromJson(
              data['profile'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  @override
  List<Object?> get props => [id, username, status, profile];
}

class RegisterProfileModel extends Equatable {
  final String id;
  final String? firstName;
  final String? lastName;

  const RegisterProfileModel({required this.id, this.firstName, this.lastName});

  factory RegisterProfileModel.fromJson(Map<String, dynamic> json) {
    return RegisterProfileModel(
      id: json['id'] as String? ?? '',
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, firstName, lastName];
}
