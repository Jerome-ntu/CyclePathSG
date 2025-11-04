import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  final String label;
  final String text;
  final ValueChanged<String> onChanged;
  final bool isPassword; // if true, obscures text
  final bool isEditable; // if false, unable to edit

  const TextFieldWidget({
    Key? key,
    required this.label,
    required this.text,
    required this.onChanged,
    this.isPassword = false,
    this.isEditable = true,
  }) : super(key: key);

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late final TextEditingController controller;
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.text);
    _obscureText = widget.isPassword;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        widget.label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          enabled: widget.isEditable,
          controller: controller,
          onChanged: widget.onChanged,
          obscureText: _obscureText,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            enabledBorder: OutlineInputBorder(
              borderSide:
              BorderSide(color: Colors.grey.shade300, width: 1.2),
              borderRadius: BorderRadius.circular(14),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
              const BorderSide(color: Colors.green, width: 1.6),
              borderRadius: BorderRadius.circular(14),
            ),
            filled: true,
            fillColor: Colors.white,
            hintText: 'Enter ${widget.label.toLowerCase()}',
            hintStyle: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 15,
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
              icon: Icon(
                _obscureText
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: Colors.grey.shade600,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ) : null,
          ),
        ),
      ),
    ],
  );
}
