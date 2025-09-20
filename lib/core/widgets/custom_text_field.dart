import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int? maxLines;
  final bool enabled;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.enabled = true,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscured = true;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: Get.theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Get.theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8),
        Focus(
          onFocusChange: (hasFocus) {
            setState(() {
              _isFocused = hasFocus;
            });
          },
          child: TextFormField(
            controller: widget.controller,
            obscureText: _isObscured && widget.obscureText,
            keyboardType: widget.keyboardType,
            validator: widget.validator,
            onChanged: widget.onChanged,
            maxLines: widget.maxLines,
            enabled: widget.enabled,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: Get.theme.colorScheme.onSurface.withOpacity(0.5),
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(
                      widget.prefixIcon,
                      color: _isFocused
                          ? Get.theme.primaryColor
                          : Get.theme.colorScheme.onSurface.withOpacity(0.5),
                    )
                  : null,
              suffixIcon: widget.obscureText
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                      icon: Icon(
                        _isObscured ? Icons.visibility_off : Icons.visibility,
                        color: Get.theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                    )
                  : widget.suffixIcon != null
                      ? IconButton(
                          onPressed: widget.onSuffixTap,
                          icon: Icon(
                            widget.suffixIcon,
                            color: Get.theme.colorScheme.onSurface
                                .withOpacity(0.5),
                          ),
                        )
                      : null,
              filled: true,
              fillColor: Get.theme.colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Get.theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Get.theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Get.theme.primaryColor,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Get.theme.colorScheme.error,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Get.theme.colorScheme.error,
                  width: 2,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Get.theme.colorScheme.outline.withOpacity(0.1),
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: widget.maxLines == 1 ? 16 : 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
