import 'package:flutter_tts/flutter_tts.dart';

import 'strings.dart';

class TtsHelper {
  static Future<void> speak(String text) async {
    final tts = FlutterTts();

    String wanted;
    switch (AppStrings.lang) {
      case 'hi':
        wanted = 'hi';
        break;
      case 'pa':
        wanted = 'pa';
        break;
      default:
        wanted = 'en';
    }

    try {
      final languages = await tts.getLanguages;
      final list = (languages as List?)
              ?.map((e) => e.toString().toLowerCase())
              .toList() ??
          [];

      String? match;
      for (final l in list) {
        if (l.startsWith('$wanted-') || l == wanted) {
          match = l;
          break;
        }
      }
      match ??= list.firstWhere(
        (l) => l.startsWith(wanted),
        orElse: () => '',
      );

      if (match.isNotEmpty) {
        await tts.setLanguage(match);
      } else {
        await tts.setLanguage(
          wanted == 'hi'
              ? 'hi-IN'
              : wanted == 'pa'
                  ? 'pa-IN'
                  : 'en-IN',
        );
      }
    } catch (_) {
      await tts.setLanguage('en-IN');
    }

    await tts.awaitSpeakCompletion(true);
    await tts.speak(text);
  }
}
