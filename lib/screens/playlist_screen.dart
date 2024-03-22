import 'package:flutter/material.dart';
import '../model/PlaylistProviderSqlite.dart'; // Importez le fichier contenant la classe PlaylistProvider

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  late PlaylistProviderSqlite playlistProvider; // Instance de PlaylistProvider
  List<Playlist>? playlists; // Liste des playlists, peut être null au début

  @override
  void initState() {
    super.initState();
     get();
  }

void get() async {
    playlistProvider = PlaylistProviderSqlite(); // Initialisez PlaylistProvider
    await playlistProvider.open();
    fetchPlaylists();
}
  // Fonction pour charger les playlists
  void fetchPlaylists() async {
    List<Playlist> fetchedPlaylists = await playlistProvider.getPlaylists();
    setState(() {
      playlists = fetchedPlaylists;
    });
  }

  // Fonction pour supprimer une playlist
  void deletePlaylist(int id) async {
    await playlistProvider.deletePlaylist(id);
    fetchPlaylists(); // Rechargez les playlists après la suppression
  }

  // Fonction pour afficher un dialogue de confirmation avant de supprimer une playlist
  Future<void> showDeleteConfirmationDialog(int id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Voulez-vous vraiment supprimer cette playlist ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Supprimer'),
              onPressed: () {
                deletePlaylist(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (playlists == null) {
      return const Center(
        child: CircularProgressIndicator(), // Affiche un indicateur de chargement si playlists est null
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Playlists'),
        ),
        body: ListView.builder(
          itemCount: playlists!.length,
          itemBuilder: (context, index) {
            Playlist playlist = playlists![index];
            return ListTile(
              title: Text(playlist.name),
              onTap: () {
                // Logique pour lancer la playlist
              },
              trailing: PopupMenuButton<String>(
                onSelected: (String choice) {
                  if (choice == 'Supprimer') {
                    showDeleteConfirmationDialog(playlist.id);
                  } else if (choice == 'Modifier') {
                    // Logique pour modifier la playlist
                  }
                },
                itemBuilder: (BuildContext context) {
                  return ['Supprimer', 'Modifier'].map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
  onPressed: () async {
    String? playlistName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController playlistNameController = TextEditingController();
        return AlertDialog(
          title: const Text('Créer une nouvelle playlist'),
          content: TextField(
            controller: playlistNameController,
            decoration: const InputDecoration(hintText: 'Nom de la playlist'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Créer'),
              onPressed: () {
                String name = playlistNameController.text.trim();
                if (name.isNotEmpty) {
                  Navigator.of(context).pop(name);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Veuillez saisir un nom pour la playlist')),
                  );
                }
              },
            ),
          ],
        );
      },
    );

    if (playlistName != null) {
      Playlist newPlaylist = Playlist(id: 0, name: playlistName, tracks: []);
      await playlistProvider.insertPlaylist(newPlaylist);
      fetchPlaylists(); // Rechargez la liste des playlists après l'insertion
    }
  },
  child: const Icon(Icons.add),
),
      );
    }
  }
}