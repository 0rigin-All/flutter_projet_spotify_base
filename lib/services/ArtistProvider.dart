import 'package:http/http.dart' as http;
import 'package:projet_spotify_gorouter/model/Artist.dart';
import 'package:projet_spotify_gorouter/model/Track.dart';
import 'dart:convert';

import 'package:projet_spotify_gorouter/services/AlbumProvider.dart';

const urlApiGetArtist = 'v1/artists';


Future<Artist?> fetchArtist(String artistId) async {
  var url = Uri.https(urlApiSpotifyDomain, '$urlApiGetArtist/$artistId');
  
  var response = await http.get(
    url,
    headers: {'Authorization': 'Bearer $token'},
  );
   var url2 = Uri.https(urlApiSpotifyDomain, '$urlApiGetArtist/$artistId/top-tracks');
  
  var responsetopTracks = await http.get(
    url2,
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200 && responsetopTracks.statusCode == 200) {
    Map<String, dynamic> dataTopTracks = jsonDecode(responsetopTracks.body);
    Map<String, dynamic> data = jsonDecode(response.body);
    data.addAll(dataTopTracks);
    Artist artist = Artist.fromJson(data);
    return artist;
  } else {
    return null;
  }
}