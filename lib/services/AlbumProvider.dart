import 'package:projet_spotify_gorouter/model/Album.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';


const urlApiSpotifyDomain = 'api.spotify.com';
const urlApiGetNewRelease = '/v1/browse/new-releases';
const urlApiGetAlbum = '/v1/albums';
const token = "BQDLYyv556kLQsKTGhDMiLptw0Nc8Azkc-cwpJzUf2p5TAXZeW42NzcleN26MC3RzBQ3YEyo0bvoWaynRO_FW--ZC60LA3UOMcalEkFxtG73G6oGkZY";

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
