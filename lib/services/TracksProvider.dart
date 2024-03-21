import 'package:http/http.dart' as http;
import 'package:projet_spotify_gorouter/model/Track.dart';
import 'dart:convert';

import 'package:projet_spotify_gorouter/services/AlbumProvider.dart';

Future<List<Track>> fetchSearchTracks(String query) async {
  final queryParameters = {
  'type': 'track',
  'market': 'FR',
  'q' : query
};
  List<Track> list = [];
  var url = Uri.https(urlApiSpotifyDomain, urlApiSearch, queryParameters );

  var response = await http.get(
    url,
    headers: {'Authorization': 'Bearer $token'}
  );

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    data['tracks']['items'].forEach((track) => list.add(Track.fromJson(track)));
    return list;
  } else {
    return [];
  }
}