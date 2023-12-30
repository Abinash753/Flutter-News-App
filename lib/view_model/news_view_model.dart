import 'package:flutter_news_app/models/categories_news_model.dart';
import 'package:flutter_news_app/models/news_channels_headlines_model.dart';
import 'package:flutter_news_app/repository/news_repository.dart';

class NewsViewModle {
  final _response = NewsRepository();
  //fetching the newschannel headlines  from  NewsRepository class
  Future<NewsChannelsHeadlinesModel> fetchNewsChannelHeadlinesAPI(
      String changeName) async {
    final response = await _response.fetchNewsChannelHeadlinesAPI(changeName);
    return response;
  }

  //fetching news categirues from  NewsRepository class
  Future<CategoriesNewsModel> fetchCategoriesNewsAPIs(String category) async {
    final response = await _response.fetchCategoriesNewsAPIs(category);
    return response;
  }
}
