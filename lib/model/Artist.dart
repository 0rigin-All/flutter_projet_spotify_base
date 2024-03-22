

import 'package:projet_spotify_gorouter/model/EnumGenre.dart';
import 'package:projet_spotify_gorouter/model/Track.dart';

class Artist {
  final String name;
  final String id;
  final String img;
  final List<Track> topTracks;
  final List<String> genres;
  Artist({required this.id, required this.name, required this.img, required this.topTracks, required this.genres });

  factory Artist.fromJson(Map<String, dynamic> data) {
    List<Track> topTracks = [];
    List<String> genres = [];
    num lenght = data['tracks']?.length ?? 0;
    for(var i= 0; i < lenght; i++){
      topTracks.add(Track.fromJson(data['tracks']?[i]));
    }
    num lenght2 = data['genres']?.length ?? 0;
    for(var i= 0; i < lenght2; i++){
    genres.add(data['genres']?[i]);
    }
    return Artist(
        name: data['name'].toString() ?? "",
        id: data['id'].toString() ?? "",
        img: data['images']?[0]?['url'].toString() ?? "",
        topTracks: topTracks,
        genres : genres);
  }
  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> topTracksMapList = topTracks.map((track) => track.toMap()).toList();

    return {
      'name': name,
      'id': id,
      'img': img,
      'topTracks': topTracksMapList,
      'genres': genres
    };
  }

  factory Artist.fromMap(Map<String, dynamic> map) {
    List<Track> topTracks = (map['topTracks'] as List<dynamic>).map((trackMap) {
      return Track.fromMap(trackMap);
    }).toList();

    return Artist(
      id: map['id'],
      name: map['name'],
      img: map['img'],
      topTracks: topTracks,
      genres: List<String>.from(map['genres']),
    );
  }
}

