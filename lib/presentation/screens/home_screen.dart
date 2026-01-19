import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../widgets/sidebar.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/channel.dart';
import '../widgets/channel_card.dart';
import '../viewmodels/home_viewmodel.dart';
import '../viewmodels/playlist_viewmodel.dart';
import 'player_screen.dart';
import 'settings_screen.dart';

/// Écran d'accueil principal avec sidebar et carrousels
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedMenuIndex = 1; // Par défaut sur "Direct"

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);
    final playlistViewModel = Provider.of<PlaylistViewModel>(context);

    return Scaffold(
      body: Row(
        children: [
          // Sidebar Navigation
          Sidebar(
            selectedIndex: _selectedMenuIndex,
            onMenuItemSelected: (index) {
              setState(() {
                _selectedMenuIndex = index;
              });
            },
          ),

          // Main Content
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.backgroundDark, AppColors.overlayDark],
                ),
              ),
              child:
                  homeViewModel.isLoading
                      ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.accentBlue,
                        ),
                      )
                      : _buildContent(homeViewModel, playlistViewModel),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    HomeViewModel homeViewModel,
    PlaylistViewModel playlistViewModel,
  ) {
    // Afficher un contenu différent selon le menu sélectionné
    switch (_selectedMenuIndex) {
      case 0:
        return _buildSearchScreen();
      case 1:
        return _buildLiveScreen(homeViewModel);
      case 2:
        return _buildMoviesScreen();
      case 3:
        return _buildSeriesScreen();
      case 4:
        return _buildFavoritesScreen(homeViewModel);
      case 5:
        return _buildSettingsScreen();
      default:
        return _buildLiveScreen(homeViewModel);
    }
  }

  Widget _buildLiveScreen(HomeViewModel homeViewModel) {
    final categories = homeViewModel.categoriesWithChannels;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildSectionHeader(
            title: 'Direct TV',
            subtitle:
                '${homeViewModel.popularChannels.length} chaînes populaires',
          ),

          const SizedBox(height: 24),

          // Carrousel "Chaînes populaires"
          if (homeViewModel.popularChannels.isNotEmpty)
            _buildCarousel(
              title: AppStrings.homePopularChannels,
              channels: homeViewModel.popularChannels,
            ),

          const SizedBox(height: 32),

          // Dynamically generate carousels for each category
          ...categories.entries.map((entry) {
            return Column(
              children: [
                _buildCarousel(title: entry.key, channels: entry.value),
                const SizedBox(height: 32),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSearchScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search, size: 64, color: AppColors.textTertiary),
          const SizedBox(height: 16),
          Text(
            'Recherche',
            style: Theme.of(
              context,
            ).textTheme.displayMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'Fonction à venir...',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildMoviesScreen() {
    return _buildComingSoon('Films', Icons.movie);
  }

  Widget _buildSeriesScreen() {
    return _buildComingSoon('Séries', Icons.tv);
  }

  Widget _buildComingSoon(String title, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppColors.textTertiary),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.displayMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'Fonction à venir...',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesScreen(HomeViewModel homeViewModel) {
    // Note: favoritism logic needs to be added to ViewModel if not persistent in DB
    final favorites =
        homeViewModel.popularChannels.where((c) => c.isFavorite).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            title: AppStrings.navFavorites,
            subtitle: '${favorites.length} favoris',
          ),
          const SizedBox(height: 24),
          _buildCarousel(title: 'Mes Favoris', channels: favorites),
        ],
      ),
    );
  }

  Widget _buildSettingsScreen() {
    return const SettingsScreen();
  }

  Widget _buildSectionHeader({required String title, String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.displayMedium?.copyWith(fontSize: 32),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textTertiary),
          ),
        ],
      ],
    );
  }

  Widget _buildCarousel({
    required String title,
    required List<Channel> channels,
  }) {
    if (channels.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontSize: 22),
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: channels.length,
            itemBuilder: (context, index) {
              final channel = channels[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Focus(
                  onKeyEvent: (node, event) {
                    if (event is KeyDownEvent) {
                      final isSelect =
                          event.logicalKey == LogicalKeyboardKey.select ||
                          event.logicalKey == LogicalKeyboardKey.enter ||
                          event.logicalKey == LogicalKeyboardKey.numpadEnter;
                      if (isSelect) {
                        _playChannel(channel);
                        return KeyEventResult.handled;
                      }
                    }
                    return KeyEventResult.ignored;
                  },
                  child: Builder(
                    builder: (context) {
                      final hasFocus = Focus.of(context).hasFocus;
                      return ChannelCard(
                        channel: channel,
                        hasFocus: hasFocus,
                        onTap: () {
                          _playChannel(channel);
                        },
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _playChannel(Channel channel) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlayerScreen(channel: channel)),
    );
  }
}
