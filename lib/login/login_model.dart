class UserData {
  final bool success;
  final User data;

  UserData({
    required this.success,
    required this.data,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      success: json['Success'],
      data: User.fromJson(json['Data']),
    );
  }
}

class User {
  final String userId;
  final String fullName;
  final String emailId;
  final String contactNo;
  final String state;
  final String socialType;
  final String token;

  User({
    required this.userId,
    required this.fullName,
    required this.emailId,
    required this.contactNo,
    required this.state,
    required this.socialType,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['UserId'],
      fullName: json['FullName'],
      emailId: json['EmailId'],
      contactNo: json['ContactNo'],
      state: json['State'],
      socialType: json['SocialType'],
      token: json['Token'],
    );
  }
}

class Data {
  final String status;

  Data({
    required this.status,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      status: json['status'],
    );
  }
}
