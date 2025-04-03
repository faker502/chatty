import 'package:flutter/material.dart';
import 'package:linyu_mobile/utils/getx_config/config.dart';

class CustomSearchBox extends StatelessThemeWidget {
  final bool isCentered;
  final Color backgroundColor;
  final double borderRadius;
  final ValueChanged<String> onChanged;
  final double? height;
  final String? hintText;
  final Widget? prefix;
  final TextEditingController? textEditingController;
  final FocusNode? focusNode;

  const CustomSearchBox({
    super.key,
    this.isCentered = false,
    this.backgroundColor = const Color(0xFFE3ECFF),
    this.borderRadius = 10.0,
    required this.onChanged,
    this.height = 40,
    this.hintText = "搜索",
    this.prefix,
    this.textEditingController,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    Color iconColor = theme.primaryColor;
    return Container(
      alignment: isCentered ? Alignment.center : Alignment.centerLeft,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: theme.searchBarColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        mainAxisAlignment:
        isCentered ? MainAxisAlignment.center : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          prefix ??
              Icon(const IconData(0xe669, fontFamily: 'IconFont'),
                  size: 20, color: iconColor),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              focusNode: focusNode,
              controller: textEditingController,
              onChanged: onChanged,
              textAlign: isCentered ? TextAlign.center : TextAlign.start,
              style: TextStyle(color: iconColor, fontSize: 16),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(0),
                hintText: hintText,
                hintStyle: TextStyle(
                    color: iconColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent, width: 1),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent, width: 1),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent, width: 1),
                ),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
