// ignore_for_file: file_names

import 'dart:convert' show json, jsonEncode;
import 'dart:io';
import 'dart:typed_data';
import 'package:declarative_route/db/AuthRepository.dart';
import 'package:declarative_route/model/error.dart';
import 'package:declarative_route/model/login.dart';
import 'package:declarative_route/model/register.dart';
import 'package:declarative_route/model/stories.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiService {
  static const String _baseUrl = 'https://story-api.dicoding.dev/v1/';
  Future<RegisterResponse> postRegister(RegisterRequest payload) async {
    final response = await http.post(Uri.parse("${_baseUrl}register"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'name': payload.name,
          'email': payload.email,
          'password': payload.password
        }));
    if (response.statusCode == 201) {
      return RegisterResponse.fromJson(json.decode(response.body));
    } else {
      final error = RegisterResponse.fromJson(json.decode(response.body));
      throw Exception(error.message);
    }
  }

  Future<LoginResponse> postLogin(LoginRequest payload) async {
    final response = await http.post(Uri.parse("${_baseUrl}login"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:
            jsonEncode({'email': payload.email, 'password': payload.password}));
    if (response.statusCode == 200) {
      return LoginResponse.fromJson(json.decode(response.body));
    } else {
      final error = LoginResponse.fromJson(json.decode(response.body));
      throw Exception(error.message);
    }
  }

  Future<Stories> fetchGetStories() async {
    final token = await AuthRepository().getToken();
    final response = await http.get(Uri.parse("${_baseUrl}stories"),
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    if (response.statusCode == 200) {
      return Stories.fromJson(json.decode(response.body));
    } else {
      final error = ErrorResponse.fromJson(json.decode(response.body));
      throw Exception(error.message);
    }
  }

  Future<Story> fetchGetStory(String idStory) async {
    final token = await AuthRepository().getToken();
    final response = await http.get(Uri.parse("${_baseUrl}stories/$idStory"),
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    if (response.statusCode == 200) {
      return Story.fromJson(json.decode(response.body));
    } else {
      final error = ErrorResponse.fromJson(json.decode(response.body));
      throw Exception(error.message);
    }
  }

  Future<ErrorResponse> postStory(
      List<int> bytes, String fileName, String description) async {
    final token = await AuthRepository().getToken();
    var request =
        http.MultipartRequest('POST', Uri.parse("${_baseUrl}stories"));

    final multiPartFile = http.MultipartFile.fromBytes(
      "photo",
      bytes,
      filename: fileName,
    );
    final Map<String, String> fields = {
      "description": description,
    };
    final Map<String, String> headers = {
      "Content-type": "multipart/form-data",
      HttpHeaders.authorizationHeader: "Bearer $token"
    };
    request.files.add(multiPartFile);
    request.fields.addAll(fields);
    request.headers.addAll(headers);
    final http.StreamedResponse streamedResponse = await request.send();
    final int statusCode = streamedResponse.statusCode;
    final Uint8List responseList = await streamedResponse.stream.toBytes();
    final String responseData = String.fromCharCodes(responseList);

    if (statusCode == 201) {
      return ErrorResponse.fromJson(json.decode(responseData));
    } else {
      final error = ErrorResponse.fromJson(json.decode(responseData));
      throw Exception(error.message);
    }
  }
}
