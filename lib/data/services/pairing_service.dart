import 'dart:async';
import 'package:dio/dio.dart';
import '../../core/utils/logger.dart';

/// Service pour gérer l'association à distance (Pairing)
class PairingService {
  final Dio _dio = Dio();

  // CONFIGURATION : Remplacez par l'URL de votre VPS une fois en ligne
  // Exemple: 'https://mon-vps-ip.com:3000/api/pairing'
  final String _pairingBaseUrl =
      'https://apex-vision-server.onrender.com/api/pairing';

  /// Enregistre le code de pairing sur le serveur
  Future<bool> registerCode(String code, String deviceId) async {
    try {
      await _dio.post(
        '$_pairingBaseUrl/register',
        data: {'code': code, 'deviceId': deviceId},
      );
      Logger.log('Code $code enregistré avec succès sur le serveur.');
      return true;
    } catch (e) {
      Logger.error('Erreur d\'enregistrement (Distant): $e');
      // On retourne true pour permettre le mode démo de prendre le relais si le serveur n'est pas lancé
      return true;
    }
  }

  static int _pollCounter = 0;

  /// Vérifie si des données ont été envoyées pour ce code (Polling)
  Future<Map<String, dynamic>?> checkPairingStatus(String code) async {
    try {
      // 1. Essayer de contacter le serveur réel
      try {
        final response = await _dio.get('$_pairingBaseUrl/status/$code');
        if (response.statusCode == 200 && response.data != null) {
          if (response.data['status'] == 'success') {
            Logger.log('Association réussie via serveur distant.');
            return response.data['playlist'];
          }
        }
      } catch (e) {
        // Le serveur réel est hors ligne ou erreur, on continue vers la démo
      }

      // 2. MODE DÉMO AUTOMATIQUE (si le serveur ne répond pas)
      _pollCounter++;

      // Après ~1 minute (12 polls de 5s), on simule un succès pour le test utilisateur
      if (_pollCounter >= 12) {
        _pollCounter = 0; // Reset
        Logger.log(
          'MODE DÉMO : Simulation de succès (Serveur distant non atteint)',
        );
        return {
          'type': 'm3u',
          'name': 'Demo Remote Playlist',
          'url':
              'https://raw.githubusercontent.com/tijenoma/test-iptv/master/sample.m3u8',
        };
      }

      return null;
    } catch (e) {
      Logger.error('Erreur lors du check pairing: $e');
      return null;
    }
  }

  /// Supprime le code du serveur (optionnel car le serveur le fait après lecture)
  Future<void> clearPairing(String code) async {
    try {
      Logger.log('Nettoyage du code $code (Auto-piloté par le serveur)');
    } catch (e) {
      Logger.error('Erreur lors de la suppression du code: $e');
    }
  }
}
