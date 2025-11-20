import 'dart:async';
import 'package:flutter/material.dart';

class DescriptionField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onValidate;

  const DescriptionField({
    super.key,
    required this.controller,
    required this.onValidate,
  });

  @override
  State<DescriptionField> createState() => _DescriptionFieldState();
}

class _DescriptionFieldState extends State<DescriptionField> {
  late final ValueNotifier<int> _wordCount;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _wordCount = ValueNotifier(_initialCount(widget.controller.text));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _wordCount.dispose();
    super.dispose();
  }

  // -------------------------------------------------------
  // MÉTODOS
  // -------------------------------------------------------
  static int _initialCount(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return 0;
    return trimmed.split(RegExp(r"\s+")).length;
  }

  int _countWords(String text) {
    if (text.trim().isEmpty) return 0;
    return text.trim().split(RegExp(r'\s+')).length;
  }

  void _onTextChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 90), () {
      final count = _countWords(value);

      if (_wordCount.value != count) {
        _wordCount.value = count;
      }

      widget.onValidate(); // 👈 ahora usa widget.onValidate
    });
  }

  // -------------------------------------------------------
  // UI
  // -------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    const labelColor = Color(0xFF2C2C2C);
    const borderColor = Color(0xFFE1E1E1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Descripción",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: labelColor,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor),
          ),
          child: Stack(
            children: [
              TextField(
                controller: widget.controller,
                maxLines: 5,
                onChanged: _onTextChanged,
                decoration: const InputDecoration(
                  hintText: "Describe claramente lo que ocurrió...",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(16, 14, 16, 28),
                ),
                style: const TextStyle(fontSize: 15, color: labelColor),
              ),
              Positioned(
                bottom: 8,
                right: 12,
                child: ValueListenableBuilder<int>(
                  valueListenable: _wordCount,
                  builder: (_, count, __) {
                    final limit = count >= 310;
                    return Text(
                      "$count/310",
                      style: TextStyle(
                        fontSize: 13,
                        color: limit ? Colors.redAccent : Colors.grey.shade600,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
