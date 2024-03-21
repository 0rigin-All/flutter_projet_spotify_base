import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerWidget extends StatefulWidget {
  const AudioPlayerWidget({Key? key}) : super(key: key);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 100, // Décalage vers le bas depuis le haut de l'écran
      right: 0, // Aligné sur le côté droit de l'écran
      child: Container(
        width: 100, // Largeur de la pop-up
        height: 200, // Hauteur de la pop-up
        decoration: BoxDecoration(
          color: const Color(0xFF1DB954), // Couleur verte de Spotify
          borderRadius: BorderRadius.circular(10), // Coins arrondis
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                _audioPlayer.playing ? Icons.pause : Icons.play_arrow,
                color: Colors.white, // Couleur blanche pour les icônes
              ),
              onPressed: () {
                if (_audioPlayer.playing) {
                  _audioPlayer.pause();
                } else {
                  _audioPlayer.play();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}