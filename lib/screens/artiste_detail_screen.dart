import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:projet_spotify_gorouter/model/Artist.dart';
import 'package:projet_spotify_gorouter/services/ArtistProvider.dart';
import 'package:projet_spotify_gorouter/services/ChangeNotifierProvider.dart';
import 'package:provider/provider.dart';

class ArtistDetailScreen extends StatefulWidget {
  final String? artistId;

  const ArtistDetailScreen({Key? key, this.artistId}) : super(key: key);

  @override
  State<ArtistDetailScreen> createState() => _ArtistDetailScreenState();
}

class _ArtistDetailScreenState extends State<ArtistDetailScreen> {
  Artist _artist = Artist(id: "", name: "", img: "", topTracks: [], genres: []);

  late PlaylistProvider _playlistProvider;
  late PlaylistProviderT _playlistProviderT;

  @override
  void initState() {
    super.initState();
    _getArtist();
    _playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
    _playlistProviderT = Provider.of<PlaylistProviderT>(context, listen: false);
  }

  void _getArtist() async {
    var result = await fetchArtist(widget.artistId!);
    setState(() {
      _artist = result!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayer = Provider.of<AudioPlayer>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1DB954), // Couleur verte de Spotify
        title: const Text('Artist Detail'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            CircleAvatar(
              radius: 80,
              backgroundColor: Colors.transparent,
              backgroundImage: _artist.img.isNotEmpty
                  ? Image.network(_artist.img).image
                  : const AssetImage(
                      'assets/placeholder.png'), // Placeholder image
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              _artist.name,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white), // Texte blanc
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Top Tracks',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white), // Texte blanc
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _artist.topTracks.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green), // Bordure verte
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween, // Alignement à droite
                      children: [
                        IconButton(
                          icon: const Icon(Icons.play_arrow,
                              color: Colors.white), // Icône Play
                          onPressed: () {
                            var index2 = audioPlayer.currentIndex ?? 0;

                            _playlistProvider.playlist.add(AudioSource.uri(
                                Uri.parse(_artist.topTracks[index].audioUrl)));
                            _playlistProviderT.playlist
                                .add(_artist.topTracks[index]);
                            audioPlayer.setAudioSource(
                                _playlistProvider.playlist,
                                initialIndex: index2,
                                initialPosition: Duration.zero);
                            audioPlayer.seek(Duration.zero, index: index2);
                            audioPlayer.play();
                          },
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _artist.topTracks[index].name,
                            style: const TextStyle(
                                color: Colors.white), // Texte blanc
                            textAlign: TextAlign.center, // Centrage du texte
                          ),
                        ),
                        PopupMenuButton<int>(
                          icon: const Icon(Icons.more_vert,
                              color: Colors
                                  .white), // Icône avec trois points verticaux
                          itemBuilder: (context) => [
                            const PopupMenuItem<int>(
                              value: 1,
                              child: Text('Ajoutez à votre Playlist'),
                            ),
                            const PopupMenuItem<int>(
                              value: 2,
                              child: Text('Lire ensuite'),
                            ),
                            const PopupMenuItem<int>(
                              value: 3,
                              child: Text("Ajouter à la file d'attente"),
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
                                    AudioSource.uri(Uri.parse(_artist.topTracks[index].audioUrl)));
                                _playlistProviderT.playlist.insert(
                                    audioPlayer.currentIndex! + 1, _artist.topTracks[index]);
                                break;
                              case 3:
                                _playlistProvider.playlist.add(
                                    AudioSource.uri(Uri.parse(_artist.topTracks[index].audioUrl)));
                                _playlistProviderT.playlist.add(_artist.topTracks[index]);
                                break;
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black, // Fond noir
    );
  }
}
