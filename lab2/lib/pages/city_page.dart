import 'package:flutter/material.dart';
import 'package:lab2/entities/film_entity.dart';
import 'package:lab2/handlers/firebase_app_data_handler.dart';
import 'package:lab2/widgets/images_holder.dart';

class FilmPage extends StatefulWidget {
  final FilmEntity filmEntity;

  const FilmPage({super.key, required this.filmEntity});

  @override
  State<FilmPage> createState() => _FilmPageState();
}

class _FilmPageState extends State<FilmPage> {
  bool _isAdding = false;
  bool _isInFavorites = false;

  @override
  void initState() {
    super.initState();
    _updateInFavoritesState();
  }

  Widget _buildFilmWidget(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.max, children: [
      Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
        padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
        decoration: BoxDecoration(
          color:
              Theme.of(context).colorScheme.primaryContainer.withOpafilm(0.3),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
              child: Text(
                widget.filmEntity.name,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontSize: 15,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
              child: Text(
                'Country: ${widget.filmEntity.country}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
              child: Text(
                'Year of foundation: ${widget.filmEntity.yearOfFoundation}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
              child: Text(
                'Description: ${widget.filmEntity.description}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
      ),
      ImagesHolder(images: widget.filmEntity.imageUrls),
      GestureDetector(
        onTap: () {
          _addToFavorites();
          _updateInFavoritesState();
        },
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: _isAdding
                  ? CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onPrimary,
              )
                  : Text(
                _isInFavorites
                    ? 'Remove from favorites'
                    : 'Add to favorites',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          widget.filmEntity.name,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        centerTitle: true,
      ),
      body: _buildFilmWidget(context),
    );
  }

  void _addToFavorites() async {
    setState(() {
      _isAdding = true;
    });

    if (_isInFavorites) {
      await FirebaseAppDataHandler.removeFromFavorites(widget.filmEntity);
    } else {
      await FirebaseAppDataHandler.addToFavorites(widget.filmEntity);
    }

    _updateInFavoritesState();

    setState(() {
      _isAdding = false;
    });
  }

  void _updateInFavoritesState() async {
    bool isInFavorites =
        await FirebaseAppDataHandler.checkIfInFavorites(widget.filmEntity);
    setState(() {
      _isInFavorites = isInFavorites;
    });
  }
}
