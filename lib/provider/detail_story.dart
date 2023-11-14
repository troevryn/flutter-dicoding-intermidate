import 'dart:io';

import 'package:declarative_route/api/api_service.dart';
import 'package:declarative_route/model/stories.dart';
import 'package:flutter/material.dart';

enum ResultState { loading, noData, hasData, error }

class StoryProvider extends ChangeNotifier {
  final ApiService apiService;
  final String storyId;
  StoryProvider({required this.apiService, required this.storyId}) {
    _fetchStory(storyId);
  }
  late Story _story;
  late ResultState _state;
  String _message = '';
  String get message => _message;

  Story get result => _story;

  ResultState get state => _state;

  Future<dynamic> _fetchStory(String idStory) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final story = await apiService.fetchGetStory(idStory);
      // ignore: unnecessary_null_comparison
      if (story.story == null) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _story = story;
      }
    } on SocketException {
      // Tangani kesalahan koneksi SocketException
      _state = ResultState.error; // Atur status noInternet
      notifyListeners();
      return _message = 'No Internet Connection';
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
