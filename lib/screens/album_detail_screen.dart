import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AlbumDetailScreen extends StatefulWidget {
  final String albumId;

  /// Constructs a [AlbumDetailScreen]
  const AlbumDetailScreen({Key? key, required this.albumId}) : super(key: key);

  @override
  State<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

/// The details screen
class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  
  // -- détails d'un album
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Album Details Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Album ID: ${widget.albumId}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () => context.go('/a'),
              child: const Text('Go back'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/a/artistedetails'),
              child: const Text('Go Artiste Detail'),
            ),
          ],
        ),
      ),
    );
  }
}
