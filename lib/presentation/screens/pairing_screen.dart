import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/services/pairing_service.dart';
import '../viewmodels/playlist_viewmodel.dart';
import '../viewmodels/home_viewmodel.dart';
import 'dart:math';

class PairingScreen extends StatefulWidget {
  const PairingScreen({super.key});

  @override
  State<PairingScreen> createState() => _PairingScreenState();
}

class _PairingScreenState extends State<PairingScreen> {
  String _pairingCode = "LOADING...";
  final PairingService _pairingService = PairingService();
  Timer? _pollingTimer;
  bool _isPaired = false;

  @override
  void initState() {
    super.initState();
    _startPairingProcess();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _startPairingProcess() async {
    _generateCode();
    await _pairingService.registerCode(_pairingCode, "TV-DEVICE-ID");
    _startPolling();
  }

  void _generateCode() {
    final random = Random();
    final code = (100000 + random.nextInt(900000)).toString();
    setState(() {
      _pairingCode = code;
    });
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      final data = await _pairingService.checkPairingStatus(_pairingCode);
      if (data != null && mounted) {
        timer.cancel();
        _handleSuccessfulPairing(data);
      }
    });
  }

  void _handleSuccessfulPairing(Map<String, dynamic> data) {
    setState(() {
      _isPaired = true;
    });

    // Ajouter la playlist via le ViewModel
    final viewModel = Provider.of<PlaylistViewModel>(context, listen: false);

    if (data['type'] == 'm3u') {
      viewModel.addPlaylist(
        data['name'] ?? 'Remote M3U',
        data['url'],
        type: 'm3u',
      );
    } else {
      viewModel.addPlaylist(
        data['name'] ?? 'Remote Xtream',
        data['serverUrl'],
        type: 'xtream',
        username: data['username'],
        password: data['password'],
      );
    }

    // Afficher un message de succès et retourner
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Association réussie ! Playlist ajoutée."),
        backgroundColor: Colors.green,
      ),
    );

    // Recharger le contenu de la Home
    if (mounted) {
      Provider.of<HomeViewModel>(context, listen: false).loadHomeContent();
    }

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(48),
          constraints: const BoxConstraints(maxWidth: 600),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.accentBlue.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentBlue.withOpacity(0.1),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _isPaired ? _buildSuccessState() : _buildCodeState(),
              const SizedBox(height: 32),
              Text(
                "Associer votre appareil",
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Rendez-vous sur apex-vision.app/pair et entrez le code ci-dessous :",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  color: AppColors.backgroundDark,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.focusBorder, width: 2),
                ),
                child: Text(
                  _pairingCode,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppColors.focusBorder,
                    letterSpacing: 8,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              if (!_isPaired) ...[
                const SizedBox(height: 32),
                Text(
                  "Ce code expire dans 5:00",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textSecondary.withOpacity(0.7),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCodeState() {
    return Column(
      children: [
        const Icon(
          Icons.phonelink_setup,
          size: 80,
          color: AppColors.accentBlue,
        ),
        const SizedBox(height: 32),
        Text(
          "Associer votre appareil",
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Rendez-vous sur apex-vision.app/pair et entrez le code ci-dessous :",
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 16,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 48),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
          decoration: BoxDecoration(
            color: AppColors.backgroundDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.focusBorder, width: 2),
          ),
          child: Text(
            _pairingCode,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: AppColors.focusBorder,
              letterSpacing: 8,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessState() {
    return Column(
      children: [
        const Icon(Icons.check_circle, size: 80, color: AppColors.accentGreen),
        const SizedBox(height: 32),
        Text(
          "Appareil Associé !",
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Votre playlist a été configurée avec succès. Vous allez être redirigé...",
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 16,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
