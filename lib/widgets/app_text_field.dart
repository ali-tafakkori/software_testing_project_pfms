import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextFieldController {
  late final TextEditingController controller;

  late final FocusNode focusNode;

  AppTextFieldController({
    TextEditingController? controller,
    String? text,
    String? debugLabel,
    bool skipTraversal = false,
    bool canRequestFocus = true,
    bool descendantsAreFocusable = true,
  }) {
    this.controller = controller ?? TextEditingController(text: text);
    focusNode = FocusNode(
      debugLabel: debugLabel,
      skipTraversal: skipTraversal,
      canRequestFocus: canRequestFocus,
      descendantsAreFocusable: descendantsAreFocusable,
    );
  }

  void requestFocus(BuildContext context) {
    FocusScope.of(context).children.forEach((FocusNode f) {
      f.unfocus();
    });
    FocusScope.of(context).requestFocus(focusNode);
  }

  String get text => controller.text;

  set text(String s) => controller.text = s;

  void clear() => controller.clear();

  void dispose() {
    controller.dispose();
    focusNode.dispose();
  }
}

class AppTextField extends StatefulWidget {
  final double width;
  final double? height;
  final AppTextFieldController controller;
  final String? hintText;
  final bool obscure;
  final TextInputType inputType;
  final int maxLines;
  final int? maxLength;
  final Color textColor;
  final Color hintColor;
  final Color borderColor;
  final double borderWith;
  final Color focusedBorderColor;
  final bool noBorder;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final VoidCallback? onEditingComplete;
  final bool readOnly;
  final Color cursorColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? suffix;
  final bool showCursor;
  final double? fontSize;
  final double borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final TextDirection? textDirection;
  final bool? enabled;

  const AppTextField({super.key,
    this.width = 250,
    this.height,
    required this.controller,
    this.hintText,
    required this.inputType,
    this.obscure = false,
    this.maxLines = 1,
    this.maxLength,
    this.textColor = Colors.black,
    this.hintColor = Colors.black26,
    this.borderColor = Colors.black,
    this.focusedBorderColor = Colors.black,
    this.noBorder = false,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.cursorColor = Colors.black,
    this.prefixIcon,
    this.suffixIcon,
    this.showCursor = true,
    this.fontSize,
    this.borderWith = 5,
    this.borderRadius = 10,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 16),
    this.textDirection,
    this.onEditingComplete,
    this.suffix,
    this.enabled,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: TextFormField(
        enabled: widget.enabled,
        onEditingComplete: widget.onEditingComplete,
        textDirection: widget.textDirection,
        cursorColor: widget.cursorColor,
        controller: widget.controller.controller,
        focusNode: widget.controller.focusNode,
        keyboardType: widget.inputType,
        readOnly: widget.readOnly,
        onChanged: widget.onChanged,
        onTap: widget.onTap,
        inputFormatters: [
          if (widget.maxLength != null)
            LengthLimitingTextInputFormatter(widget.maxLength),
        ],
        autofocus: false,
        obscureText: widget.obscure,
        maxLines: widget.maxLines,
        style: TextStyle(
          color: widget.textColor,
          fontSize: widget.fontSize,
        ),
        decoration: InputDecoration(
          fillColor: Colors.transparent,
          filled: true,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: widget.hintColor),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.suffixIcon,
          suffix: widget.suffix,
          border: widget.noBorder ? InputBorder.none : null,
          enabledBorder: widget.noBorder ? InputBorder.none : null,
          focusedBorder: widget.noBorder ? InputBorder.none : null,
          contentPadding: widget.contentPadding,
        ),
      ),
    );
  }
}
