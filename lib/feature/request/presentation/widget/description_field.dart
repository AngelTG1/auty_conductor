import 'package:flutter/material.dart';

class DescriptionField extends StatefulWidget {
  final TextEditingController controller;
  final Function onValidate;

  const DescriptionField({
    super.key,
    required this.controller,
    required this.onValidate,
  });

  @override
  State<DescriptionField> createState() => _DescriptionFieldState();
}

class _DescriptionFieldState extends State<DescriptionField> {
  @override
  Widget build(BuildContext context) {
    int wordCount = widget.controller.text.trim().isEmpty
        ? 0
        : widget.controller.text.trim().split(RegExp(r'\s+')).length;

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        TextField(
          controller: widget.controller,
          maxLines: 5,
          onChanged: (value) {
            final words = value.trim().split(RegExp(r'\s+'));
            if (words.length > 310) {
              widget.controller.text = words.take(310).join(' ');
              widget.controller.selection = TextSelection.fromPosition(
                TextPosition(offset: widget.controller.text.length),
              );
            }
            setState(() {});
            widget.onValidate();
          },
          decoration: InputDecoration(
            hintText: 'Dinos los detalles del problema que tiene ahora mismo',
            hintStyle: const TextStyle(
              color: Color(0xFFA3A3A3),
              fontSize: 15,
            ),
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.fromLTRB(14, 1, 5, 20),
          ),
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
        Positioned(
          bottom: 8,
          right: 14,
          child: Text(
            "$wordCount/310",
            style: TextStyle(
              fontSize: 13,
              color: wordCount >= 310 ? Colors.redAccent : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
