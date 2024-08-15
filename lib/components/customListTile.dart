import 'package:flutter/material.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/pages/article_details_page.dart';

Widget customListTile(Article article, BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ArticleDetailsPage(
                    article: article,
                  )));
    },
    child: Container(
      margin: EdgeInsets.all(12.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.0),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3.0)]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (article.urlToImage != null && article.urlToImage!.isNotEmpty)
            Container(
              height: 200.0,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(article.urlToImage!),
                    fit: BoxFit.cover,
                    onError: (error, stackTrace) {
                      print('Failed to load image: $error');
                    },
                  ),
                  borderRadius: BorderRadius.circular(8.0)),
            )
          else
            Container(
              height: 200.0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Text("No Image"),
              ),
            ),
          SizedBox(height: 8.0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: Color(0xFF348b05),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Text(
              article.source?.name ?? 'Unknown Source',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            article.title ?? 'No Title',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    ),
  );
}
