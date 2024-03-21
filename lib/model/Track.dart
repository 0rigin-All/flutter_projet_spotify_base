import 'Artist.dart';

class Track {
  final String name;
  final String id;
  final List<Artist> artists;
  final String audioUrl;
  Track({required this.id, required this.name, required this.artists, required this.audioUrl });

  factory Track.fromJson(Map<String, dynamic> data) {
     List<Artist> artists = [];
    for(var i= 0; i < data['artists']?.length; i++){
      artists.add(Artist.fromJson(data['artists']?[i]));
    }
    return Track(
        name: data['name'].toString() ?? "",
        id: data['id'].toString() ?? "",
        audioUrl: data["preview_url"] ?? "",
        artists: artists);
  }
}
