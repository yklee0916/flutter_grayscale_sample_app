# Flutter Grayscale Sample App

A Flutter sample application demonstrating grayscale image conversion using the `flutter_grayscale` plugin.

## Features

- Select images from file system (macOS)
- Convert selected images to grayscale
- Real-time preview of original and converted images
- Error handling and logging

## Requirements

- Flutter SDK >= 3.9.2
- Dart SDK >= 3.9.2
- macOS 10.15+

## Dependencies

This app uses the following packages:

- `flutter_grayscale` - Grayscale image conversion plugin
- `flutter_log` - Logging utility
- `file_selector` - File selection for macOS

## Getting Started

1. Clone the repository:
```bash
git clone https://github.com/yklee0916/flutter_grayscale_sample_app.git
cd flutter_grayscale_sample_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── views/
│   └── content_view.dart        # Main UI view
├── viewmodels/
│   └── grayscale_view_model.dart # Business logic and state management
└── listeners/
    └── console_log_listener.dart # Log listener implementation
```

## Architecture

The app follows the MVVM (Model-View-ViewModel) pattern:

- **View**: `ContentView` - UI components and layout
- **ViewModel**: `GrayscaleViewModel` - Business logic, state management, and SDK integration
- **Model**: Handled by the `flutter_grayscale` plugin

## Usage

1. Launch the app
2. Click "이미지 선택" (Select Image) button
3. Choose an image from your Mac
4. Click "Grayscale 변환" (Convert to Grayscale) button
5. View the converted grayscale image

## Platform Support

- ✅ macOS

## License

MIT License. See [LICENSE](LICENSE) for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Author

Younggi Lee
