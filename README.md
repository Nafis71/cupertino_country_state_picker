# cupertino_country_state_picker

A Flutter package that provides a Cupertino-style country and state/province picker with a smooth and elegant UI. This package allows users to select a country and its corresponding states/provinces in a structured and user-friendly way.

## Features
- 🌍 Select countries with a Cupertino-style bottom sheet picker.
- 🏛️ Choose states/provinces based on the selected country.
- 🎨 Customizable UI with support for flags and localized names.
- 🔥 Find countries or states using search box.
- 🐦‍🔥 Customize scroll animations and duration.
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
  pickerSearchIcon: Icon(Icons.search),
  pickerAnimation: Curves.easeIn,
)
```

## Parameters

| Parameter                   | Type                     | Default               | Description |
|-----------------------------|--------------------------|-----------------------|-------------|
| `onCountryChanged`          | `ValueChanged<String>`   | **Required**          | Callback function triggered when the country selection changes. |
| `onStateChanged`            | `ValueChanged<String>`   | **Required**          | Callback function triggered when the state selection changes. |
| `bottomSheetColor`          | `Color?`                 | **Optional**          | Background color of the bottom sheet when the picker is opened. |
| `borderColor`               | `Color?`                 | **Optional**          | Border color of the picker components. |
| `backgroundColor`           | `Color?`                 | **Optional**          | Background color of the picker itself. |
| `bottomSheetBorderRadius`   | `double?`                | **Optional**          | Border radius of the bottom sheet for a rounded appearance. |
| `pickerItemExtent`          | `double?`                | `40.0`                | Height of each item in the picker list. |
| `pickerSize`               | `double?`                | **Optional**          | The overall height of the picker widget. |
| `horizontalSpace`           | `double?`                | **Optional**          | Space between the country and state pickers when displayed together. |
| `borderRadius`             | `double?`                | **Optional**          | Border radius of the picker for rounded edges. |
| `showBottomSheetDragHandle` | `bool`                   | `true`                | Whether to show the drag handle on top of the bottom sheet. |
| `pickedValueTextStyle`      | `TextStyle?`             | **Optional**          | Custom text style for the selected country or state. |
| `pickerTextStyle`           | `TextStyle?`             | **Optional**          | Text style for unselected items in the picker. |
| `labelTextStyle`            | `TextStyle?`             | **Optional**          | Text style for the labels (e.g., "Country" and "State"). |
| `padding`                   | `EdgeInsets?`            | **Optional**          | Padding inside the picker container. |
| `initialCountry`            | `String?`                | **Optional**          | Pre-selected country when the picker is first opened. |
| `initialState`              | `String?`                | **Optional**          | Pre-selected state when the picker is first opened. |
| `pickerSelectedOverlay`     | `Widget?`                | **Optional**          | Custom overlay for highlighting the selected picker item. |
| `pickerAnimationDuration`   | `Duration?`              | **Optional**          | Duration of the animation when scrolling through items. |
| `pickerAnimation`           | `Curve`                  | `Curves.easeIn`       | Animation curve applied when scrolling through picker items. |
| `pickerSearchIcon`          | `Widget?`                | **Optional**          | Custom search icon for the search field in the picker. |
| `pickerSearchInputDecoration` | `InputDecoration?`      | **Optional**          | Custom decoration for the search input field. |

## Screenshots
<img align="left" alt ="homePage" width ="250" src="https://github.com/user-attachments/assets/bceacf4e-6388-43d6-8091-90894c5f892b"></img>
<img align="center" alt ="homePage" width ="250" src="https://github.com/user-attachments/assets/de0c4835-d27e-4d66-8331-1f74ce58975f"></img>







## Contributing
Contributions are welcome! Feel free to open an issue or submit a pull request to improve the package.

## License

This package is licensed under the MIT License. See the `LICENSE` file for more details.

## Support
If you like this package, please ⭐ the repository and share it with the community!

