import 'dart:async';
import 'package:flutter/material.dart';
import 'package:horoscopeguruapp/services/location_service.dart';
import 'package:horoscopeguruapp/theme/colors.dart';

class LocationSearchField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String? Function(String?)? validator;
  final bool enabled;
  final Function(String)? onLocationSelected;

  const LocationSearchField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.validator,
    this.enabled = true,
    this.onLocationSelected,
  }) : super(key: key);

  @override
  State<LocationSearchField> createState() => _LocationSearchFieldState();
}

class _LocationSearchFieldState extends State<LocationSearchField> {
  List<PlacePrediction> _predictions = [];
  bool _isLoading = false;
  OverlayEntry? _overlayEntry;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _debounceTimer?.cancel();
    _removeOverlay();
    super.dispose();
  }

  void _onTextChanged() {
    if (widget.controller.text.isEmpty) {
      _hidePredictions();
      return;
    }

    _debounceSearch();
  }

  void _debounceSearch() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _searchPlaces();
    });
  }

  Future<void> _searchPlaces() async {
    if (widget.controller.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final predictions =
          await LocationService.searchPlaces(widget.controller.text);
      setState(() {
        _predictions = predictions;
        _isLoading = false;
      });

      if (predictions.isNotEmpty) {
        _showPredictions();
      } else {
        _hidePredictions();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _hidePredictions();
    }
  }

  void _showPredictions() {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: _getFieldBottomPosition() + 2, // Reduced gap
        left: _getFieldLeftPosition(),
        right: _getFieldRightPosition(),
        child: Material(
          elevation: 8,
          child: Container(
            constraints: const BoxConstraints(maxHeight: 200), // Reduced height
            decoration: BoxDecoration(
              color: AppColors.primary,
              border: Border.all(color: AppColors.accent.withOpacity(0.3)),
            ),
            child: ClipRRect(
              // Clip content to prevent white edges
              borderRadius: BorderRadius.circular(8),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero, // Remove default padding
                itemCount: _predictions.length,
                itemBuilder: (context, index) {
                  final prediction = _predictions[index];
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.withOpacity(0.2),
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      title: Text(
                        LocationService.getFormattedAddress(prediction),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13, // Smaller font size
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        LocationService.getFullAddress(prediction),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 11, // Smaller font size
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        _selectLocation(prediction);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context)!.insert(_overlayEntry!);
  }

  void _hidePredictions() {
    _removeOverlay();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _selectLocation(PlacePrediction prediction) {
    final formattedAddress = LocationService.getFullAddress(prediction);
    widget.controller.text = formattedAddress;

    if (widget.onLocationSelected != null) {
      widget.onLocationSelected!(formattedAddress);
    }

    _hidePredictions();
    FocusScope.of(context).unfocus();
  }

  double _getFieldBottomPosition() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    return position.dy + renderBox.size.height;
  }

  double _getFieldLeftPosition() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    return position.dx;
  }

  double _getFieldRightPosition() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    return MediaQuery.of(context).size.width -
        position.dx -
        renderBox.size.width;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      enabled: widget.enabled,
      validator: widget.validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: TextStyle(
          color: Colors.white70,
          fontSize: 14,
        ),
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Colors.white30),
        border: InputBorder.none,
        suffixIcon: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
                  ),
                ),
              )
            : const Icon(
                Icons.search,
                color: AppColors.accent,
              ),
      ),
      onTap: () {
        if (widget.controller.text.isNotEmpty && _predictions.isNotEmpty) {
          _showPredictions();
        }
      },
    );
  }
}
