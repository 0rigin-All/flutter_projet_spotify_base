import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:projet_spotify_gorouter/model/Album.dart';
import 'package:projet_spotify_gorouter/services/AlbumProvider.dart';

// -- les derniers albums (news)
class AlbumNewsScreen extends StatefulWidget {
  /// Constructs a [AlbumNewsScreen]
  const AlbumNewsScreen({super.key});
   @override
  State<AlbumNewsScreen> createState()=> _AlbumNewsScreenState();
}

  class _AlbumNewsScreenState extends State<AlbumNewsScreen>{

  List<Album> _albumList = [];

  @override
  void initState(){
    _get();
    super.initState();
  }

  void _get() async{
    var result = await fetchNewAlbums();
    setState((){
      _albumList = result;
    });
    }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Album News Screen')),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
          const SizedBox(height: 20),
          const Text(
            'Nouvautés',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _albumList[index].artists.map((artist) => Text(artist.name)).toList(),
                          ),
                        ],
                      ),
                      onTap: () {
                        print(_albumList[index].id);
                         context.go('/a/albumdetails?albumId=${_albumList[index].id}');
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
  );
}

  }