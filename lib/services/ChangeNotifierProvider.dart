import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:projet_spotify_gorouter/model/Track.dart';

class PlaylistProvider extends ChangeNotifier {
  final ConcatenatingAudioSource playlist = ConcatenatingAudioSource(
    useLazyPreparation: true,
    shuffleOrder: DefaultShuffleOrder(),
    children: []
  );}

class PlaylistProviderT extends ChangeNotifier {
  List<Track> playlist = [];

  void addTrack(Track track) {
    playlist.add(track);
    notifyListeners();
  }

  void clearPlaylist() {
    playlist.clear();
    notifyListeners();
  }

  void insertTrack(int index, Track track) {
    playlist.insert(index, track);
    notifyListeners();
  }
}