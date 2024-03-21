import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:projet_spotify_gorouter/model/Track.dart';

class PlaylistProvider extends ChangeNotifier {
  final ConcatenatingAudioSource playlist = ConcatenatingAudioSource(
    useLazyPreparation: true,
    shuffleOrder: DefaultShuffleOrder(),
    children: []
  );

  void addToPlaylist(Track track) {
    playlist.add(AudioSource.uri(Uri.parse(track.audioUrl)));
    notifyListeners();
  }

  void clearPlaylist() {
    playlist.clear();
    notifyListeners();
  }
}