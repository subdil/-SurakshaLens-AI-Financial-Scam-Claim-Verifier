import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'util/strings.dart';
import 'util/speech.dart';
import 'pages/history/history_screen.dart';
import 'pages/paste/paste_screen.dart';
import 'pages/result/result_screen.dart';
import 'pages/shot/shot_screen.dart';
import 'services/api_service.dart';

void main() {
  runApp(const SurakshaLensApp());
}

class SurakshaLensApp extends StatelessWidget {
  const SurakshaLensApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SurakshaLens',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: const Color(0xFF64748B),
        scaffoldBackgroundColor: const Color(0xFF17181C),
        cardColor: const Color(0xFF22242A),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SpeechToText _speech = SpeechToText();
  bool _isListening = false;
  bool _isAnalyzing = false;

  Future<void> _speak() async {
    await TtsHelper.speak(AppStrings.t('speakIntro'));
  }

  Future<void> _listenAndAnalyze() async {
    if (_isListening) {
      await _speech.stop();
      setState(() {
        _isListening = false;
      });
      return;
    }

    final available = await _speech.initialize();

    if (!available) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Speech recognition not available. Use Chrome and allow mic access.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _isListening = true;
    });

    await _speech.listen(
      localeId: AppStrings.lang == 'hi'
          ? 'hi_IN'
          : AppStrings.lang == 'pa'
              ? 'pa_IN'
              : 'en_IN',
      listenFor: const Duration(seconds: 60),
      pauseFor: const Duration(seconds: 6),
      listenMode: ListenMode.dictation,
      onResult: (result) async {
        if (result.finalResult) {
          final text = result.recognizedWords.trim();

          setState(() {
            _isListening = false;
          });

          if (text.isEmpty) return;

          setState(() {
            _isAnalyzing = true;
          });

          try {
            final analysis = await ApiService.analyzeText(text);

            if (!mounted) return;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ResultScreen(result: analysis),
              ),
            );
          } catch (error) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $error')),
            );
          } finally {
            if (mounted) {
              setState(() {
                _isAnalyzing = false;
              });
            }
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SurakshaLens',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          DropdownButton<String>(
            value: AppStrings.lang,
            dropdownColor: const Color(0xFF22242A),
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: 'en', child: Text('EN')),
              DropdownMenuItem(value: 'hi', child: Text('हिंदी')),
              DropdownMenuItem(value: 'pa', child: Text('ਪੰਜਾਬੀ')),
            ],
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                AppStrings.lang = value;
              });
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shield_outlined,
              size: 80,
            ),

            const SizedBox(height: 20),

            Text(
              AppStrings.t('tagline'),
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                AppStrings.t('taglineSub'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 35),

            SizedBox(
              width: 300,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ScreenshotScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.image),
                label: Text(AppStrings.t('uploadScreenshot')),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: 300,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PasteMessageScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
                label: Text(AppStrings.t('pasteMessage')),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: 300,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _isAnalyzing ? null : _listenAndAnalyze,
                icon: Icon(
                  _isListening ? Icons.stop : Icons.mic,
                  color: _isListening ? Colors.red : null,
                ),
                label: Text(
                  _isAnalyzing
                      ? AppStrings.t('analyzing')
                      : (_isListening
                          ? 'Listening...'
                          : AppStrings.t('speakMessage')),
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: 300,
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _speak,
                      icon: const Icon(Icons.volume_up, size: 18),
                      label: Text(AppStrings.t('speak')),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HistoryScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.history, size: 18),
                      label: const Text('History'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}