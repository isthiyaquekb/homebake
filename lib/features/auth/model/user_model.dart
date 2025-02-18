import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? userId;
  final String role;
  final String firstname;
  final String lastname;
  final String email;
  final String phone;
  final String address;
  final String gender;
  final DateTime dob;
  final Timestamp createdAt;
  final Timestamp modifiedAt;

  UserModel({
    this.userId,
    required this.role,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.phone,
    required this.address,
    required this.gender,
    required this.dob,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      userId : json['userId'],
      role : json['role'],
      firstname :json['firstname'],
      lastname :json['lastname'],
      email : json['email'],
      phone : json['phone']??"NA",
      address : json['address']??"NA",
      gender : json['gender']??"NA",
      dob : json['dob']??"NA",
      createdAt: json["createdAt"] ?? Timestamp.now(),
      modifiedAt: json["modifiedAt"] ?? Timestamp.now(),

    );
  }

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "role": role,
    "firstname": firstname,
    "lastname": lastname,
    "email": email,
    "gender": gender,
    "phone": phone,
    "address": address,
    "dob": dob,
    "createdAt": createdAt,
    "modifiedAt": modifiedAt,
  };


  /// Converts a FireStore document snapshot to a ProductModel instance
  factory UserModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UserModel.fromMap(data,);
  }

}