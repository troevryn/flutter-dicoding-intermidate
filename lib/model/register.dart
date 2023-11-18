import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
part 'register.g.dart';
@JsonSerializable()
class RegisterResponse {
  bool error;
  String message;

  RegisterResponse({
    required this.error,
    required this.message,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>_$RegisterResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);
}


@JsonSerializable()
class RegisterRequest {
  String name;
  String email;
  String password;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>_$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}

RegisterRequest registerRequestFromJson(String str) =>
    RegisterRequest.fromJson(json.decode(str));

String registerRequestToJson(RegisterRequest data) =>
    json.encode(data.toJson());


RegisterResponse registerResponseFromJson(String str) =>
    RegisterResponse.fromJson(json.decode(str));

String registerResponseToJson(RegisterResponse data) =>
    json.encode(data.toJson());
