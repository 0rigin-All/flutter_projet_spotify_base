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
          ElevatedButton(
            onPressed: () => context.go('/a/albumdetails'),
            child: const Text('Go to the Details screen'),
          ),
          const SizedBox(height: 20),
          Text('Nombre d\'albums : ${_albumList.length}'),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _albumList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_albumList[index].name), 
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