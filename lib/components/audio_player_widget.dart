import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../services/ChangeNotifierProvider.dart';

class AudioPlayerWidget extends StatefulWidget {
  const AudioPlayerWidget({Key? key}) : super(key: key);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late PlaylistProvider _playlistProvider;
  late AudioPlayer audioPlayer;
  IconData iconData = Icons.play_arrow; // Icône par défaut

  @override
  void initState() {
    super.initState();
    _playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
    audioPlayer = Provider.of<AudioPlayer>(context, listen: false);

    // Ajouter un écouteur pour surveiller les changements d'état
    audioPlayer.playerStateStream.listen((state) {
      setState(() {
        // Mettre à jour l'icône en fonction de l'état actuel de l'audioPlayer
        iconData = state.playing ? Icons.pause : Icons.play_arrow;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, playlistProvider, child) {
        final playlist = playlistProvider.playlist;

        // Vérifier si la playlist est vide
        if (playlist.children.isEmpty) {
          return Container(); // Ne rien afficher si la playlist est vide
        }

        return Positioned(
          top: 0, // Décalage vers le bas depuis le haut de l'écran
          right: 0, // Aligné sur le côté droit de l'écran
          child: Container(
            width: 200, // Largeur de la pop-up
            height: 40, // Hauteur de la pop-up
            decoration: BoxDecoration(
              color: Colors.black, // Couleur verte de Spotify
              borderRadius: BorderRadius.circular(10), // Coins arrondis
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
               IconButton(
  icon: const Icon(
    Icons.skip_previous,
    color: Color(0xFF1DB954),
  ),
  onPressed: () {
   audioPlayer.seekToPrevious();
      // Jouer la musique précédente en utilisant la méthode `audioPlayer.setAudioSource()`
    
  },
),
                IconButton(
                  icon: Icon(
                    iconData, // Utilisez l'icône dynamique en fonction de l'état actuel
                    color: const Color(0xFF1DB954),
                  ),
                  onPressed: () {
                    // Logique pour gérer la lecture/pause
                    if (audioPlayer.playing) {
                      audioPlayer.pause();
                    } else {
                      audioPlayer.play();
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.skip_next,
                    color: Color(0xFF1DB954),
                  ),
                  onPressed: () {
                    audioPlayer.seekToNext();  // Passer à la piste suivante
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
