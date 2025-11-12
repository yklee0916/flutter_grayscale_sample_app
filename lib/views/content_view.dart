import 'package:flutter/material.dart';
import '../viewmodels/grayscale_view_model.dart';

class ContentView extends StatefulWidget {
  const ContentView({super.key});

  @override
  State<ContentView> createState() => _ContentViewState();
}

class _ContentViewState extends State<ContentView> {
  final GrayscaleViewModel _viewModel = GrayscaleViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.initializeSDK();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, child) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text(
                    "Grayscale Image Converter",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // 이미지 표시 영역
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 좌측: 원본 이미지
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                "원본",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.grey[200],
                                  ),
                                  child: _viewModel.originalImage != null
                                      ? Image.file(
                                          _viewModel.originalImage!,
                                          fit: BoxFit.contain,
                                        )
                                      : const Center(
                                          child: Text(
                                            "이미지를 선택하세요",
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        // 우측: 변환된 grayscale 이미지
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                "변환 후",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: Colors.grey[200],
                                  ),
                                  child: _viewModel.grayscaleImage != null
                                      ? Image.file(
                                          _viewModel.grayscaleImage!,
                                          fit: BoxFit.contain,
                                        )
                                      : const Center(
                                          child: Text(
                                            "변환된 이미지가\n여기에 표시됩니다",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 에러 메시지
                  if (_viewModel.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        _viewModel.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 20),
                  // 버튼들
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _viewModel.isConverting
                              ? null
                              : () => _viewModel.pickImage(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("이미지 선택"),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              (_viewModel.selectedImagePath != null &&
                                  !_viewModel.isConverting)
                              ? () => _viewModel.convertToGrayscale()
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _viewModel.selectedImagePath != null
                                ? Colors.green
                                : Colors.grey,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: _viewModel.isConverting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text("Grayscale 변환"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
