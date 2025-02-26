import 'package:cupertino_country_state_picker/views/widgets/country_picker_w.dart';
import 'package:cupertino_country_state_picker/views/widgets/state_picker_w.dart';
import 'package:cupertino_country_state_picker/vm/country_state_picker_vm.dart';
import 'package:flutter/material.dart';

/// RendersWidget
class CupertinoCountryStatePicker extends StatefulWidget {
  /// Callback function triggered when the country selection changes.
  final ValueChanged<String> onCountryChanged;

  /// Callback function triggered when the state selection changes.
  final ValueChanged<String> onStateChanged;

  /// Background color of the bottom sheet when the picker is opened.
  final Color? bottomSheetColor;

  /// Border color of the picker components.
  final Color? borderColor;

  /// Background color of the output field.
  final Color? backgroundColor;

  /// Border radius of the bottom sheet for a rounded appearance.
  final double? bottomSheetBorderRadius;

  /// Height of each item in the picker list.
  final double? pickerItemExtent;

  /// The overall height of the picker widget.
  final double? pickerSize;

  /// Space between the country and state pickers when displayed together.
  final double? horizontalSpace;

  /// Border radius of the picker for rounded edges.
  final double? borderRadius;

  /// Whether to show the drag handle on top of the bottom sheet.
  final bool showBottomSheetDragHandle;

  /// Custom text style for the selected country or state.
  final TextStyle? pickedValueTextStyle;

  /// Text style for items in the picker.
  final TextStyle? pickerTextStyle;

  /// Text style for the labels (e.g., "Country" and "State").
  final TextStyle? labelTextStyle;

  /// Padding inside the output field container.
  final EdgeInsets? padding;

  /// Pre-selected country when the picker is first opened.
  final String? initialCountry;

  /// Pre-selected state when the picker is first opened.
  final String? initialState;

  /// Custom overlay for highlighting the selected picker item.
  final Widget? pickerSelectedOverlay;

  /// Duration of the animation when picker auto scrolls.
  final Duration? pickerAnimationDuration;

  /// Animation curve applied when picker auto scrolls.
  final Curve pickerAnimation;

  /// Custom search icon for the search field in the picker.
  final Widget? pickerSearchIcon;

  /// Custom decoration for the search input field.
  final InputDecoration? pickerSearchInputDecoration;

  /// CupertinoCountryStatePicker Constructor, it should be initialized via this constructor only
  const CupertinoCountryStatePicker({
    super.key,
    this.bottomSheetColor,
    this.bottomSheetBorderRadius,
    this.showBottomSheetDragHandle = true,
    this.borderColor,
    this.backgroundColor,
    this.pickedValueTextStyle,
    this.pickerTextStyle,
    this.pickerItemExtent = 40.0,
    this.pickerSize,
    required this.onCountryChanged,
    required this.onStateChanged,
    this.horizontalSpace,
    this.labelTextStyle,
    this.padding,
    this.borderRadius,
    this.initialCountry,
    this.initialState,
    this.pickerSelectedOverlay,
    this.pickerAnimationDuration,
    this.pickerSearchIcon,
    this.pickerSearchInputDecoration,
    this.pickerAnimation = Curves.easeIn,
  });

  @override
  State<CupertinoCountryStatePicker> createState() =>
      _CupertinoCountryStatePickerViewState();
}

class _CupertinoCountryStatePickerViewState
    extends State<CupertinoCountryStatePicker> {
  final CountryStatePickerVM _countryStatePickerVM = CountryStatePickerVM();

  @override
  void initState() {
    _countryStatePickerVM.initialize(
      setState: () => setState(() => ()),
      pickerAnimationDuration:
          widget.pickerAnimationDuration ?? Duration(seconds: 1),
      pickerAnimation: widget.pickerAnimation,
      initialCountry: widget.initialCountry,
      initialState: widget.initialState,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildOutputField(
            callback: () {
              showPicker(true);
              _countryStatePickerVM.setCountryControllerPosition();
            },
            headlineText: "Country",
            pickedValue:
                ((widget.initialCountry != null &&
                            widget.initialCountry!.isNotEmpty) &&
                        _countryStatePickerVM.selectedCountry.isEmpty)
                    ? widget.initialCountry!
                    : _countryStatePickerVM.selectedCountry.isNotEmpty
                    ? _countryStatePickerVM.selectedCountry
                    : "Choose a country",
          ),
        ),
        SizedBox(width: widget.horizontalSpace ?? 8),
        Expanded(
          child: _buildOutputField(
            callback: () async {
              if (_countryStatePickerVM.selectedCountry.isNotEmpty) {
                await _countryStatePickerVM.initializeState(() {
                  setState(() {});
                }, widget.initialState);
                showPicker(false);
              }
            },
            headlineText: "State/Province",
            pickedValue:
                ((widget.initialState != null &&
                            widget.initialState!.isNotEmpty) &&
                        _countryStatePickerVM.selectedCountry.isEmpty)
                    ? widget.initialState!
                    : _countryStatePickerVM.selectedState.isNotEmpty
                    ? _countryStatePickerVM.selectedState
                    : "Choose a state",
          ),
        ),
      ],
    );
  }

  Widget _buildOutputField({
    required GestureTapCallback callback,
    required String headlineText,
    required String pickedValue,
  }) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        padding: widget.padding ?? const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 1),
          border: Border.all(
            color:
                widget.borderColor ??
                const Color(0xFF86909B).withValues(alpha: 0.3),
            width: 1,
          ),
          color: widget.backgroundColor ?? Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              headlineText,
              style:
                  widget.labelTextStyle ??
                  Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                    color: const Color(0xFF86909B),
                  ),
            ),
            const SizedBox(height: 5),
            Text(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              pickedValue,
              style: widget.pickedValueTextStyle,
            ),
          ],
        ),
      ),
    );
  }

  showPicker(bool isCountry) {
    if (isCountry) {
      showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            widget.bottomSheetBorderRadius ?? 0,
          ),
        ),
        backgroundColor: widget.bottomSheetColor ?? Colors.white,
        context: context,
        builder: (context) {
          return CountryPicker(
            showBottomSheetDragHandle: widget.showBottomSheetDragHandle,
            pickerSize: widget.pickerSize,
            pickerItemExtent: widget.pickerItemExtent,
            countryStatePickerVM: _countryStatePickerVM,
            onStateChanged: widget.onStateChanged,
            onCountryChanged: widget.onCountryChanged,
            pickerSelectedOverlay: widget.pickerSelectedOverlay,
            pickerTextStyle: widget.pickerTextStyle,
            pickerSearchIcon: widget.pickerSearchIcon,
            pickerSearchInputDecoration: widget.pickerSearchInputDecoration,
            updateParent: () {
              setState(() {});
            },
          );
        },
      );
    } else {
      showModalBottomSheet(
        useSafeArea: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            widget.bottomSheetBorderRadius ?? 0,
          ),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (context) {
          return StatePicker(
            showBottomSheetDragHandle: widget.showBottomSheetDragHandle,
            countryStatePickerVM: _countryStatePickerVM,
            onStateChanged: widget.onStateChanged,
            pickerSelectedOverlay: widget.pickerSelectedOverlay,
            pickerTextStyle: widget.pickerTextStyle,
            pickerSize: widget.pickerSize,
            pickerItemExtent: widget.pickerItemExtent,
            pickerSearchIcon: widget.pickerSearchIcon,
            pickerSearchInputDecoration: widget.pickerSearchInputDecoration,
            updateParent: () {
              setState(() {});
            },
          );
        },
      );
    }
  }
}
