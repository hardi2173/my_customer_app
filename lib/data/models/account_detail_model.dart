import 'package:equatable/equatable.dart';

class AddressModel extends Equatable {
  final String id;
  final String addressType;
  final String? addressProvince;
  final String? addressCity;
  final String? addressDistrict;
  final String? addressSubDistrict;
  final String? addressLine1;
  final String? addressLine2;

  const AddressModel({
    required this.id,
    required this.addressType,
    this.addressProvince,
    this.addressCity,
    this.addressDistrict,
    this.addressSubDistrict,
    this.addressLine1,
    this.addressLine2,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as String? ?? '',
      addressType: json['addressType'] as String? ?? 'HOME',
      addressProvince: json['addressProvince'] as String?,
      addressCity: json['addressCity'] as String?,
      addressDistrict: json['addressDistrict'] as String?,
      addressSubDistrict: json['addressSubDistrict'] as String?,
      addressLine1: json['addressLine1'] as String?,
      addressLine2: json['addressLine2'] as String?,
    );
  }

  String get fullAddress {
    final parts = <String>[];
    if (addressLine1 != null && addressLine1!.isNotEmpty) {
      parts.add(addressLine1!);
    }
    if (addressLine2 != null && addressLine2!.isNotEmpty) {
      parts.add(addressLine2!);
    }
    if (addressSubDistrict != null && addressSubDistrict!.isNotEmpty) {
      parts.add(addressSubDistrict!);
    }
    if (addressDistrict != null && addressDistrict!.isNotEmpty) {
      parts.add(addressDistrict!);
    }
    if (addressCity != null && addressCity!.isNotEmpty) {
      parts.add(addressCity!);
    }
    if (addressProvince != null && addressProvince!.isNotEmpty) {
      parts.add(addressProvince!);
    }
    return parts.join(', ');
  }

  @override
  List<Object?> get props => [
    id,
    addressType,
    addressProvince,
    addressCity,
    addressDistrict,
    addressSubDistrict,
    addressLine1,
    addressLine2,
  ];
}

class ContactModel extends Equatable {
  final String id;
  final String contactType;
  final String contactNumber;

  const ContactModel({
    required this.id,
    required this.contactType,
    required this.contactNumber,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'] as String? ?? '',
      contactType: json['contactType'] as String? ?? 'PHONE',
      contactNumber: json['contactNumber'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [id, contactType, contactNumber];
}

class AccountProfileModel extends Equatable {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? pob;
  final String? dob;
  final String? nationality;
  final String? religion;
  final List<AddressModel> addresses;
  final List<ContactModel> contacts;

  const AccountProfileModel({
    required this.id,
    this.firstName,
    this.lastName,
    this.pob,
    this.dob,
    this.nationality,
    this.religion,
    this.addresses = const [],
    this.contacts = const [],
  });

  factory AccountProfileModel.fromJson(Map<String, dynamic> json) {
    return AccountProfileModel(
      id: json['id'] as String? ?? '',
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      pob: json['pob'] as String?,
      dob: json['dob'] as String?,
      nationality: json['nationality'] as String?,
      religion: json['religion'] as String?,
      addresses:
          (json['addresses'] as List<dynamic>?)
              ?.map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      contacts:
          (json['contacts'] as List<dynamic>?)
              ?.map((e) => ContactModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  String get fullName {
    final parts = <String>[];
    if (firstName != null && firstName!.isNotEmpty) parts.add(firstName!);
    if (lastName != null && lastName!.isNotEmpty) parts.add(lastName!);
    return parts.isEmpty ? '' : parts.join(' ');
  }

  List<ContactModel> get phones => contacts
      .where(
        (c) =>
            c.contactType == 'PHONE' ||
            c.contactType == 'HOME' ||
            c.contactType == 'OFFICE',
      )
      .toList();
  List<ContactModel> get emails =>
      contacts.where((c) => c.contactType == 'EMAIL').toList();

  AddressModel? get homeAddress =>
      addresses.where((a) => a.addressType == 'HOME').firstOrNull;
  AddressModel? get officeAddress =>
      addresses.where((a) => a.addressType == 'OFFICE').firstOrNull;

  @override
  List<Object?> get props => [
    id,
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

class AccountDetailModel extends Equatable {
  final String id;
  final String username;
  final String status;
  final String? createdAt;
  final AccountProfileModel profile;

  const AccountDetailModel({
    required this.id,
    required this.username,
    required this.status,
    this.createdAt,
    required this.profile,
  });

  factory AccountDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return AccountDetailModel(
      id: data['id'] as String? ?? '',
      username: data['username'] as String? ?? '',
      status: data['status'] as String? ?? '',
      createdAt: data['createdAt'] as String?,
      profile: data['profile'] != null
          ? AccountProfileModel.fromJson(
              data['profile'] as Map<String, dynamic>,
            )
          : const AccountProfileModel(id: ''),
    );
  }

  @override
  List<Object?> get props => [id, username, status, createdAt, profile];
}

class UpdateProfileRequest extends Equatable {
  final String? firstName;
  final String? lastName;
  final String? pob;
  final String? dob;
  final String? nationality;
  final String? religion;

  const UpdateProfileRequest({
    this.firstName,
    this.lastName,
    this.pob,
    this.dob,
    this.nationality,
    this.religion,
  });

  Map<String, dynamic> toJson() {
    return {
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      if (pob != null) 'pob': pob,
      if (dob != null) 'dob': dob,
      if (nationality != null) 'nationality': nationality,
      if (religion != null) 'religion': religion,
    };
  }

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    pob,
    dob,
    nationality,
    religion,
  ];
}

class UpdateAddressRequest extends Equatable {
  final String? id;
  final String? addressType;
  final String? addressProvince;
  final String? addressCity;
  final String? addressDistrict;
  final String? addressSubDistrict;
  final String? addressLine1;
  final String? addressLine2;

  const UpdateAddressRequest({
    this.id,
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
      if (id != null) 'id': id,
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
    id,
    addressType,
    addressProvince,
    addressCity,
    addressDistrict,
    addressSubDistrict,
    addressLine1,
    addressLine2,
  ];
}

class UpdateContactRequest extends Equatable {
  final String? id;
  final String? contactType;
  final String? contactNumber;

  const UpdateContactRequest({this.id, this.contactType, this.contactNumber});

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (contactType != null) 'contactType': contactType,
      if (contactNumber != null) 'contactNumber': contactNumber,
    };
  }

  @override
  List<Object?> get props => [id, contactType, contactNumber];
}
