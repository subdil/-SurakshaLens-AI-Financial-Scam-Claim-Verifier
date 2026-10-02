import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../util/strings.dart';
import '../result/result_screen.dart';
import '../../services/api_service.dart';
import '../../util/ocr_platform.dart';

class ScreenshotScreen extends StatefulWidget {
  const ScreenshotScreen({
    super.key,
  });

  @override
  State<ScreenshotScreen> createState() =>
      _ScreenshotScreenState();
}

class _ScreenshotScreenState
    extends State<ScreenshotScreen> {
  final ImagePicker _picker = ImagePicker();

  Uint8List? _imageBytes;

  String? _fileName;

  bool _isLoading = false;

  Future<void> _pickImage() async {
    try {
      final XFile? image =
          await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 80,
      );

      if (image == null) {
        return;
      }

      final bytes = await image.readAsBytes();

      setState(() {
        _imageBytes = bytes;
        _fileName = image.name;
      });
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Could not select image: $error',
          ),
        ),
      );
    }
  }

  Future<void> _analyzeImage() async {
    if (_imageBytes == null ||
        _fileName == null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final extractedText =
          await OcrPlatform.extractText(_imageBytes!);

      if (extractedText.trim().isEmpty) {
        throw Exception('No text could be read from the image.');
      }

      final result =
          await ApiService.analyzeText(extractedText);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            result: result,
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Analysis failed: $error',
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.t('checkScreenshot'),
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                AppStrings.t('uploadTitle'),
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              Text(
                AppStrings.t('uploadSub'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 25),

              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey.shade800,
                    ),
                    color: const Color(0xFF1B1D22),
                  ),
                  child: _imageBytes == null
                      ? Center(
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .center,
                            children: [
                              Icon(
                                Icons
                                    .image_outlined,
                                size: 70,
                                color: Colors
                                    .grey.shade500,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                AppStrings.t('noScreenshot'),
                              ),
                            ],
                          ),
                        )
                      : ClipRRect(
                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),
                          child: Image.memory(
                            _imageBytes!,
                            fit: BoxFit.contain,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton.icon(
                  onPressed: _isLoading
                      ? null
                      : _pickImage,
                  icon: const Icon(
                    Icons.photo_library_outlined,
                  ),
                  label: Text(
                    AppStrings.t('chooseScreenshot'),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed:
                      _imageBytes == null ||
                              _isLoading
                          ? null
                          : _analyzeImage,
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
                        ? AppStrings.t('readingScreenshot')
                        : AppStrings.t('analyzeScreenshot'),
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