import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final bool readOnly;
  final TextEditingController controller;
  final TextStyle? hintStyle;

  final String hintText;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final TextInputType? type;

  CustomTextField({
    Key? key,
    this.readOnly = false,
    required this.controller,
    this.hintStyle,
    required this.hintText,
    this.obscureText=false,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.type = TextInputType.text,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscuretext = true;

  InputBorder buildFocusBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(20),
    ),
    borderSide: BorderSide(
      color: Colors.green,
      width: 1.5,
    ),
  );

  InputBorder buildBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
  );

  InputBorder buildenabled = const OutlineInputBorder(
    borderSide: BorderSide(
      width: 1.5,
      color: Colors.blue,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: widget.readOnly,
      validator: widget.validator,
      keyboardType: widget.type,
      obscureText: widget.obscureText&&_obscuretext,
      textAlignVertical: TextAlignVertical.top,
      maxLines: widget.maxLines,
      controller: widget.controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        suffixIcon: widget.obscureText
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _obscuretext= !_obscuretext;
                  });
                },
                icon: Icon(
                    _obscuretext ? Icons.visibility_off : Icons.visibility),
              )
            : widget.suffixIcon,
        prefixIcon: widget.prefixIcon,
        errorMaxLines: 10,
        errorStyle: const TextStyle(
          overflow: TextOverflow.clip,
        ),
        hintText: widget.hintText,
        hintStyle: widget.hintStyle,
        alignLabelWithHint: true,
        focusedBorder: buildFocusBorder,
        border: buildBorder,
        enabledBorder: buildenabled,
      ),
    );
  }
}
