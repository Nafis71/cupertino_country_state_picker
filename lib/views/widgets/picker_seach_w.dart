import 'package:flutter/material.dart';

///
class PickerSearch extends StatelessWidget {
  /// Callback function to update ui upon search completion
  final Function onChanged;

  /// Custom search icon for the search field in the picker.
  final Widget? pickerSearchIcon;

  /// Custom decoration for the search input field.
  final InputDecoration? pickerSearchInputDecoration;

  ///
  const PickerSearch({
    super.key,
    required this.onChanged,
    this.pickerSearchIcon,
    this.pickerSearchInputDecoration,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: TextFormField(
        decoration:
            pickerSearchInputDecoration ??
            InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(1),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(1),
              ),
              prefixIcon: pickerSearchIcon ?? Icon(Icons.search),
            ),
        onChanged: (text) {
          onChanged(text);
        },
      ),
    );
  }
}
