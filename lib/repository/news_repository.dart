import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_news_app/models/categories_news_model.dart';
import 'package:flutter_news_app/models/news_channels_headlines_model.dart';
import 'package:http/http.dart' as http;

class NewsRepository {
  //function to fetch  news headlines
  Future<NewsChannelsHeadlinesModel> fetchNewsChannelHeadlinesAPI(
      String changeName) async {
    String url =
        "https://newsapi.org/v2/top-headlines?sources=${changeName}&apiKey=7775b068d14a487fa7c58ee7bd996d30";
    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print(response.body);
    }

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsChannelsHeadlinesModel.fromJson(body);
    } else {
      throw Exception("Error $response");
    }
  }

  //function to  fetch news categories
  Future<CategoriesNewsModel> fetchCategoriesNewsAPIs(String category) async {
    String url =
        "https://newsapi.org/v2/everything?q=$category&apiKey=7775b068d14a487fa7c58ee7bd996d30";
    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print("categories:::::${response.body}");
    }
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
    } else {
      throw Exception("Error $response");
    }
  }
}
