import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/models/article_model.dart';

class ApiService {
  final String endPointUrl = "https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=46f8487c5f544e70a87a64730c21020a";

  Future<List<Article>> getArticle() async {
    try {
      Uri url = Uri.parse(endPointUrl);
      http.Response res = await http.get(url);

      if (res.statusCode == 200) {
        print(res.body); 
        Map<String, dynamic> json = jsonDecode(res.body);

        List<dynamic> body = json['articles'];

        List<Article> articles = 
          body.map((dynamic item) => Article.fromJson(item)).toList();

        return articles;
      } else {
        print('Failed to load articles: ${res.statusCode}');
        throw Exception("Can't get articles");
      }
    } catch (e) {
      print('Error: $e');
      throw Exception("An error occurred: $e");
    }
  }
}
