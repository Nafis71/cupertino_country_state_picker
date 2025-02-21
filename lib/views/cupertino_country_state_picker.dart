import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/select_status_model.dart' as status_model;

class _CupertinoCountryStatePicker extends StatefulWidget {
  final ValueChanged<String> onCountryChanged;
  final ValueChanged<String> onStateChanged;
  final Color? bottomSheetColor, borderColor, backgroundColor;
  final double? bottomSheetBorderRadius, pickerItemExtent, pickerSize, horizontalSpace, borderRadius;
  final bool showBottomSheetDragHandle;
  final String? pickedCountryValue;
  final TextStyle? pickedValueTextStyle;
  final TextStyle? pickerTextStyle, labelTextStyle;
  final EdgeInsets? padding;
  final String? initialCountry;
  final String? initialState;
  final Widget? pickerSelectedOverlay;

  const _CupertinoCountryStatePicker({
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
    this.pickedCountryValue,
    this.horizontalSpace,
    this.labelTextStyle,
    this.padding,
    this.borderRadius,
    this.initialCountry,
    this.initialState, this.pickerSelectedOverlay,
  });

  @override
  State<_CupertinoCountryStatePicker> createState() => _CupertinoCountryStatePickerViewState();
}

class _CupertinoCountryStatePickerViewState extends State<_CupertinoCountryStatePicker> {
  final _CountryStatePickerVM countryStatePickerVM = _CountryStatePickerVM();

