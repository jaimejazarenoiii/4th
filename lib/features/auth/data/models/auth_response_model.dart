class AuthResponseModel {
  final StatusModel status;
  final AuthDataModel? data;
  final List<String>? errors;

  const AuthResponseModel({required this.status, this.data, this.errors});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      status: StatusModel.fromJson(json['status']),
      data: json['data'] != null ? AuthDataModel.fromJson(json['data']) : null,
      errors: json['errors'] != null ? List<String>.from(json['errors']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.toJson(),
      if (data != null) 'data': data!.toJson(),
      if (errors != null) 'errors': errors,
    };
  }

  bool get isSuccess => status.code == 200;
}

class StatusModel {
  final int code;
  final String message;

  const StatusModel({required this.code, required this.message});

  factory StatusModel.fromJson(Map<String, dynamic> json) {
    return StatusModel(
      code: json['code'] as int,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'code': code, 'message': message};
  }
}

class AuthDataModel {
  final UserModel user;
  final String token;

  const AuthDataModel({required this.user, required this.token});

  factory AuthDataModel.fromJson(Map<String, dynamic> json) {
    return AuthDataModel(
      user: UserModel.fromJson(json['user']),
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'user': user.toJson(), 'token': token};
  }
}

class UserModel {
  final String id;
  final String email;
  final String? name;

  const UserModel({required this.id, required this.email, this.name});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      email: json['email'] as String,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, if (name != null) 'name': name};
  }
}
