import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../util/strings.dart';
import '../../services/api_service.dart';
import '../result/result_screen.dart';

class PasteMessageScreen extends StatefulWidget {
  const PasteMessageScreen({super.key});

  @override
  State<PasteMessageScreen> createState() =>
      _PasteMessageScreenState();
}

class _PasteMessageScreenState
    extends State<PasteMessageScreen> {
  final TextEditingController _controller =
      TextEditingController();

  final SpeechToText _speech = SpeechToText();

  bool _isLoading = false;

  bool _isListening = false;

  Future<void> _toggleListen() async {
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
          content: Text('Speech recognition not available.'),
        ),
      );
      return;
    }

    setState(() {
      _isListening = true;
    });

    await _speech.listen(
      localeId: AppStrings.lang == 'hi' ? 'hi_IN' : AppStrings.lang == 'pa' ? 'pa_IN' : 'en_IN',
      listenFor: const Duration(seconds: 60),
      pauseFor: const Duration(seconds: 6),
      listenMode: ListenMode.dictation,
      onResult: (result) {
        setState(() {
          _controller.text = result.recognizedWords;
        });
      },
    );
  }

  Future<void> _analyzeMessage() async {
    final message = _controller.text.trim();

    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a message first.',
          ),
        ),
      );

      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result =
          await ApiService.analyzeText(message);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            result: result,
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error: $error',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.t('checkMessage'),
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isListening ? Icons.mic : Icons.mic_none,
              color: _isListening ? Colors.red : null,
            ),
            tooltip: 'Speak the message',
            onPressed: _toggleListen,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.t('pasteTitle'),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                AppStrings.t('pasteSub'),
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade400,
                ),
              ),

              const SizedBox(height: 24),

              Expanded(
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  expands: true,
                  textAlignVertical:
                      TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText:
                        'Example:\n\n'
                        'Guaranteed 5X return! '
                        'Join our Telegram VIP group '
                        'today. Limited seats...',
                    filled: true,
                    fillColor:
                        const Color(0xFF22242A),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        const EdgeInsets.all(18),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed:
                      _isLoading
                          ? null
                          : _analyzeMessage,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(
                          Icons.search,
                        ),
                  label: Text(
                    _isLoading
                        ? AppStrings.t('analyzing')
                        : AppStrings.t('analyze'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}