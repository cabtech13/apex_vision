import 'dart:convert';
import 'package:iptv_magik_app/data/models/channel.dart';

class M3UParser {
  /// Parses M3U content asynchronously in a separate isolate (simulated here with async for now,
  /// but can be moved to compute() if heavy).
  /// Returns a list of [Channel] objects.
  static Future<List<Channel>> parse(String content) async {
    // Basic M3U Parser logic
    // Handles #EXTINF lines

    final List<Channel> channels = [];
    final LineSplitter splitter = const LineSplitter();
    final List<String> lines = splitter.convert(content);

    String? currentName;
    String? currentLogo;
    String? currentGroup;
    String? currentTvgId;

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i].trim();

      if (line.isEmpty) continue;

      if (line.startsWith('#EXTINF:')) {
        // Parse metadata
        // Example: #EXTINF:-1 tvg-id="" tvg-name="" tvg-logo="" group-title="",Channel Name

        // Extract attributes
        currentLogo = _extractAttribute(line, 'tvg-logo');
        currentGroup = _extractAttribute(line, 'group-title');
        currentTvgId = _extractAttribute(line, 'tvg-id');

        // Extract Name (after the last comma)
        int lastCommaIndex = line.lastIndexOf(',');
        if (lastCommaIndex != -1) {
          currentName = line.substring(lastCommaIndex + 1).trim();
        } else {
          currentName = "Unknown Channel";
        }
      } else if (!line.startsWith('#')) {
        // It's a URL
        if (currentName != null) {
          channels.add(
            Channel(
              id:
                  currentTvgId ??
                  DateTime.now().microsecondsSinceEpoch
                      .toString(), // Fallback ID
              name: currentName,
              streamUrl: line,
              logoUrl: currentLogo,
              category: currentGroup ?? 'Uncategorized',
              tvgId: int.tryParse(currentTvgId ?? '0'),
            ),
          );

          // Reset for next entry
          currentName = null;
          currentLogo = null;
          currentGroup = null;
          currentTvgId = null;
        }
      }
    }

    return channels;
  }

  static String? _extractAttribute(String line, String key) {
    // Regex to find key="value"
    RegExp regex = RegExp('$key="([^"]*)"');
    Match? match = regex.firstMatch(line);
    return match?.group(1);
  }
}
