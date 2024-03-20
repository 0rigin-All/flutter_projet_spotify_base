

import 'package:projet_spotify_gorouter/model/Track.dart';

class Artist {
  final String name;
  final String id;
  final String img;
  final List<Track> topTracks;
  Artist({required this.id, required this.name, required this.img, required this.topTracks });

  factory Artist.fromJson(Map<String, dynamic> data) {
    List<Track> topTracks = [];
    num lenght = data['tracks']?.length ?? 0;
    for(var i= 0; i < lenght; i++){
      topTracks.add(Track.fromJson(data['tracks']?[i]));
    }
    return Artist(
        name: data['name'].toString() ?? "",
        id: data['id'].toString() ?? "",
        img: data['images']?[0]?['url'].toString() ?? "",
        topTracks: topTracks);
  }
}
