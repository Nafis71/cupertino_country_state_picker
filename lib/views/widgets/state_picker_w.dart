import 'package:cupertino_country_state_picker/views/widgets/picker_seach_w.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../vm/country_state_picker_vm.dart';
import '../../vm/picker_debouncer.dart';

/// Renders State picker widget
class StatePicker extends StatefulWidget {
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
  const StatePicker({
    super.key,
    required this.showBottomSheetDragHandle,
    this.pickerSize,
    this.pickerItemExtent,
    required this.countryStatePickerVM,
    required this.onStateChanged,
    this.pickerSelectedOverlay,
    this.pickerTextStyle,
    required this.updateParent,
    this.pickerSearchIcon,
    this.pickerSearchInputDecoration,
  });

  @override
  State<StatePicker> createState() => _StatePickerState();
}

class _StatePickerState extends State<StatePicker> {
  final PickerDeBouncer _pickerDeBouncer = PickerDeBouncer(
    delay: Duration(milliseconds: 500),
  );

  @override
  void initState() {
    widget.countryStatePickerVM.initiateStatePickerController();
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
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              children: [
                (widget.countryStatePickerVM.states.isNotEmpty)
                    ? SizedBox(
                      height: widget.pickerSize ?? 250,
                      width: MediaQuery.sizeOf(context).width,
                      child: Column(
                        children: [
                          PickerSearch(
                            onChanged: (text) {
                              _pickerDeBouncer.call(() {
                                widget.countryStatePickerVM
                                    .setStateControllerPosition(
                                      searchedState: text,
                                    );
                              });
                            },
                            pickerSearchIcon: widget.pickerSearchIcon,
                            pickerSearchInputDecoration:
                                widget.pickerSearchInputDecoration,
                          ),
                          Expanded(
                            child: CupertinoPicker(
                              scrollController:
                                  widget
                                      .countryStatePickerVM
                                      .statePickerController,
                              itemExtent: widget.pickerItemExtent!,
                              onSelectedItemChanged: (int index) {
                                if (widget.countryStatePickerVM.isAnimating) {
                                  return;
                                }
                                widget.onStateChanged(
                                  widget.countryStatePickerVM
                                      .changeSelectedState(index),
                                );
                                widget.updateParent();
                              },
                              children: List<Widget>.generate(
                                widget.countryStatePickerVM.states.length,
                                (int index) {
                                  return Center(
                                    child: Text(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      widget.countryStatePickerVM.states[index],
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
                    )
                    : Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          textAlign: TextAlign.center,
                          "No states found for ${widget.countryStatePickerVM.selectedCountry}",
                          style: widget.pickerTextStyle,
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    widget.countryStatePickerVM.disposeStatePicker();
    _pickerDeBouncer.dispose();
    super.dispose();
  }
}
