import 'dart:convert';

RegisterResponse registerResponseFromJson(String str) =>
    RegisterResponse.fromJson(json.decode(str));

String registerResponseToJson(RegisterResponse data) =>
    json.encode(data.toJson());

class RegisterResponse {
  bool error;
  String message;

  RegisterResponse({
    required this.error,
    required this.message,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      RegisterResponse(
        error: json["error"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
      };
}

RegisterRequest registerRequestFromJson(String str) =>
    RegisterRequest.fromJson(json.decode(str));

String registerRequestToJson(RegisterRequest data) =>
    json.encode(data.toJson());

class RegisterRequest {
  String name;
  String email;
  String password;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      RegisterRequest(
        name: json["name"],
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "password": password,
      };
}
