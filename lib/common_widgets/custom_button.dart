import 'package:assignment/common_widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.title,
    this.color,
    this.fontSize,
    this.fontWeight, this.cardColor,
  });

  final String title;
  final Color? color;
  final Color? cardColor;
  final double? fontSize;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: cardColor ?? Color(0xff4D4D4D),
      ),
      child: Center(
        child: CustomText(
          title: title,
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
        ),
      ),
    );
  }
}
