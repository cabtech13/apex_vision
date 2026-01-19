import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:iptv_magik_app/core/constants/app_colors.dart';
import 'package:iptv_magik_app/presentation/viewmodels/playlist_viewmodel.dart';
import 'package:iptv_magik_app/presentation/viewmodels/home_viewmodel.dart';
import 'package:iptv_magik_app/presentation/widgets/focus_border.dart';
import 'package:google_fonts/google_fonts.dart';

class PlaylistManagerScreen extends StatefulWidget {
  const PlaylistManagerScreen({super.key});

  @override
  State<PlaylistManagerScreen> createState() => _PlaylistManagerScreenState();
}

class _PlaylistManagerScreenState extends State<PlaylistManagerScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PlaylistViewModel>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text(
          'Gérer les Playlists',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.backgroundDark, AppColors.surfaceDark],
          ),
        ),
        padding: const EdgeInsets.all(32),
        child: Row(
          children: [
            // List of Playlists
            Expanded(
              flex: 2,
              child:
                  viewModel.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                        itemCount: viewModel.playlists.length + 1,
                        itemBuilder: (context, index) {
                          if (index == viewModel.playlists.length) {
                            // Add Button
                            return _buildAddButton(context);
                          }
                          return _buildPlaylistCard(
                            context,
                            viewModel.playlists[index],
                            viewModel,
                          );
                        },
                      ),
            ),

            // Details / Options Panel
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.only(left: 32),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.cardDark.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.playlist_play,
                      size: 64,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Sélectionnez une playlist pour l'activer",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaylistCard(
    BuildContext context,
    dynamic playlist,
    PlaylistViewModel viewModel,
  ) {
    bool isActive = playlist.isActive;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Focus(
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent) {
            final isSelect =
                event.logicalKey == LogicalKeyboardKey.select ||
                event.logicalKey == LogicalKeyboardKey.enter ||
                event.logicalKey == LogicalKeyboardKey.numpadEnter;
            if (isSelect) {
              viewModel.setActivePlaylist(playlist.id);
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        child: Builder(
          builder: (context) {
            final hasFocus = Focus.of(context).hasFocus;
            return FocusBorder(
              hasFocus: hasFocus,
              child: InkWell(
                onTap: () async {
                  await viewModel.setActivePlaylist(playlist.id);
                  if (mounted) {
                    Provider.of<HomeViewModel>(
                      context,
                      listen: false,
                    ).loadHomeContent();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color:
                        isActive
                            ? AppColors.accentBlue.withOpacity(0.1)
                            : AppColors.cardDark,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          isActive ? AppColors.accentBlue : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        playlist.isXtream ? Icons.cloud_circle : Icons.list_alt,
                        color:
                            isActive
                                ? AppColors.accentBlue
                                : AppColors.textSecondary,
                        size: 32,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              playlist.name,
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              playlist.type.toUpperCase(),
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isActive)
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.accentGreen,
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Focus(
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent) {
            final isSelect =
                event.logicalKey == LogicalKeyboardKey.select ||
                event.logicalKey == LogicalKeyboardKey.enter ||
                event.logicalKey == LogicalKeyboardKey.numpadEnter;
            if (isSelect) {
              _showAddPlaylistDialog(context);
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        child: Builder(
          builder: (context) {
            final hasFocus = Focus.of(context).hasFocus;
            return FocusBorder(
              hasFocus: hasFocus,
              child: InkWell(
                onTap: () {
                  _showAddPlaylistDialog(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.glassLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.glassBorder,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add, color: AppColors.textPrimary),
                      const SizedBox(width: 8),
                      Text(
                        "Ajouter une playlist",
                        style: GoogleFonts.inter(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showAddPlaylistDialog(BuildContext context) {
    final nameController = TextEditingController();
    final urlController = TextEditingController();
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    String selectedType = 'm3u';

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                backgroundColor: AppColors.surfaceDark,
                title: Text(
                  "Nouvelle Playlist",
                  style: GoogleFonts.inter(color: AppColors.textPrimary),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButton<String>(
                        value: selectedType,
                        dropdownColor: AppColors.cardDark,
                        style: GoogleFonts.inter(color: AppColors.textPrimary),
                        underline: Container(
                          height: 1,
                          color: AppColors.glassBorder,
                        ),
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(
                            value: 'm3u',
                            child: Text("Playlist M3U / M3U8"),
                          ),
                          DropdownMenuItem(
                            value: 'xtream',
                            child: Text("Xtream Codes API"),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedType = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: "Nom de la playlist",
                          labelStyle: TextStyle(color: AppColors.textSecondary),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.glassBorder,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (selectedType == 'm3u')
                        TextField(
                          controller: urlController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: "URL de la playlist (http://...)",
                            labelStyle: TextStyle(
                              color: AppColors.textSecondary,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.glassBorder,
                              ),
                            ),
                          ),
                        )
                      else ...[
                        TextField(
                          controller: urlController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: "URL Serveur (http://domain.com:port)",
                            labelStyle: TextStyle(
                              color: AppColors.textSecondary,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.glassBorder,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: usernameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: "Nom d'utilisateur",
                            labelStyle: TextStyle(
                              color: AppColors.textSecondary,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.glassBorder,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: "Mot de passe",
                            labelStyle: TextStyle(
                              color: AppColors.textSecondary,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.glassBorder,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Annuler"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentBlue,
                    ),
                    onPressed: () async {
                      if (nameController.text.isNotEmpty &&
                          urlController.text.isNotEmpty) {
                        await Provider.of<PlaylistViewModel>(
                          context,
                          listen: false,
                        ).addPlaylist(
                          nameController.text,
                          urlController.text,
                          type: selectedType,
                          username:
                              selectedType == 'xtream'
                                  ? usernameController.text
                                  : null,
                          password:
                              selectedType == 'xtream'
                                  ? passwordController.text
                                  : null,
                        );

                        // Reload Home Page content if this is the active playlist
                        if (mounted) {
                          Provider.of<HomeViewModel>(
                            context,
                            listen: false,
                          ).loadHomeContent();
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: const Text("Ajouter"),
                  ),
                ],
              );
            },
          ),
    );
  }
}
