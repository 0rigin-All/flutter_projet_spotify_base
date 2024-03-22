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
  late PlaylistProviderT _playlistProviderT;
  late AudioPlayer audioPlayer;
  IconData iconData = Icons.play_arrow; // Icône par défaut
  bool showPlaylist = false; // État pour afficher ou masquer la playlist
  bool showSetting = false;
  bool doubleSpeed = false;

  @override
  void initState() {
    super.initState();
    _playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
    _playlistProviderT = Provider.of<PlaylistProviderT>(context, listen: false);
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
          top: 5, // Décalage vers le bas depuis le haut de l'écran
          right: 5, // Aligné sur le côté droit de l'écran
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
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
                        Icons.settings,
                        color: Color(0xFF1DB954),
                      ),
                      onPressed: () {
                        setState(() {
                          showSetting =
                              !showSetting; // Inverser l'état pour afficher ou masquer la playlist
                        });
                        // Jouer la musique précédente en utilisant la méthode `audioPlayer.setAudioSource()`
                      },
                    ),
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
                        audioPlayer.seekToNext(); // Passer à la piste suivante
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.music_note,
                        color: Color(0xFF1DB954),
                      ),
                      onPressed: () {
                        setState(() {
                          showPlaylist =
                              !showPlaylist; // Inverser l'état pour afficher ou masquer la playlist
                        }); // Passer à la piste suivante
                      },
                    ),
                  ],
                ),
              ),
              if (showPlaylist) ...[
                SizedBox(
                  width: 500, // Définit la largeur sur la largeur de l'écran
                  height: 500, // Définit la hauteur sur la hauteur de l'écran
                  child: Stack(
                    children: [
                      Positioned(
                        top: 5,
                        right: 5,
                        child: SizedBox(
                          width: 300, // Largeur réduite de la fenêtre
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            color: Colors.grey[200],
                            child: SingleChildScrollView(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    for (var index = 0;
                                        index <
                                            _playlistProviderT.playlist.length;
                                        index++)
                                      Card(
                                        color: index == audioPlayer.currentIndex
                                            ? Colors.blue[100]
                                            : null,
                                        child: ListTile(
                                          onTap: () {
                                            audioPlayer.seek(Duration.zero,
                                                index: index);
                                          },
                                          title: Text(_playlistProviderT
                                              .playlist[index].name),
                                          subtitle: Text(_playlistProviderT
                                              .playlist[index].artists
                                              .map((artist) => artist.name)
                                              .join(', ')),
                                          trailing:
                                              index == audioPlayer.currentIndex
                                                  ? Container(
                                                      width:
                                                          31, // Largeur fixe pour le trailing
                                                      height:
                                                          31, // Hauteur fixe pour le trailing
                                                      child: Image.network(
                                                        'https://cdn.discordapp.com/attachments/889445384659800095/1220401255235457044/png-transparent-computer-icons-wave-sound-sound-wave-angle-text-logo-removebg-preview.png?ex=660ece3d&is=65fc593d&hm=e66c61434952d9ea3406e1898e11c2dd3ab498ede7de0bc737b4492e8a6f5fe7&',
                                                        fit: BoxFit
                                                            .cover, // Ajuster l'image pour couvrir tout le conteneur
                                                      ),
                                                    )
                                                  : null,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (showSetting) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "Réglages",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Lecture rapide x2",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: Switch(
                        value: doubleSpeed,
                        onChanged: (value) {
                          if (doubleSpeed!) {
                            audioPlayer.setSpeed(2.0);
                          } else {
                            audioPlayer.setSpeed(1.0);
                          }
                          setState(() {
                            doubleSpeed = value;
                          });
                        },
                        activeColor: Colors.green,
                        inactiveTrackColor: Colors.black,
                        inactiveThumbColor: Colors.black,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () {
                    audioPlayer.setShuffleModeEnabled(true);
                  },
                  icon: const Icon(
                    Icons.shuffle,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Mélanger la playlist",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
