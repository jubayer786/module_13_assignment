class UserModel {
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? mobile;
  final String? photo;

  UserModel({
    this.email,
    this.firstName,
    this.lastName,
    this.mobile,
    this.photo,
  });

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      mobile: json['mobile'],
      photo: json['photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'mobile': mobile,
      'photo': photo,
    };
  }
}
