import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:projet_spotify_gorouter/model/Album.dart';

import '../services/AlbumProvider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Album> _searchResults = [];

  void _searchAlbums(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    var result = await fetchSearchAlbums(query);
    setState(() {
      _searchResults = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Albums'),
        backgroundColor: const Color(0xFF1DB954), // Couleur verte de Spotify
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _searchAlbums(value),
              decoration: InputDecoration(
                hintText: 'Search Albums...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _searchAlbums('');
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final album = _searchResults[index];
                return ListTile(
                  leading: album.img.isNotEmpty
                      ? Image.network(
                          album.img,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.image),
                  title: Text(album.name),
                  subtitle: Text(album.artists.map((artist) => artist.name).join(', ')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
