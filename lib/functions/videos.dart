//https://res.cloudinary.com/ddjkeamgh/video/upload/v1751469170/WhatsApp_Vid%C3%A9o_2025-07-02_%C3%A0_15.10.20_576c8628_uoaxqn.mp4

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

Future<Widget> videoDepuisUrl(
  String url, {
  double hauteur = 0,
  double largeur = 0,
  bool control = false,
  double ratioHauteur = 0,
  double ratioLargeur = 0,
}) async {
  double ratio = 1;

  final videoPlayerController = VideoPlayerController.networkUrl(
    Uri.parse(url),
  );

  await videoPlayerController.initialize();
  videoPlayerController.setVolume(0.0);

  if (ratioHauteur != 0) {
    ratio = videoPlayerController.value.size.height / ratioHauteur;
  } else if (ratioLargeur != 0) {
    ratio = videoPlayerController.value.size.width / ratioLargeur;
  }

  final chewieController = ChewieController(
    videoPlayerController: videoPlayerController,
    autoPlay: true,
    looping: true,
    allowFullScreen: true,
    showControls: control,
  );

  final playerWidget = Chewie(controller: chewieController);

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Center(
      child: SizedBox(
        width: largeur == 0
            ? videoPlayerController.value.size.width / ratio
            : largeur, //300, // largeur fixe
        height: hauteur == 0
            ? videoPlayerController.value.size.height / ratio
            : hauteur, //400, // hauteur fixe
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: FittedBox(
            fit: BoxFit.cover, // IMPORTANT : remplissage + rognage
            child: SizedBox(
              width: videoPlayerController.value.size.width,
              height: videoPlayerController.value.size.height,
              child: playerWidget,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget video(
  BuildContext context,
  String url, {
  double hauteur = 0,
  double largeur = 0,
  bool control = false,
  double ratioHauteur = 0,
  double ratioLargeur = 0,
}) {
  return FutureBuilder(
    future: videoDepuisUrl(
      url,
      hauteur: hauteur,
      largeur: largeur,
      control: control,
      ratioHauteur: ratioHauteur,
      ratioLargeur: ratioLargeur,
    ),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text("Erreur : ${snapshot.error}"));
      }
      if (snapshot.data == null) {
        return Center(child: Text("Erreur : ${snapshot.error}"));
      }
      return snapshot.data!;
    },
  );
}
