import 'package:flutter/material.dart';
import 'package:yabyab_app/core/utils/Text_style/app_text_style.dart';
import 'package:yabyab_app/core/utils/theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function()? onTap ;
  final Color color ;

  const CustomButton({super.key, required this.text, this.onTap,required this.color});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width*.9,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.blackColor,width: 1)

          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: Center(
              child: Text(
                text,
                style: AppTextStyle.styleRegularBlack20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
