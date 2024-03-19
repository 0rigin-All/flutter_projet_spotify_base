import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:projet_spotify_gorouter/model/Album.dart';
import 'package:projet_spotify_gorouter/model/Artist.dart';
import 'package:projet_spotify_gorouter/model/Track.dart';
import 'package:projet_spotify_gorouter/services/AlbumProvider.dart';

class AlbumDetailScreen extends StatefulWidget {
  final String? albumId;

  const AlbumDetailScreen({Key? key, this.albumId}) : super(key: key);

  @override
  State<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
        Album _album = Album(name: "", id: "", artists: [], img: "", tracks: []);

  @override
  void initState() {
    super.initState();
    _getAlbum();
  }

  void _getAlbum() async {
    var result = await fetchAlbum(widget.albumId!);
    setState(() {
      _album = result!;
    });
  }

 
  @override
  Widget build(BuildContext context) {
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
                            color: Colors.white, // Couleur du texte
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Artists:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey, // Couleur du texte
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
                                    primary: Colors.green, // Fond vert
                                    onPrimary: Colors.black, // Texte noir
                                  ),
                                  child: Text(
                                    artist.name,
                                    style: const TextStyle(color: Colors.black), // Couleur du texte
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
                            color: Colors.grey, // Couleur du texte
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
                        title: Text(
                          _album.tracks[index].name,
                          style: const TextStyle(color: Colors.white), // Couleur du texte
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