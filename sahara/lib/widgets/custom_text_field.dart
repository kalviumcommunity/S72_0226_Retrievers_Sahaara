import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

/// Custom TextField with consistent styling
class CustomTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final int maxLines;
  final int minLines;
  final int? maxLength;
  final bool obscureText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Widget? suffixIconWidget;
  final VoidCallback? onSuffixIconPressed;
  final bool readOnly;
  final TextAlign textAlign;
  final String? counterText;
  final bool showErrors;

  const CustomTextField({
    super.key,
    this.label,
    this.hint,
    this.initialValue,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.maxLines = 1,
    this.minLines = 1,
    this.maxLength,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.onChanged,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixIconWidget,
    this.onSuffixIconPressed,
    this.readOnly = false,
    this.textAlign = TextAlign.start,
    this.counterText,
    this.showErrors = true,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.initialValue,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      obscureText: _obscureText,
      readOnly: widget.readOnly,
      textAlign: widget.textAlign,
      validator: widget.showErrors ? widget.validator : null,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete,
      onFieldSubmitted: widget.onFieldSubmitted,
      style: AppTheme.bodyMedium,
      cursorColor: AppTheme.primaryColor,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        counterText: widget.counterText,
        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
                color: AppTheme.gray500,
              )
            : null,
        suffixIcon: widget.suffixIconWidget ??
            (widget.obscureText
                ? InkWell(
                    onTap: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    child: Icon(
                      _obscureText
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppTheme.gray500,
                    ),
                  )
                : widget.suffixIcon != null
                    ? InkWell(
                        onTap: widget.onSuffixIconPressed,
                        child: Icon(
                          widget.suffixIcon,
                          color: AppTheme.gray500,
                        ),
                      )
                    : null),
        contentPadding: const EdgeInsets.all(AppTheme.paddingSmall),
      ),
    );
  }
}

/// Custom multiline text field for longer text input
class CustomMultilineTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final int maxLines;
  final int minLines;
  final int? maxLength;
  final bool readOnly;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final String? counterText;

  const CustomMultilineTextField({
    super.key,
    this.label,
    this.hint,
    this.initialValue,
    this.maxLines = 4,
    this.minLines = 3,
    this.maxLength,
    this.readOnly = false,
    this.controller,
    this.validator,
    this.onChanged,
    this.counterText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      controller: controller,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      readOnly: readOnly,
      validator: validator,
      onChanged: onChanged,
      style: AppTheme.bodyMedium,
      cursorColor: AppTheme.primaryColor,
      textAlignVertical: TextAlignVertical.top,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        counterText: counterText,
        alignLabelWithHint: true,
        contentPadding: const EdgeInsets.all(AppTheme.paddingMedium),
      ),
    );
  }
}

/// Custom search text field
class CustomSearchTextField extends StatefulWidget {
  final String? hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClearPressed;
  final Color? backgroundColor;

  const CustomSearchTextField({
    super.key,
    this.hint = 'Search...',
    this.controller,
    this.onChanged,
    this.onClearPressed,
    this.backgroundColor,
  });

  @override
  State<CustomSearchTextField> createState() => _CustomSearchTextFieldState();
}

class _CustomSearchTextFieldState extends State<CustomSearchTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      style: AppTheme.bodyMedium,
      cursorColor: AppTheme.primaryColor,
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixIcon: const Icon(Icons.search, color: AppTheme.gray500),
        suffixIcon: widget.controller?.text.isNotEmpty ?? false
            ? InkWell(
                onTap: widget.onClearPressed,
                child: const Icon(Icons.close, color: AppTheme.gray500),
              )
            : null,
        filled: true,
        fillColor: widget.backgroundColor ?? AppTheme.gray100,
        border: OutlineInputBorder(
          borderRadius: AppTheme.borderRadiusExtraLarge,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppTheme.borderRadiusExtraLarge,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppTheme.borderRadiusExtraLarge,
          borderSide: const BorderSide(
            color: AppTheme.primaryColor,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTheme.paddingMedium,
          vertical: AppTheme.paddingSmall,
        ),
      ),
    );
  }
}