  @override
  void initState() {
    countryStatePickerVM.initialize(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildOutputField(
            callback: () {
              showCountryPicker();
            },
            headlineText: "Country",
            pickedValue:
                ((widget.initialCountry != null && widget.initialCountry!.isNotEmpty) && countryStatePickerVM.selectedCountry.isEmpty)
                    ? widget.initialCountry!
                    : countryStatePickerVM.selectedCountry.isNotEmpty
                    ? countryStatePickerVM.selectedCountry
                    : "Choose a country",
          ),
        ),
        SizedBox(width: widget.horizontalSpace ?? 8),
        Expanded(
          child: _buildOutputField(
            callback: () async {
              if (countryStatePickerVM.selectedCountry.isNotEmpty) {
                await countryStatePickerVM._initializeState(() {
                  setState(() {});
                });
                showStatePicker();
              }
            },
            headlineText: "State/Province",
            pickedValue:
                ((widget.initialState != null && widget.initialState!.isNotEmpty) && countryStatePickerVM.selectedCountry.isEmpty)
                    ? widget.initialState!
                    : countryStatePickerVM.selectedState.isNotEmpty
                    ? countryStatePickerVM.selectedState
                    : "Choose a state",
          ),
        ),
      ],
    );
  }

  Widget _buildOutputField({required GestureTapCallback callback, required String headlineText, required String pickedValue}) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        padding: widget.padding ?? const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 1),
          border: Border.all(color: widget.borderColor ?? const Color(0xFF86909B).withValues(alpha: 0.3), width: 1),
          color: widget.backgroundColor ?? Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(headlineText, style: widget.labelTextStyle ?? Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12, color: const Color(0xFF86909B))),
            const SizedBox(height: 5),
            Text(maxLines: 1, overflow: TextOverflow.ellipsis, pickedValue, style: widget.pickedValueTextStyle),
          ],
        ),
      ),
    );
  }

  showStatePicker() {
    showModalBottomSheet(
      useSafeArea: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.bottomSheetBorderRadius ?? 0)),
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            if (widget.showBottomSheetDragHandle)
              Center(
                child: Container(
                  height: 4,
                  width: 120,
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(color: const Color(0xFF86909B).withValues(alpha: 0.3), borderRadius: BorderRadius.circular(40)),
                ),
              ),
            (countryStatePickerVM.states.isNotEmpty)
                ? SizedBox(
                  height: widget.pickerSize ?? 250,
                  width: MediaQuery.sizeOf(context).width,
                  child: Column(
                    children: [
                      Expanded(
                        child: CupertinoPicker(
                          itemExtent: widget.pickerItemExtent!,
                          onSelectedItemChanged: (int index) {
                            widget.onStateChanged(countryStatePickerVM._getSelectedState(index));
                            setState(() {});
                          },
                          children: List<Widget>.generate(countryStatePickerVM.states.length, (int index) {
                            return Center(
                              child: Text(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                countryStatePickerVM.states[index],
                                style: widget.pickerTextStyle ?? Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 16),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                )
                : Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(child: Text(textAlign: TextAlign.center, "No states found for ${countryStatePickerVM.selectedCountry}", style: widget.pickerTextStyle)),
                ),
          ],
        );
      },
    );
  }

  showCountryPicker() {
    showModalBottomSheet(
      useSafeArea: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.bottomSheetBorderRadius ?? 0)),
      backgroundColor: widget.bottomSheetColor ?? Colors.white,
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            if (widget.showBottomSheetDragHandle)
              Center(
                child: Container(
                  height: 4,
                  width: 120,
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(color: const Color(0xFF86909B).withValues(alpha: 0.3), borderRadius: BorderRadius.circular(40)),
                ),
              ),
            SizedBox(
              height: widget.pickerSize ?? 250,
              width: MediaQuery.sizeOf(context).width,
              child: Column(
                children: [
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: widget.pickerItemExtent!,
                      onSelectedItemChanged: (int index) {
                        widget.onCountryChanged(countryStatePickerVM._getSelectedCountry(index, widget.onStateChanged));
                        setState(() {});
                      },
                      selectionOverlay: widget.pickerSelectedOverlay ?? CupertinoPickerDefaultSelectionOverlay(),
                      children: List<Widget>.generate(countryStatePickerVM.countries.length, (int index) {
                        return Center(
                          child: Text(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            countryStatePickerVM.countries[index],
                            style: widget.pickerTextStyle ?? Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 16),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class CupertinoCountryStatePicker extends StatelessWidget {
  final ValueChanged<String> onCountryChanged;
  final ValueChanged<String> onStateChanged;
  final Color? bottomSheetColor, borderColor, backgroundColor;
  final double? bottomSheetBorderRadius, pickerItemExtent, pickerSize, horizontalSpace, borderRadius;
  final bool showBottomSheetDragHandle;
  final String? pickedCountryValue;
  final TextStyle? pickedValueTextStyle;
  final TextStyle? pickerTextStyle, labelTextStyle;
  final EdgeInsets? padding;
  final String? initialCountry;
  final String? initialState;
  final Widget? pickerSelectedOverlay;

  final Widget pickerInstance;

  factory CupertinoCountryStatePicker({
    required ValueChanged<String> onCountryChanged,
    required ValueChanged<String> onStateChanged,
    Color? bottomSheetColor,
    double? bottomSheetBorderRadius,
    bool showBottomSheetDragHandle = true,
    Color? borderColor,
    Color? backgroundColor,
    TextStyle? pickedValueTextStyle,
    TextStyle? pickerTextStyle,
    double pickerItemExtent = 40.0,
    double? pickerSize,
    String? pickedCountryValue,
    String? pickedStateValue,
    double? horizontalSpace,
    TextStyle? labelTextStyle,
    EdgeInsets? padding,
    double? borderRadius,
    String? initialCountry,
    String? initialState,
    Widget? pickerSelectedOverlay,
  }) {
    return CupertinoCountryStatePicker._internal(
      pickerInstance: _CupertinoCountryStatePicker(
        onCountryChanged: onCountryChanged,
        onStateChanged: onStateChanged,
        bottomSheetColor: bottomSheetColor,
        bottomSheetBorderRadius: bottomSheetBorderRadius,
        showBottomSheetDragHandle: showBottomSheetDragHandle,
        borderColor: borderColor,
        backgroundColor: backgroundColor,
        pickedValueTextStyle: pickedValueTextStyle,
        pickerTextStyle: pickerTextStyle,
        pickerItemExtent: pickerItemExtent,
        pickerSize: pickerSize,
        pickedCountryValue: pickedCountryValue,
        horizontalSpace: horizontalSpace,
        labelTextStyle: labelTextStyle,
        padding: padding,
        borderRadius: borderRadius,
        initialCountry: initialCountry,
        initialState: initialState,
        pickerSelectedOverlay: pickerSelectedOverlay,
      ),
      onCountryChanged: onCountryChanged,
      onStateChanged: onStateChanged,
      bottomSheetColor: bottomSheetColor,
      bottomSheetBorderRadius: bottomSheetBorderRadius,
      showBottomSheetDragHandle: showBottomSheetDragHandle,
      borderColor: borderColor,
      backgroundColor: backgroundColor,
      pickedValueTextStyle: pickedValueTextStyle,
      pickerTextStyle: pickerTextStyle,
      pickerItemExtent: pickerItemExtent,
      pickerSize: pickerSize,
      pickedCountryValue: pickedCountryValue,
      pickerSelectedOverlay: pickerSelectedOverlay,
      horizontalSpace: horizontalSpace,
      labelTextStyle: labelTextStyle,
      padding: padding,
      borderRadius: borderRadius,
      initialCountry: initialCountry,
      initialState: initialState,
    );
  }

  const CupertinoCountryStatePicker._internal({
    required this.onCountryChanged,
    required this.onStateChanged,
    this.bottomSheetColor,
    this.bottomSheetBorderRadius,
    this.showBottomSheetDragHandle = true,
    this.borderColor,
    this.backgroundColor,
    this.pickedValueTextStyle,
    this.pickerTextStyle,
    this.pickerItemExtent = 40.0,
    this.pickerSize,
    this.pickedCountryValue,
    this.horizontalSpace,
    this.labelTextStyle,
    this.padding,
    this.borderRadius,
    this.initialCountry,
    this.initialState, required this.pickerInstance, this.pickerSelectedOverlay,
  });

  @override
  Widget build(BuildContext context) {
    return pickerInstance; // Delegating rendering to private instance
  }
}

class _CountryStatePickerVM {
  List<String> countries = [];
  List<String> states = [];
  String selectedCountry = "";
  String selectedState = "";
  dynamic datasetResponse;

  Future<void> initialize(Function postOperation) async {
    await _getResponse();
    await _getCountry(postOperation);
  }

  Future<void> _getResponse() async {
    var res = await rootBundle.loadString('packages/cupertino_country_state_picker/assets/country.json');
    datasetResponse = jsonDecode(res);
  }

  Future<void> _getCountry(Function postOperation) async {
    countries.clear();
    var responseList = datasetResponse as List;
    for (var data in responseList) {
      var model = status_model.StatusModel();
      model.name = data['name'];
      model.emoji = data['emoji'];
      // if (!mounted) continue;
      countries.add("${model.emoji!} ${model.name!}");
    }
    postOperation();
  }

  Future<void> _getStates(Function postOperation) async {
    states.clear();
    for (var data in datasetResponse) {
      var model = status_model.StatusModel.fromJson(data);
      if (model.name?.toLowerCase() == selectedCountry.toLowerCase()) {
        states.addAll(model.state?.map((state) => state.name ?? "") ?? []);
        break;
      }
    }
    postOperation();
  }

  Future<void> _initializeState(Function postOperation) async {
    if (selectedCountry.isEmpty) {
      return;
    }
    await _getStates(postOperation);
  }

  String _getSelectedCountry(int index, ValueChanged<String> onStateChanged) {
    selectedState = "";
    onStateChanged(selectedState);
    selectedCountry = countries[index].substring(4, countries[index].length).trim();
    return selectedCountry;
  }

  String _getSelectedState(int index) {
    selectedState = states[index].trim();
    return selectedState;
  }
}
