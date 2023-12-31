import 'dart:io';

import 'package:declarative_route/api/api_service.dart';
import 'package:declarative_route/model/stories.dart';
import 'package:flutter/material.dart';

enum ResultState { loading, noData, hasData, error }

class StoriesProvider extends ChangeNotifier {
  final ApiService apiService;
  StoriesProvider({required this.apiService}) {
    _fetchStories();
  }
  late Stories _stories;
  late ResultState _state;
  List<ListStory> listStory = [];
  int pageItems = 1;

  int sizeItems = 10;
  String _message = '';
  bool _refresh = false;
  String get message => _message;

  Stories get result => _stories;
  bool get refresh => _refresh;

  ResultState get state => _state;
  void fetchData() async {
    listStory=[];
    await _fetchStories();
    notifyListeners();
  }

  void setRefesh(bool value) {
    _refresh = value;
  }
  void incrementPageItems(){
    pageItems+=1;
    notifyListeners();
  }

  Future<void> getStories() async {
    _fetchStories();
  }

  Future<dynamic> _fetchStories() async {
    try {
      if (pageItems == 1) {
        _state = ResultState.loading;
        notifyListeners();
      }
      final stories = await apiService.fetchGetStories(pageItems, sizeItems);
      if (stories.listStory.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        listStory.addAll(stories.listStory);
        notifyListeners();

        return _stories = stories;
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
