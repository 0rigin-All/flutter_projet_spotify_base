import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:projet_spotify_gorouter/router/router_config.dart';
import 'package:projet_spotify_gorouter/components/audio_player_widget.dart';

import 'services/ChangeNotifierProvider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    final audioPlayer = AudioPlayer(); 

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PlaylistProvider()),
        Provider.value(value: audioPlayer), 
      ],
      child: MaterialApp.router(
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
              AudioPlayerWidget(), 
            ],
          );
        },
      ),
    );
  }
}
