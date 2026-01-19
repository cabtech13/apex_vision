import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:iptv_magik_app/core/constants/app_colors.dart';
import 'package:iptv_magik_app/presentation/widgets/focus_border.dart';
import 'package:iptv_magik_app/presentation/screens/playlist_manager_screen.dart';
import 'package:iptv_magik_app/presentation/screens/pairing_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Paramètres",
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView(
              children: [
                _buildSettingsTile(
                  context,
                  icon: Icons.playlist_play,
                  title: "Gérer les Playlists",
                  subtitle: "Ajouter ou modifier vos sources IPTV",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PlaylistManagerScreen(),
                      ),
                    );
                  },
                ),
                _buildSettingsTile(
                  context,
                  icon: Icons.phonelink_setup,
                  title: "Appairer un appareil",
                  subtitle: "Connecter via Code ou QR",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PairingScreen(),
                      ),
                    );
                  },
                ),
                _buildSettingsTile(
                  context,
                  icon: Icons.lock_outline,
                  title: "Mode Verrouillage",
                  subtitle: "Restreindre l'accès à une seule chaîne",
                  onTap: () {
                    // TODO: Implement Lock Mode
                  },
                ),
                _buildSettingsTile(
                  context,
                  icon: Icons.info_outline,
                  title: "À propos d'Apex Vision",
                  subtitle: "Version 1.0.0",
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: "Apex Vision",
                      applicationVersion: "1.0.0",
                      children: const [Text("Développé pour Android TV")],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
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
              onTap();
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
              child: Material(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceDark,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(icon, color: AppColors.accentBlue),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                subtitle,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
