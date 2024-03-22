import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'Track.dart';

class Playlist {
  int id;
  String name;
  List<Track> tracks;

  Playlist({required this.id, required this.name, required this.tracks});

  factory Playlist.fromMap(Map<String, dynamic> map) {
    List<Track> tracks = [];
    if (map.containsKey('tracks') && map['tracks'] != null) {
      tracks = (map['tracks'] as List<dynamic>).map((trackMap) {
        return Track.fromMap(trackMap);
      }).toList();
    }

    return Playlist(
      id: map['id'],
      name: map['name'],
      tracks: tracks,
    );
  }

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> tracksMapList =
        tracks.map((track) => track.toMap()).toList();

    return {
      'id': id,
      'name': name,
      'tracks': tracksMapList.isEmpty ? null : tracksMapList,
    };
  }

  void addTrack(Track track) {
    tracks.add(track);
  }

  void removeTrack(Track track) {
    tracks.remove(track);
  }
}

class PlaylistProviderSqlite {
  static const _databaseName = "Playlist.db";
  late Database db;

  Future open() async {
    final documentsDirectory = await getDatabasesPath();
    final path = join(documentsDirectory, _databaseName);
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE playlists (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL
          )
          ''');

        await db.execute('''
          CREATE TABLE tracks (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            artist TEXT NOT NULL
          )
          ''');

        await db.execute('''
          CREATE TABLE playlist_tracks (
            id INTEGER PRIMARY KEY,
            playlist_id INTEGER,
            track_id INTEGER,
            FOREIGN KEY (playlist_id) REFERENCES playlists(id),
            FOREIGN KEY (track_id) REFERENCES tracks(id)
          )
          ''');

        await db.execute(
            "INSERT INTO playlists(name) VALUES('Rock')");
        await db.execute(
            "INSERT INTO playlists(name) VALUES('Pop')");
      },
    );
  }

  Future<List<Playlist>> getPlaylists() async {
    final List<Map<String, dynamic>> maps = await db.query('playlists');
    return List.generate(maps.length, (i) {
      return Playlist.fromMap(maps[i]);
    });
  }

  Future<Playlist?> getPlaylist(int id) async {
    final List<Map<String, dynamic>> maps =
        await db.query('playlists', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Playlist.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> insertPlaylist(Playlist playlist) async {
    Map<String, dynamic> playlistMap = playlist.toMap();
    playlistMap.remove('id'); // Supprimer l'ID car il est auto-incrémenté dans la base de données
    int playlistId = await db.insert('playlists', playlistMap);

    for (Track track in playlist.tracks) {
      int trackId = await db.insert('tracks', track.toMap());
      await db.insert('playlist_tracks', {
        'playlist_id': playlistId,
        'track_id': trackId,
      });
    }

    return playlistId;
  }

  Future<int> deletePlaylist(int id) async {
    await db.delete('playlist_tracks', where: 'playlist_id = ?', whereArgs: [id]);
    return await db.delete('playlists', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updatePlaylist(Playlist playlist) async {
    await db.delete('playlist_tracks', where: 'playlist_id = ?', whereArgs: [playlist.id]);

    for (Track track in playlist.tracks) {
      int trackId = await db.insert('tracks', track.toMap());
      await db.insert('playlist_tracks', {
        'playlist_id': playlist.id,
        'track_id': trackId,
      });
    }

    return await db.update('playlists', playlist.toMap(),
        where: 'id = ?', whereArgs: [playlist.id]);
  }
}