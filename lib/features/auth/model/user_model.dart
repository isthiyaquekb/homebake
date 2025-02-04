class UserModel {
  final String? userId;
  final String role;
  final String firstname;
  final String lastname;
  final String email;
  final String gender;
  final String dob;

  UserModel({
    this.userId,
    required this.role,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.gender,
    required this.dob
  });

  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      userId : json['userId'],
      role : json['role'],
      firstname :json['firstname'],
      lastname :json['lastname'],
      email : json['email'],
      gender : json['gender'],
      dob : json['dob'],
    );
  }

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "role": role,
    "firstname": firstname,
    "lastname": lastname,
    "email": email,
    "gender": gender,
    "dob": dob,
  };

}