import 'package:flutter/material.dart';
import 'package:news_app/models/article_model.dart';
import 'package:google_fonts/google_fonts.dart';

class ArticleDetailsPage extends StatelessWidget {
  final Article article;

  ArticleDetailsPage({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Happy Reading",
          style: GoogleFonts.oswald(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage != null && article.urlToImage!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  article.urlToImage!,
                  height: 200.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200.0,
                      width: double.infinity,
                      color: Colors.grey,
                      child: Center(child: Text("Failed to load image")),
                    );
                  },
                ),
              )
            else
              Container(
                height: 200.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text("No Image"),
                ),
              ),
            SizedBox(height: 16.0),
            Text(
              article.title!,
              style: GoogleFonts.oswald(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                SizedBox(width: 8.0),
                Text(
                  article.author ?? 'Unknown Author',
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              article.content ?? 'No Content',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
