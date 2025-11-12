import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:grayscale/grayscale.dart';
import 'package:log/log.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_selector/file_selector.dart';

class GrayscaleViewModel extends ChangeNotifier with Logger {
  static final GrayscaleViewModel _instance = GrayscaleViewModel._internal();
  factory GrayscaleViewModel() => _instance;
  GrayscaleViewModel._internal();

  @override
  String get logTag => "GrayscaleViewModel";

  File? _originalImage;
  File? _grayscaleImage;
  String? _selectedImagePath;
  bool _isConverting = false;
  String? _errorMessage;
  bool _isSDKInitialized = false;

  final ImagePicker _imagePicker = ImagePicker();

  File? get originalImage => _originalImage;
  File? get grayscaleImage => _grayscaleImage;
  String? get selectedImagePath => _selectedImagePath;
  bool get isConverting => _isConverting;
  String? get errorMessage => _errorMessage;
  bool get isSDKInitialized => _isSDKInitialized;

  void initializeSDK() {
    logI("SDK 초기화 시작");
    _isSDKInitialized = true;
    _errorMessage = null;
    notifyListeners();
    logI("SDK 초기화 완료");
  }

  Future<void> convertToGrayscale() async {
    if (!_isSDKInitialized) {
      _errorMessage = "SDK가 초기화되지 않았습니다";
      notifyListeners();
      return;
    }
    if (_selectedImagePath == null) {
      _errorMessage = "이미지를 선택해주세요";
      notifyListeners();
      return;
    }
    _isConverting = true;
    _errorMessage = null;
    notifyListeners();
    try {
      logI("Grayscale 변환 시작: $_selectedImagePath");
      final resultPath = await Grayscale.convertToGrayscale(
        _selectedImagePath!,
      );
      logI("Grayscale 변환 완료: $resultPath");

      final resultFile = File(resultPath);
      if (await resultFile.exists()) {
        _grayscaleImage = resultFile;
        _isConverting = false;
        _errorMessage = null;
        logI("변환된 이미지 로드 완료");
      } else {
        _errorMessage = "변환된 이미지를 로드할 수 없습니다";
        _isConverting = false;
        logE("변환된 이미지 파일이 존재하지 않음: $resultPath");
      }
    } catch (e) {
      _errorMessage = "변환 실패: ${e.toString()}";
      _isConverting = false;
      logE("Grayscale 변환 실패: $e");
    }
    notifyListeners();
  }

  void setOriginalImage(File? image, String? imagePath) {
    _originalImage = image;
    _selectedImagePath = imagePath;
    _grayscaleImage = null;
    _errorMessage = null;
    notifyListeners();
  }

  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void resetSelection() {
    _originalImage = null;
    _grayscaleImage = null;
    _selectedImagePath = null;
    _errorMessage = null;
    _isConverting = false;
    notifyListeners();
  }

  Future<void> pickImage() async {
    logI('이미지 선택 버튼 클릭됨');
    resetSelection();
    try {
      if (Platform.isMacOS || kIsWeb) {
        await _pickImageFromFileSelector();
      } else {
        await _pickImageFromGallery();
      }
    } catch (e, stackTrace) {
      logE('이미지 선택 오류: $e', stackTrace: stackTrace);
      setError("이미지 선택 실패: ${e.toString()}");
    }
  }

  Future<void> _pickImageFromFileSelector() async {
    logI('macOS/웹 플랫폼: file_selector 사용');
    const XTypeGroup imageTypeGroup = XTypeGroup(
      label: 'images',
      extensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'],
    );
    logD('file_selector.openFile 호출 시작');
    final XFile? file = await openFile(acceptedTypeGroups: [imageTypeGroup]);
    logD('file_selector 결과: ${file != null ? "파일 선택됨" : "취소됨"}');
    if (file == null) {
      logD('파일이 선택되지 않았습니다');
      return;
    }
    await _processSelectedFile(file.path);
  }

  Future<void> _pickImageFromGallery() async {
    logI('iOS/Android 플랫폼: image_picker 사용');
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      await _processSelectedFile(pickedFile.path);
    }
  }

  Future<void> _processSelectedFile(String filePath) async {
    logD('선택된 파일 경로: $filePath');
    final fileObj = File(filePath);
    if (await fileObj.exists()) {
      logI('파일 존재 확인됨: $filePath');
      setOriginalImage(fileObj, filePath);
    } else {
      logW('파일이 존재하지 않음: $filePath');
      setError("선택한 이미지 파일을 찾을 수 없습니다");
    }
  }
}
