import 'package:flutter/material.dart';
import 'package:multi_screen_app_with_navigation/core/utils/responsive.dart';

class CustomTextfield extends StatelessWidget {
  final bool isFieldPassword;

  /// Quand `isFieldPassword` est vrai : `true` masque le texte saisi.
  final bool obscureText;
  final String hintTextValue;
  final void Function()? onPressedFunction;
  final FontWeight fontWeight;
  final double radius;
  final String labelText;
  final double spacing;
  final String? Function(String? value)? validatorFunction;
  final void Function(String? value)? onSavedFunction;
  final TextEditingController? controller;

  const CustomTextfield({
    super.key,
    this.isFieldPassword = false,
    this.obscureText = false,
    required this.hintTextValue,
    this.onPressedFunction,
    required this.fontWeight,
    required this.radius,
    required this.labelText,
    required this.spacing,
    this.validatorFunction,
    this.onSavedFunction,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: spacing,
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontSize: context.bodyFontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextFormField(
          controller: controller,
          validator: validatorFunction,
          onSaved: onSavedFunction,
          obscureText: isFieldPassword ? obscureText : false,
          style: TextStyle(fontSize: context.bodyFontSize),
          decoration: InputDecoration(
            hintText: hintTextValue,
            suffixIcon: (!isFieldPassword)
                ? null
                : IconButton(
                    onPressed: onPressedFunction,
                    icon: (obscureText)
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
                  ),
            hintStyle: TextStyle(
              fontWeight: fontWeight,
              fontSize: context.bodyFontSize,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
        ),
      ],
    );
  }
}
