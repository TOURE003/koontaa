import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:koontaa/functions/fonctions.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  final String url;
  final double hauteur;
  final double largeur;
  final bool control;
  final double ratioHauteur;
  final double ratioLargeur;

  const VideoWidget({
    super.key,
    required this.url,
    this.hauteur = 0,
    this.largeur = 0,
    this.control = false,
    this.ratioHauteur = 0,
    this.ratioLargeur = 0,
  });

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  double ratio = 1;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    await _videoController.initialize();
    _videoController.setVolume(0.0);

    if (widget.ratioHauteur != 0) {
      ratio = _videoController.value.size.height / widget.ratioHauteur;
    } else if (widget.ratioLargeur != 0) {
      ratio = _videoController.value.size.width / widget.ratioLargeur;
    }

    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      autoPlay: true,
      looping: true,
      allowFullScreen: true,
      showControls: widget.control,
    );

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_chewieController == null || !_videoController.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Center(
        child: SizedBox(
          width: widget.largeur == 0
              ? _videoController.value.size.width / ratio
              : widget.largeur,
          height: widget.hauteur == 0
              ? _videoController.value.size.height / ratio
              : widget.hauteur,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _videoController.value.size.width,
                height: _videoController.value.size.height,
                child: Chewie(controller: _chewieController!),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget gifDepuisVideo(
  BuildContext context,
  String lienVideo, {
  double? largeur,
  double? hauteur,
  BoxFit fit = BoxFit.cover,
  double borderRadius = 8,
}) {
  final uri = Uri.parse(lienVideo);
  final segments = uri.pathSegments;

  int uploadIndex = segments.indexOf('upload');
  if (uploadIndex == -1 || uploadIndex >= segments.length - 1) {
    return const Text('URL invalide');
  }

  // Ajout de fl_animated pour boucle infinie
  final gifSegments = [
    ...segments.sublist(0, uploadIndex + 1),
    'f_gif,du_5,so_0,fl_animated',
    ...segments.sublist(uploadIndex + 1),
  ];

  String gifUrl = '${uri.scheme}://${uri.host}/${gifSegments.join('/')}';
  gifUrl = gifUrl.replaceAll("mp4", "gif");
  print("URL GIF animé : $gifUrl");

  return ClipRRect(
    borderRadius: BorderRadius.circular(borderRadius),
    child: imageNetwork(context, gifUrl),
  );
}
