class LoginRequest {
  final String email;
  final String password;
  final String category; 

  LoginRequest({required this.email, required this.password, required this.category});

  Map<String, dynamic> toJson() => {
        "email": email.trim(),
        "password": password,
        "category": category,
      };
}

class LoginResponse {
  final bool success;
  final String message;
  final LoginData? data;

  LoginResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json["success"] == true,
      message: (json["message"] ?? "").toString(),
      data: json["data"] != null
          ? LoginData.fromJson(json["data"])
          : null,
    );
  }
}

class LoginData {
  final String accessToken;
  final String refreshToken;
  final String name;
  final String email;
  final String role;
  final String id;
  final String category;

  LoginData({
    required this.accessToken,
    required this.refreshToken,
    required this.name,
    required this.email,
    required this.role,
    required this.id,
    required this.category,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      accessToken: json["accessToken"],
      refreshToken: json["refreshToken"],
      name: json["name"],
      email: json["email"],
      role: json["role"],
      id: json["_id"],
      category: json["category"],
    );
  }
}