import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/channel.dart';

/// Lecteur vidéo utilisant VideoPlayer (Base ExoPlayer sur Android) avec Chewie UI
class PlayerScreen extends StatefulWidget {
  final Channel channel;

  const PlayerScreen({super.key, required this.channel});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.channel.streamUrl),
      );

      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: true,
        isLive: true, // Optimisé pour le direct
        aspectRatio: 16 / 9,
        // UI Customization
        materialProgressColors: ChewieProgressColors(
          playedColor: AppColors.accentBlue,
          handleColor: AppColors.accentBlue,
          backgroundColor: Colors.white24,
          bufferedColor: Colors.white24,
        ),
        placeholder: const Center(
          child: CircularProgressIndicator(color: AppColors.accentBlue),
        ),
        autoInitialize: true,
        allowMuting: true,
        allowPlaybackSpeedChanging: false,
        showControlsOnInitialize: true,
        additionalOptions: (context) {
          return <OptionItem>[
            OptionItem(
              onTap: (context) => debugPrint('Options Audio/Subs'),
              iconData: Icons.settings,
              title: 'Audio & Sous-titres',
            ),
          ];
        },
      );

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint("Error initializing player: $e");
      if (mounted) {
        setState(() {
          _isError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isError) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: AppColors.error, size: 64),
              const SizedBox(height: 16),
              Text(
                "Erreur de lecture du flux",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isError = false;
                  });
                  _initializePlayer();
                },
                child: const Text("Réessayer"),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black, // Cinéma mode
      body: SafeArea(
        child:
            _chewieController != null &&
                    _chewieController!.videoPlayerController.value.isInitialized
                ? Chewie(controller: _chewieController!)
                : const Center(
                  child: CircularProgressIndicator(color: AppColors.accentBlue),
                ),
      ),
    );
  }
}
