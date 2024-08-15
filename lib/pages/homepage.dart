import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/components/customListTile.dart';
import 'package:news_app/components/genreSelector.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/services/api_service.dart';
import 'package:news_app/pages/article_details_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiService client = ApiService();
  PageController _pageController = PageController();
  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<Article> _allArticles = [];
  List<Article> _filteredArticles = [];
  
  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  Future<void> _fetchArticles() async {
    List<Article> articles = await client.getArticle();
    setState(() {
      _allArticles = articles;
      _filteredArticles = articles;
    });
  }

  void _filterArticles(String query) {
    setState(() {
      _filteredArticles = _allArticles.where((article) {
        final title = article.title?.toLowerCase() ?? '';
        final searchQuery = query.toLowerCase();
        return title.contains(searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> genres = ["Hot News", "Environment", "Animal", "Politic", "Sports", "Technology"];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Text(
                    "Newzze",
                    style: GoogleFonts.oswald(
                      color: Color(0xFF348b05),
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: _isSearching
                        ? AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                  hintText: "Search...",
                                  border: InputBorder.none,
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: () {
                                      setState(() {
                                        _isSearching = false;
                                        _searchController.clear();
                                        _filteredArticles = _allArticles;
                                      });
                                    },
                                  ),
                                ),
                                onChanged: (query) {
                                  _filterArticles(query);
                                },
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                  ),
                  if (!_isSearching)
                    IconButton(
                      icon: Icon(Icons.search_outlined),
                      onPressed: () {
                        setState(() {
                          _isSearching = true;
                        });
                      },
                    ),
                ],
              ),
            ),
            FutureBuilder<List<Article>>(
              future: client.getArticle(),
              builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                } else if (snapshot.hasData) {
                  List<Article> articles = snapshot.data!;
                  List<Article> carouselArticles = articles.take(5).toList();
                  return Expanded(
                    child: Column(
                      children: [
                        Container(
                          height: 200.0,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: carouselArticles.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ArticleDetailsPage(
                                        article: carouselArticles[index],
                                      ),
                                    ),
                                  );
                                },
                                child: Stack(
                                  children: [
                                    if (carouselArticles[index].urlToImage != null &&
                                        carouselArticles[index].urlToImage!.isNotEmpty)
                                      Container(
                                        height: 200.0,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(carouselArticles[index].urlToImage!),
                                            fit: BoxFit.cover,
                                            onError: (error, stackTrace) {
                                              print('Failed to load image: $error');
                                            },
                                          ),
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        margin: EdgeInsets.all(10.0),
                                      )
                                    else
                                      Container(
                                        height: 200.0,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        child: Center(
                                          child: Text("No Image"),
                                        ),
                                        margin: EdgeInsets.all(10.0),
                                      ),
                                    Positioned(
                                      bottom: 10,
                                      left: 10,
                                      right: 10,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                        color: Colors.black.withOpacity(0.5),
                                        child: Text(
                                          carouselArticles[index].title ?? '',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: SmoothPageIndicator(
                            controller: _pageController,
                            count: carouselArticles.length,
                            effect: WormEffect(
                              dotHeight: 8.0,
                              dotWidth: 8.0,
                              activeDotColor: Color(0xFF348b05),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GenreSelector(
                            genres: genres,
                            onGenreSelected: (String genre) {
                              // 
                              print("Selected genre: $genre");
                            },
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _filteredArticles.length,
                            itemBuilder: (context, index) => customListTile(_filteredArticles[index], context),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: Text("No data available"),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
