import 'Artist.dart';
import 'Track.dart';


class Album {
  final String name;
  final String id;
  final List<Artist> artists;
  final List<Track> tracks;
  final String img;
  Album({required this.name,required this.id,required this.artists,required this.img,required this.tracks});

  
  factory Album.fromJson(Map<String, dynamic> data) {
    List<Artist> artists = [];
    for(var i= 0; i < data['artists']?.length; i++){
      artists.add(Artist.fromJson(data['artists']?[i]));
    }
    List<Track> tracks = [];
    num length = data['tracks']?['items']?.length ?? 0;
    for(var i= 0; i < length; i++){
      tracks.add(Track.fromJson(data['tracks']?['items']?[i]));
    }
    return Album(
        name: data['name'].toString() ?? "",
        id: data['id'].toString() ?? "",
        artists: artists,
        img: data['images']?[0]?['url'].toString() ?? "",
        tracks: tracks);
  }
}