import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/select_status_model.dart' as status_model;

///
class CountryStatePickerVM {
  final List<String> _countries = [];
  final List<String> _states = [];
  String _selectedCountry = "";
  String _selectedState = "";
  bool _isAnimating = false;
  dynamic _datasetResponse;
  late Duration _pickerAnimationDuration;
  late Curve _pickerAnimation;

  late FixedExtentScrollController _countryPickerController;
  late FixedExtentScrollController _statePickerController;

  /// initializes the view model
  Future<void> initialize({
    required Function setState,
    String? initialCountry,
    String? initialState,
    required Duration pickerAnimationDuration,
    required Curve pickerAnimation,
  }) async {
    _selectedCountry = initialCountry ?? "";
    _selectedState = initialState ?? "";
    _pickerAnimationDuration = pickerAnimationDuration;
    _pickerAnimation = pickerAnimation;
    await _getResponse();
    await _getCountry(setState);
  }

  /// Returns selected country
  get selectedCountry => _selectedCountry;

  /// Returns selected state
  get selectedState => _selectedState;

  /// Returns country picker scroll controller
  get countryPickerController => _countryPickerController;

  /// Return state picker scroll controller;
  get statePickerController => _statePickerController;

  /// Returns the value of whether the [_countryPickerController] or [_statePickerController] is currently in animation or not
  get isAnimating => _isAnimating;

  /// Return a list of pre-fetched countries
  get countries => _countries;

  /// Returns a list of pre-fetched states
  get states => _states;

  /// Initialize country Picker Controller;
  void initiateCountryPickerController() =>
      _countryPickerController = FixedExtentScrollController();

  /// Initialize statePicker Controller;
  void initiateStatePickerController() =>
      _statePickerController = FixedExtentScrollController();

  /// Finds pre-selected country or searched country and animate the controller to that particular country
  void setCountryControllerPosition({String searchedCountry = ""}) {
    try {
      String country =
          searchedCountry.isEmpty ? _selectedCountry : searchedCountry;
      int index = _countries.indexWhere(
        (c) => c.toLowerCase().contains(country.toLowerCase()),
      );
      if (index != -1) _moveController(index, true);
    } catch (exception) {
      if (kDebugMode) {
        debugPrint(exception.toString());
      }
      rethrow;
    }
  }

  /// finds pre-selected state or searched state and animate the controller to that particular country
  void setStateControllerPosition({String searchedState = ""}) {
    try {
      String state = searchedState.isEmpty ? _selectedState : searchedState;
      int index = _states.indexWhere(
        (s) => s.toLowerCase().contains(state.toLowerCase()),
      );
      if (index != -1) _moveController(index, false);
    } catch (exception) {
      if (kDebugMode) {
        debugPrint(exception.toString());
      }
      rethrow;
    }
  }

  void _moveController(int index, bool isCountry) {
    try {
      Future.delayed(Duration(milliseconds: 200), () async {
        _isAnimating = true;
        if (isCountry) {
          await _countryPickerController.animateToItem(
            index,
            duration: _pickerAnimationDuration,
            curve: _pickerAnimation,
          );
        } else {
          await _statePickerController.animateToItem(
            index,
            duration: _pickerAnimationDuration,
            curve: _pickerAnimation,
          );
        }
      }).whenComplete(() {
        _isAnimating = false;
      });
    } catch (exception) {
      if (kDebugMode) {
        debugPrint(exception.toString());
      }
    }
  }

  Future<void> _getResponse() async {
    try {
      var res = await rootBundle.loadString(
        'packages/cupertino_country_state_picker/assets/country.json',
      );
      _datasetResponse = jsonDecode(res);
    } catch (exception) {
      if (kDebugMode) {
        debugPrint(exception.toString());
      }
    }
  }

  Future<void> _getCountry(Function setState) async {
    try {
      _countries.clear();
      var responseList = _datasetResponse as List;
      for (var data in responseList) {
        var model = status_model.StatusModel();
        model.name = data['name'];
        model.emoji = data['emoji'];
        _countries.add("${model.emoji ?? ""} ${model.name ?? ""}");
      }
      setState();
    } catch (exception) {
      if (kDebugMode) {
        debugPrint(exception.toString());
      }
      rethrow;
    }
  }

  Future<void> _getStates(Function setState) async {
    try {
      _states.clear();
      for (var data in _datasetResponse) {
        var model = status_model.StatusModel.fromJson(data);
        if (model.name?.toLowerCase() == _selectedCountry.toLowerCase()) {
          _states.addAll(model.state?.map((state) => state.name ?? "") ?? []);
          break;
        }
      }
      setState();
    } catch (exception) {
      if (kDebugMode) {
        debugPrint(exception.toString());
      }
      rethrow;
    }
  }

  /// This callback initializes/store  the state/province and starts animating to the pre-selected state if any is given
  Future<void> initializeState(Function setState, String? initialState) async {
    if (_selectedCountry.isEmpty) {
      return;
    }
    await _getStates(setState);
    setStateControllerPosition();
  }

  /// Sets new selected country value, the [onStateChanged] parameter updates the ui with the recent selected country
  String changeSelectedCountry(int index, ValueChanged<String> onStateChanged) {
    try {
      _selectedState = "";
      onStateChanged(_selectedState);
      _selectedCountry = countries[index].split(" ").sublist(1).join(" ");
    } catch (exception) {
      if (kDebugMode) {
        debugPrint(exception.toString());
      }
    }
    return _selectedCountry;
  }

  /// Sets new selected state value and returns the most recent state
  String changeSelectedState(int index) {
    try {
      _selectedState = states[index].trim();
    } catch (exception) {
      if (kDebugMode) {
        debugPrint(exception.toString());
      }
    }
    return _selectedState;
  }

  /// Disposes the country picker scroll controller to prevent memory-leaks
  void disposeCountryPicker() {
    _countryPickerController.dispose();
  }

  /// Disposes the state picker scroll controller to prevent memory-leaks
  void disposeStatePicker() {
    _statePickerController.dispose();
  }
}
