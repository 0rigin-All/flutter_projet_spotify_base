import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';

import 'package:projet_spotify_gorouter/model/Album.dart';
import 'package:projet_spotify_gorouter/services/ArtistProvider.dart';
import 'package:projet_spotify_gorouter/services/TracksProvider.dart';
import 'package:provider/provider.dart';

import '../model/Artist.dart';
import '../model/Track.dart';
import '../services/AlbumProvider.dart';
import '../services/ChangeNotifierProvider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Album> _searchAlbumResults = [];
  List<Artist> _searchArtistResults = [];
  List<Track> _searchTrackResults = [];

  late PlaylistProvider _playlistProvider;
  late PlaylistProviderT _playlistProviderT;

  @override
  void initState() {
    super.initState();
    _playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
    _playlistProviderT = Provider.of<PlaylistProviderT>(context, listen: false);
  }

  void _searchAlbums(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchAlbumResults = [];
        _searchArtistResults = [];
        _searchTrackResults = [];
      });
      return;
    }

    var resultAlbum = await fetchSearchAlbums(query);
    var resultArtists = await fetchSearchArtists(query);
    var resultTracks = await fetchSearchTracks(query);
    setState(() {
      _searchAlbumResults = resultAlbum;
      _searchArtistResults = resultArtists;
      _searchTrackResults = resultTracks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Albums & Artists'),
        backgroundColor: const Color(0xFF1DB954), // Couleur verte de Spotify
      ),
      body: Container(
        color: Colors.black, // Fond noir
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
  controller: _searchController,
  onChanged: (value) => _searchAlbums(value),
  style: const TextStyle(color: Colors.white), // Couleur du texte en blanc
  decoration: InputDecoration(
    hintText: 'Search Albums & Artists...',
    hintStyle: const TextStyle(color: Colors.white), // Couleur du texte d'indication en blanc
    suffixIcon: IconButton(
      icon: const Icon(Icons.clear, color: Colors.white), // Icône blanche
      onPressed: () {
        _searchController.clear();
        _searchAlbums('');
      },
    ),
  ),
),
            ),
            _buildResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    if (_searchController.text.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text(
            'Start typing to search',
            style: TextStyle(fontSize: 16, color: Colors.white), // Texte blanc
          ),
        ),
      );
    } else {
      return Expanded(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Top Results',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Texte blanc
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: [
                  _buildCategoryTitle('Tracks'),
                  const SizedBox(height: 8),
                  _buildTracks(),
                  const SizedBox(height: 16),
                  _buildCategoryTitle('Albums'),
                  const SizedBox(height: 8),
                  _buildAlbums(),
                  const SizedBox(height: 16),
                  _buildCategoryTitle('Artists'),
                  const SizedBox(height: 8),
                  _buildArtists(),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildTracks() {
    final audioPlayer = Provider.of<AudioPlayer>(context);
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount:
          _searchTrackResults.length > 3 ? 3 : _searchTrackResults.length,
      itemBuilder: (context, index) {
        final track = _searchTrackResults[index];
        return ListTile(
          onTap: () {
            index = audioPlayer.currentIndex ?? 0;
            
            _playlistProvider.playlist
                .add(AudioSource.uri(Uri.parse(track.audioUrl)));
            _playlistProviderT.playlist.add(track);
            audioPlayer.setAudioSource(_playlistProvider.playlist,
                initialIndex: index, initialPosition: Duration.zero);
            audioPlayer.seek(Duration.zero,
                index: index);
            audioPlayer.play();
          },
          leading:
              const Icon(Icons.play_arrow, color: Colors.green), // Icône Play
          title: Text(track.name, style: const TextStyle(color: Colors.white)), // Texte blanc
          subtitle: Text(track.artists.map((artist) => artist.name).join(', '), style: const TextStyle(color: Colors.white)), // Texte blanc
          trailing: PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert,
                color: Colors.green), // Icône avec trois points verticaux
            itemBuilder: (context) => [
              const PopupMenuItem<int>(
                value: 1,
                child: Text('Add to Playlist', style: TextStyle(color: Colors.black)), // Texte blanc
              ),
              const PopupMenuItem<int>(
                value: 2,
                child: Text('Play Next', style: TextStyle(color: Colors.black)), // Texte blanc
              ),
              const PopupMenuItem<int>(
                value: 3,
                child: Text('Add to Queue', style: TextStyle(color: Colors.black)), // Texte blanc
              ),
            ],
            onSelected: (value) {
              // Fonction à exécuter lorsqu'une option est sélectionnée
              switch (value) {
                case 1:
                  print(audioPlayer.currentIndex);
                  break;
                case 2:
                  _playlistProvider.playlist.insert(
                      audioPlayer.currentIndex! + 1,
                      AudioSource.uri(Uri.parse(track.audioUrl)));
                  _playlistProviderT.playlist.insert(audioPlayer.currentIndex! + 1, track);
                  break;
                case 3:
                  _playlistProvider.playlist
                      .add(AudioSource.uri(Uri.parse(track.audioUrl)));
                   _playlistProviderT.playlist
                      .add(track);
                  break;
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildCategoryTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white, // Texte blanc
        ),
      ),
    );
  }

  Widget _buildAlbums() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount:
          _searchAlbumResults.length > 3 ? 3 : _searchAlbumResults.length,
      itemBuilder: (context, index) {
        final album = _searchAlbumResults[index];
        return ListTile(
          onTap: () {
            context.go('/b/albumdetails/${album.id}');
          },
          leading: album.img.isNotEmpty
              ? Image.network(
                  album.img,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                )
              : const Icon(Icons.image),
          title: Text(album.name, style: const TextStyle(color: Colors.white)), // Texte blanc
          subtitle: Text(album.artists.map((artist) => artist.name).join(', '), style: const TextStyle(color: Colors.white)), // Texte blanc
        );
      },
    );
  }

  Widget _buildArtists() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount:
          _searchArtistResults.length > 3 ? 3 : _searchArtistResults.length,
      itemBuilder: (context, index) {
        final artist = _searchArtistResults[index];
        return ListTile(
          onTap: () {
            context.go('/b/artistedetails/${artist.id}');
          },
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: artist.img.isNotEmpty
                ? Image.network(
                    artist.img,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.person),
          ),
          title: Text(artist.name, style: const TextStyle(color: Colors.white)), // Texte blanc
          subtitle:
              Text(artist.genres.map((genre) => genre.toString()).join(', '), style: const TextStyle(color: Colors.white)), // Texte blanc
        );
      },
    );
  }
}

