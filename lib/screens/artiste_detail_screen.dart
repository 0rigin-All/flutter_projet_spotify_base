import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:projet_spotify_gorouter/model/Artist.dart';
import 'package:projet_spotify_gorouter/services/ArtistProvider.dart';

class ArtistDetailScreen extends StatefulWidget {
  final String? artistId;

  const ArtistDetailScreen({Key? key, this.artistId}) : super(key: key);

  @override
  State<ArtistDetailScreen> createState() => _ArtistDetailScreenState();
}

class _ArtistDetailScreenState extends State<ArtistDetailScreen> {
  Artist _artist = Artist(id: "", name: "", img: "", topTracks: [], genres: []);

  @override
  void initState() {
    super.initState();
    _getArtist();
  }

  void _getArtist() async {
    var result = await fetchArtist(widget.artistId!);
    setState(() {
      _artist = result!;
    });
  }
  
  @override
  Widget build(BuildContext context) {
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
                  : const AssetImage('assets/placeholder.png'), // Placeholder image
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              _artist.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white), // Texte blanc
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Top Tracks',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white), // Texte blanc
            ),
            const SizedBox(
              height: 10,
            ),
             Expanded(
              child: ListView.builder(
                itemCount: _artist.topTracks.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green), // Bordure verte
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.play_arrow, color: Colors.white), // Icône Play
                          onPressed: () {
                            // Mettez ici la logique de lecture de la piste
                          },
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _artist.topTracks[index].name,
                            style: const TextStyle(color: Colors.white), // Texte blanc
                            textAlign: TextAlign.center, // Centrage du texte
                          ),
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
