# cupertino_country_state_picker

A Flutter package that provides a Cupertino-style country and state/province picker with a smooth and elegant UI. This package allows users to select a country and its corresponding states/provinces in a structured and user-friendly way.

## Features
- 🌍 Select countries with a Cupertino-style bottom sheet picker.
- 🏛️ Choose states/provinces based on the selected country.
- 🎨 Customizable UI with support for flags and localized names.
- 🔄 Easily integrate into existing projects with minimal setup.

## Installation

Add the following dependency to your `pubspec.yaml`:

```yaml
dependencies:
  cupertino_country_state_picker: latest_version
```

Then, run:

```sh
flutter pub get
```

## Usage

Import the package:

```dart
import 'package:cupertino_country_state_picker/cupertino_country_state_picker.dart';
```

### Basic Example

```dart
CupertinoCountryStatePicker(
  onCountryChanged: (country) {
    print('Selected Country: $country');
  },
  onStateChanged: (state) {
    print('Selected State: $state');
  },
)
```

### Customizing the Picker

```dart
CupertinoCountryStatePicker(
  initialCountry: "United States",
  showFlags: true,
  backgroundColor: Colors.white,
  onCountryChanged: (country) {
    // Handle country selection
  },
  onStateChanged: (state) {
    // Handle state selection
  },
)
```

## Screenshots
![Image](https://github.com/user-attachments/assets/1c79a5b7-776b-4e99-b9e4-16cbb0365979)
![Image](https://github.com/user-attachments/assets/02213585-4256-4969-ac7d-34ee4a82d288)

## Roadmap
- [ ] Add search functionality for countries and states.
- [ ] Support for different themes.
- [ ] Localization support for multiple languages.

## Contributing
Contributions are welcome! Feel free to open an issue or submit a pull request to improve the package.

## License

This package is licensed under the MIT License. See the `LICENSE` file for more details.

## Support
If you like this package, please ⭐ the repository and share it with the community!

