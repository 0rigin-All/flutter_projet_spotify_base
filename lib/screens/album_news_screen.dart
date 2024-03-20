import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:projet_spotify_gorouter/model/Album.dart';
import 'package:projet_spotify_gorouter/services/AlbumProvider.dart';

class AlbumNewsScreen extends StatefulWidget {
  const AlbumNewsScreen({Key? key}) : super(key: key);

  @override
  State<AlbumNewsScreen> createState() => _AlbumNewsScreenState();
}

class _AlbumNewsScreenState extends State<AlbumNewsScreen> {
  List<Album> _albumList = [];

  @override
  void initState() {
    _get();
    super.initState();
  }

  void _get() async {
    var result = await fetchNewAlbums();
    setState(() {
      _albumList = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Album News Screen'),
        backgroundColor: const Color(0xFF1DB954), // Couleur verte de Spotify
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Nouveautés',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _albumList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 4,
                      child: ListTile(
                        leading: Image.network(
                          _albumList[index].img,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          _albumList[index].name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            const Text(
                              'Artistes:',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _albumList[index].artists.map((artist) => Text(artist.name, style: const TextStyle(fontSize: 14))).toList(),
                            ),
                          ],
                        ),
                        onTap: () {
                          context.go('/a/albumdetails/${_albumList[index].id}');
                        },
                      ),
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
