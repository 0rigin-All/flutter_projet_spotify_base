import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:projet_spotify_gorouter/model/Album.dart';
import 'package:projet_spotify_gorouter/services/AlbumProvider.dart';
import 'package:provider/provider.dart';

import '../services/ChangeNotifierProvider.dart';

class AlbumDetailScreen extends StatefulWidget {
  final String? albumId;

  const AlbumDetailScreen({Key? key, this.albumId}) : super(key: key);

  @override
  State<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  Album _album = Album(name: "", id: "", artists: [], img: "", tracks: []);

    late PlaylistProvider _playlistProvider;
  late PlaylistProviderT _playlistProviderT;

  @override
  void initState() {
    super.initState();
    _getAlbum();
        _playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
    _playlistProviderT = Provider.of<PlaylistProviderT>(context, listen: false);
  }

  void _getAlbum() async {
    var result = await fetchAlbum(widget.albumId!);
    setState(() {
      _album = result!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayer = Provider.of<AudioPlayer>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: _album != null
          ? CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 300.0,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                      child: Image.network(
                        _album.img,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  backgroundColor: Colors.black,
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _album.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Artists:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: _album.artists
                              .map(
                                (artist) => ElevatedButton(
                                  onPressed: () {
                                    context.go('/a/artistedetails/${artist.id}');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green,
                                    onPrimary: Colors.black,
                                  ),
                                  child: Text(
                                    artist.name,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Tracks:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return ListTile(
                        title: Row(
                          children: [
                            IconButton(
                              // ignore: prefer_const_constructors
                              icon: Icon(Icons.play_arrow, color: Colors.white),
                              onPressed: () {
                               var index2 = audioPlayer.currentIndex ?? 0;

                            _playlistProvider.playlist.add(AudioSource.uri(
                                Uri.parse(_album.tracks[index].audioUrl)));
                            _playlistProviderT.playlist
                                .add(_album.tracks[index]);
                            audioPlayer.setAudioSource(
                                _playlistProvider.playlist,
                                initialIndex: index2,
                                initialPosition: Duration.zero);
                            audioPlayer.seek(Duration.zero, index: index2);
                            audioPlayer.play();
                              },
                            ),
                            Text(
                              _album.tracks[index].name,
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(width: 10),
                        
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
                                    AudioSource.uri(Uri.parse(_album.tracks[index].audioUrl)));
                                _playlistProviderT.playlist.insert(
                                    audioPlayer.currentIndex! + 1, _album.tracks[index]);
                                break;
                              case 3:
                                _playlistProvider.playlist.add(
                                    AudioSource.uri(Uri.parse(_album.tracks[index].audioUrl)));
                                _playlistProviderT.playlist.add(_album.tracks[index]);
                                break;
                            }
                          },
                        ),
                          ],
                        ),
                        // You can add more details of the track if needed
                      );
                    },
                    childCount: _album.tracks.length,
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
