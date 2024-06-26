import 'package:projet_spotify_gorouter/model/Album.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';


const urlApiSpotifyDomain = 'api.spotify.com';
const urlApiGetNewRelease = '/v1/browse/new-releases';
const urlApiGetAlbum = '/v1/albums';
const urlApiSearch = "/v1/search";
const token = "BQAPYF3M0nvToHZjAIAc4DkixHnGoDJNkMOzSpXl9Nz_zN1YX1HB-k5F2tiKJZxSndEn0N6ZaozVIYCV1ELHDRinG2wtre-eGwiO1wSsccrJ_x42-vY";

Future<Album?> fetchAlbum(String albumId) async {
  var url = Uri.https(urlApiSpotifyDomain, '$urlApiGetAlbum/$albumId');
  
  var response = await http.get(
    url,
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(response.body);
    Album album = Album.fromJson(data);
    return album;
  } else {
    return null;
  }
}

Future<List<Album>> fetchNewAlbums() async {
  List<Album> list = [];
  var url = Uri.https(urlApiSpotifyDomain, urlApiGetNewRelease);

  var response = await http.get(
    url,
    headers: {'Authorization': 'Bearer $token'}
  );

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    data['albums']['items'].forEach((album) => list.add(Album.fromJson(album)));
    return list;
  } else {
    return [];
  }
}
Future<List<Album>> fetchSearchAlbums(String query) async {
  final queryParameters = {
  'type': 'album',
  'market': 'FR',
  'q' : query
};
  List<Album> list = [];
  var url = Uri.https(urlApiSpotifyDomain, urlApiSearch, queryParameters );

  var response = await http.get(
    url,
    headers: {'Authorization': 'Bearer $token'}
  );

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    data['albums']['items'].forEach((album) => list.add(Album.fromJson(album)));
    return list;
  } else {
    return [];
  }
}
