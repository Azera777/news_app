import 'package:flutter/material.dart';

class GenreSelector extends StatefulWidget {
  final List<String> genres;
  final Function(String) onGenreSelected;

  const GenreSelector({required this.genres, required this.onGenreSelected, Key? key}) : super(key: key);

  @override
  _GenreSelectorState createState() => _GenreSelectorState();
}

class _GenreSelectorState extends State<GenreSelector> {
  String? selectedGenre;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.genres.map((genre) {
          bool isSelected = genre == selectedGenre;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text(genre),
              selected: isSelected,
              selectedColor: Colors.green,
              onSelected: (bool selected) {
                setState(() {
                  selectedGenre = selected ? genre : null;
                });
                widget.onGenreSelected(selectedGenre!);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              labelStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            ),
          );
        }).toList(),
      ),
    );
  }
}
