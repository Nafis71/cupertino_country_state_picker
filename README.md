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
  onCountryChanged: (value) {},
  onStateChanged: (value) {},
  initialCountry: "Bangladesh",
  backgroundColor: Colors.amber,
  bottomSheetColor: Colors.amber,
  pickedValueTextStyle: TextStyle(
  fontSize: 14,
  ),
  borderRadius: 16,
  labelTextStyle: TextStyle(
  fontSize: 13,
  ),
)
```

## Parameters

| Parameter | Type | Description                                           |
|-----------|------|-------------------------------------------------------|
| `onCountryChanged` | `ValueChanged<String>` | Callback when a country is selected.                  |
| `onStateChanged` | `ValueChanged<String>` | Callback when a state is selected.                    |
| `bottomSheetColor` | `Color?` | Background color of the bottom sheet.                 |
| `borderColor` | `Color?` | Border color of the picker.                           |
| `backgroundColor` | `Color?` | Background color of the textbox.                      |
| `bottomSheetBorderRadius` | `double?` | Border radius of the bottom sheet.                    |
| `pickerItemExtent` | `double?` | Height of each picker item.                           |
| `pickerSize` | `double?` | Size of the picker.                                   |
| `horizontalSpace` | `double?` | Horizontal spacing between country and state textbox. |
| `borderRadius` | `double?` | Border radius of the textbox.                         |
| `showBottomSheetDragHandle` | `bool` | Whether to show a drag handle on the bottom sheet.    |
| `pickedValueTextStyle` | `TextStyle?` | Text style for the selected value.                    |
| `pickerTextStyle` | `TextStyle?` | Text style for the picker items.                      |
| `labelTextStyle` | `TextStyle?` | Text style for labels.                                |
| `padding` | `EdgeInsets?` | Padding around the picker.                            |
| `initialCountry` | `String?` | Initial selected country.                             |
| `initialState` | `String?` | Initial selected state.                               |
| `pickerSelectedOverlay` | `Widget?` | Custom overlay for the selected picker item.          |

## Screenshots
![Image](https://github.com/user-attachments/assets/1c79a5b7-776b-4e99-b9e4-16cbb0365979)
![Image](https://github.com/user-attachments/assets/02213585-4256-4969-ac7d-34ee4a82d288)

## Roadmap
- [ ] Add search functionality for countries and states.

## Contributing
Contributions are welcome! Feel free to open an issue or submit a pull request to improve the package.

## License

This package is licensed under the MIT License. See the `LICENSE` file for more details.

## Support
If you like this package, please ⭐ the repository and share it with the community!

