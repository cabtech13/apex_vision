import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/vod_content.dart';
import '../../data/models/tmdb_metadata.dart';
import '../viewmodels/home_viewmodel.dart';
import 'player_screen.dart';
import '../../data/models/channel.dart';

class VODDetailScreen extends StatefulWidget {
  final VODContent movie;

  const VODDetailScreen({super.key, required this.movie});

  @override
  State<VODDetailScreen> createState() => _VODDetailScreenState();
}

class _VODDetailScreenState extends State<VODDetailScreen> {
  TMDBMetadata? _metadata;
  List<TMDBMetadata> _similar = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMetadata();
  }

  Future<void> _fetchMetadata() async {
    final homeVM = Provider.of<HomeViewModel>(context, listen: false);

    // Rechercher les infos TMDB
    final meta = await homeVM.getVODMetadata(
      widget.movie.title,
      isMovie: widget.movie.type == VODType.movie,
    );

    if (mounted && meta != null) {
      setState(() {
        _metadata = meta;
      });

      // Rechercher les contenus similaires
      final similar = await homeVM.getSimilar(
        meta.id,
        isMovie: widget.movie.type == VODType.movie,
      );

      if (mounted) {
        setState(() {
          _similar = similar;
          _isLoading = false;
        });
      }
    } else if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(color: AppColors.accentBlue),
              )
              : Stack(
                children: [
                  // Background Backdrop
                  if (_metadata?.backdropPath != null)
                    Positioned.fill(
                      child: CachedNetworkImage(
                        imageUrl: _metadata!.fullBackdropUrl,
                        fit: BoxFit.cover,
                        color: Colors.black.withOpacity(0.6),
                        colorBlendMode: BlendMode.darken,
                      ),
                    ),

                  // Gradient for readability
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            AppColors.backgroundDark,
                            AppColors.backgroundDark.withOpacity(0.8),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Content
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 32,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left: Poster & Action
                        SizedBox(
                          width: 250,
                          child: Column(
                            children: [
                              Hero(
                                tag: widget.movie.id,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        _metadata?.fullPosterUrl ??
                                        widget.movie.posterUrl ??
                                        '',
                                    width: 250,
                                    height: 375,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              _buildMainButton(
                                label: 'REGARDER MAINTENANT',
                                icon: Icons.play_arrow,
                                onPressed: _playMovie,
                                isPrimary: true,
                              ),
                              const SizedBox(height: 12),
                              _buildMainButton(
                                label: 'AJOUTER AUX FAVORIS',
                                icon: Icons.favorite_border,
                                onPressed: () {},
                                isPrimary: false,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 48),

                        // Right: Text info
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.movie.title,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.displayLarge?.copyWith(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    if (_metadata?.voteAverage != null) ...[
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 24,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        _metadata!.voteAverage.toStringAsFixed(
                                          1,
                                        ),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 24),
                                    ],
                                    if (_metadata?.releaseDate != null)
                                      Text(
                                        _metadata!.releaseDate!.substring(0, 4),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'SYNOPSIS',
                                  style: TextStyle(
                                    color: AppColors.accentBlue,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _metadata?.overview ??
                                      widget.movie.overview ??
                                      'Aucun synopsis disponible.',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    height: 1.6,
                                    color: AppColors.textSecondary,
                                  ),
                                ),

                                if (_similar.isNotEmpty) ...[
                                  const SizedBox(height: 48),
                                  const Text(
                                    'VOUS POURRIEZ AUSSI AIMER',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    height: 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: _similar.length,
                                      itemBuilder: (context, index) {
                                        final s = _similar[index];
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            right: 16,
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl: s.fullPosterUrl,
                                              width: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Back button
                  Positioned(
                    top: 32,
                    left: 32,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 32,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildMainButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return Focus(
      child: Builder(
        builder: (context) {
          final hasFocus = Focus.of(context).hasFocus;
          return GestureDetector(
            onTap: onPressed,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color:
                    isPrimary
                        ? (hasFocus ? Colors.white : AppColors.accentBlue)
                        : (hasFocus ? Colors.white24 : Colors.transparent),
                borderRadius: BorderRadius.circular(8),
                border: isPrimary ? null : Border.all(color: Colors.white24),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color:
                        isPrimary
                            ? (hasFocus ? Colors.black : Colors.white)
                            : Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          isPrimary
                              ? (hasFocus ? Colors.black : Colors.white)
                              : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _playMovie() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => PlayerScreen(
              channel: Channel(
                id: widget.movie.id,
                name: widget.movie.title,
                streamUrl: widget.movie.streamUrl,
                category: 'VOD',
              ),
            ),
      ),
    );
  }
}
