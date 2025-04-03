import 'package:flutter/material.dart';
import 'package:linyu_mobile/components/custom_material_button/index.dart';

class CustomLabelValueButton extends StatelessWidget {
  final String? label;
  final String? value;
  final double? width;
  final VoidCallback onTap;
  final int? maxLines;
  final Widget? child;
  final String hint;
  final Color? color;
  final bool compact;
  final bool? iconShowCenter;
  final GestureLongPressCallback? onLongPress;
  final GestureTapCallback? onDoubleTap;

  const CustomLabelValueButton({
    super.key,
    @Deprecated('Use child instead') this.label,
    required this.onTap,
    this.value,
    this.child,
    this.maxLines = 5,
    this.hint = '',
    this.width = 60,
    this.color,
    this.compact = true,
    this.iconShowCenter = false,
    this.onLongPress,
    this.onDoubleTap,
  });

  Widget _getContent() {
    if (null == child && (value == null || value!.trim().isEmpty)) {
      return Text(
        hint,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black38,
        ),
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
      );
    }
    return child ??
        Text(
          value!,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
        );
  }

  @override
  Widget build(BuildContext context) {
    return CustomMaterialButton(
      color: color,
      onTap: onTap,
      onLongPress: onLongPress,
      onDoubleTap: onDoubleTap,
      child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: iconShowCenter!
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (label != null)
                    SizedBox(
                      width: width,
                      child: Text(
                        label!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  if (compact)
                    Expanded(
                      child: _getContent(),
                    ),
                  Icon(
                    const IconData(0xe61f, fontFamily: 'IconFont'),
                    size: 16,
                    color: Colors.grey[700],
                  ),
                ],
              ),
              if (!compact) _getContent(),
            ],
          )),
    );
  }
}
