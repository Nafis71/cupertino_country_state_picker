import 'package:cupertino_country_state_picker/views/widgets/picker_seach_w.dart';
import 'package:cupertino_country_state_picker/vm/country_state_picker_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../vm/picker_debouncer.dart';

/// Renders country picker widget
class CountryPicker extends StatefulWidget {
  /// Whether to show the drag handle on top of the bottom sheet.
  final bool showBottomSheetDragHandle;

  /// Whether to show
  final double? pickerSize;

  /// The overall height of the picker widget.
  final double? pickerItemExtent;

  /// Gets the current instance of country state picker view model
  final CountryStatePickerVM countryStatePickerVM;

  /// Callback function triggered when the country selection changes.
  final ValueChanged<String> onStateChanged;

  /// Callback function triggered when the state selection changes.
  final ValueChanged<String> onCountryChanged;

  /// Custom overlay for highlighting the selected picker item.
  final Widget? pickerSelectedOverlay;

  /// Text style for items in the picker.
  final TextStyle? pickerTextStyle;

  /// Callback function to trigger ui update in output field
  final Function updateParent;

  /// Custom search icon for the search field in the picker.
  final Widget? pickerSearchIcon;

  /// Custom decoration for the search input field.
  final InputDecoration? pickerSearchInputDecoration;

  ///
  const CountryPicker({
    super.key,
    required this.showBottomSheetDragHandle,
    required this.pickerSize,
    required this.countryStatePickerVM,
    required this.onStateChanged,
    required this.onCountryChanged,
    this.pickerItemExtent,
    this.pickerSelectedOverlay,
    this.pickerTextStyle,
    required this.updateParent,
    this.pickerSearchIcon,
    this.pickerSearchInputDecoration,
  });

  @override
  State<CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  final PickerDeBouncer _pickerDeBouncer = PickerDeBouncer(
    delay: Duration(milliseconds: 500),
  );

  @override
  void initState() {
    widget.countryStatePickerVM.initiateCountryPickerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        if (widget.showBottomSheetDragHandle)
          Center(
            child: Container(
              height: 4,
              width: 120,
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF86909B).withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
        SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              PickerSearch(
                onChanged: (text) {
                  _pickerDeBouncer.call(() {
                    widget.countryStatePickerVM.setCountryControllerPosition(
                      searchedCountry: text,
                    );
                  });
                },
                pickerSearchIcon: widget.pickerSearchIcon,
                pickerSearchInputDecoration: widget.pickerSearchInputDecoration,
              ),
              SizedBox(
                height: widget.pickerSize ?? 250,
                width: MediaQuery.sizeOf(context).width,
                child: Column(
                  children: [
                    Expanded(
                      child: CupertinoPicker(
                        scrollController:
                            widget.countryStatePickerVM.countryPickerController,
                        itemExtent: widget.pickerItemExtent!,
                        onSelectedItemChanged: (int index) {
                          if (widget.countryStatePickerVM.isAnimating) {
                            return;
                          }
                          widget.onCountryChanged(
                            widget.countryStatePickerVM.changeSelectedCountry(
                              index,
                              widget.onStateChanged,
                            ),
                          );
                          widget.updateParent();
                        },
                        selectionOverlay:
                            widget.pickerSelectedOverlay ??
                            CupertinoPickerDefaultSelectionOverlay(),
                        children: List<Widget>.generate(
                          widget.countryStatePickerVM.countries.length,
                          (int index) {
                            return Center(
                              child: Text(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                widget.countryStatePickerVM.countries[index],
                                style:
                                    widget.pickerTextStyle ??
                                    Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(fontSize: 16),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    widget.countryStatePickerVM.disposeCountryPicker();
    _pickerDeBouncer.dispose();
    super.dispose();
  }
}
