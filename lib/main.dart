import 'package:flutter/material.dart';
import 'package:projet_spotify_gorouter/router/router_config.dart';
import 'package:projet_spotify_gorouter/components/audio_player_widget.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
      ),
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            AudioPlayerWidget(), // Ajout du lecteur audio au-dessus de toutes les pages
          ],
        );
      },
    );
  }
}
