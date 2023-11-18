import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'error.g.dart';
@JsonSerializable()

class ErrorResponse {
  bool error;
  String message;

  ErrorResponse({
    required this.error,
    required this.message,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => _$ErrorResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);
}
ErrorResponse errorResponseFromJson(String str) =>
    ErrorResponse.fromJson(json.decode(str));

String errorResponseToJson(ErrorResponse data) => json.encode(data.toJson());
