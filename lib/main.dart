import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/home_screen.dart';
import 'data/models/channel.dart';
import 'data/models/category.dart';
import 'data/models/vod_content.dart';
import 'data/models/playlist.dart';
import 'data/repositories/playlist_repository.dart';
import 'data/services/playlist_service.dart';
import 'presentation/viewmodels/playlist_viewmodel.dart';
import 'presentation/viewmodels/home_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Forcer mode paysage pour Android TV
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Initialiser Hive pour la base de données locale
  await Hive.initFlutter();

  // Enregistrer les adapters Hive
  Hive.registerAdapter(ChannelAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(VODContentAdapter());
  Hive.registerAdapter(VODTypeAdapter());
  Hive.registerAdapter(PlaylistAdapter());

  // Ouvrir les boxes
  await Hive.openBox<Channel>('channels');
  await Hive.openBox<Category>('categories');
  await Hive.openBox<VODContent>('vod_content');
  await Hive.openBox('settings'); // Box générique pour paramètres

  // Initialiser les repositories
  final playlistRepository = await PlaylistRepository.init();
  final playlistService = PlaylistService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PlaylistViewModel(playlistRepository),
        ),
        ChangeNotifierProvider(
          create:
              (_) => HomeViewModel(
                playlistRepository: playlistRepository,
                playlistService: playlistService,
              ),
        ),
      ],
      child: const ApexVisionApp(),
    ),
  );
}

class ApexVisionApp extends StatelessWidget {
  const ApexVisionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Apex Vision',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getDarkTheme(),

      // Désactiver le glow effect sur Android (pour look TV)
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: const _TVScrollBehavior(),
          child: child!,
        );
      },

      home: const HomeScreen(),
    );
  }
}

/// Comportement de scroll personnalisé pour Android TV (sans glow)
class _TVScrollBehavior extends ScrollBehavior {
  const _TVScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child; // Pas de glow effect
  }
}
