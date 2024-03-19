import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:projet_spotify_gorouter/model/Artist.dart';
import 'package:projet_spotify_gorouter/model/Artist.dart';
import 'package:projet_spotify_gorouter/model/Track.dart';
import 'package:projet_spotify_gorouter/services/ArtistProvider.dart';

class ArtistDetailScreen extends StatefulWidget {
  final String? artistId;

  const ArtistDetailScreen({Key? key, this.artistId}) : super(key: key);

  @override
  State<ArtistDetailScreen> createState() => _ArtistDetailScreenState();
}

class _ArtistDetailScreenState extends State<ArtistDetailScreen> {
        Artist _artist = Artist(id: "", name: "", img: "");

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
    // TODO: implement build
    throw UnimplementedError();
  }

}