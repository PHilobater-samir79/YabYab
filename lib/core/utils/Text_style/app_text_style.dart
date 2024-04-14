import 'package:flutter/material.dart';
import 'package:yabyab_app/core/utils/theme/app_colors.dart';

abstract class AppTextStyle {
  static const TextStyle styleRegularBlack30 = TextStyle(
      color: AppColors.blackColor,
      fontWeight: FontWeight.w700,
      fontSize: 30,
      fontFamily: 'Lora',
      height: 0);
  static const TextStyle styleRegularBlack20 = TextStyle(
      color: AppColors.blackColor,
      fontWeight: FontWeight.bold,
      fontSize: 20,
      fontFamily: 'Lora',
      height: 0);
  static const TextStyle styleRegularBlack16 = TextStyle(
      color: AppColors.blackColor,
      fontWeight: FontWeight.w500,
      fontSize: 16,
      fontFamily: 'Lora',
      height: 0);
  static const TextStyle styleRegularGreen16 = TextStyle(
      color: AppColors.darkGreenColor,
      fontWeight: FontWeight.w500,
      fontSize: 16,
      fontFamily: 'Lora',
      height: 0);


  static const TextStyle styleRegularGreen30 = TextStyle(
      color: AppColors.darkGreenColor,
      fontWeight: FontWeight.w700,
      fontSize: 30,
      fontFamily: 'Lora',
      height: 0);
  static const TextStyle styleRegularGrey20 = TextStyle(
      color: AppColors.greyColor,
      fontWeight: FontWeight.bold,
      fontSize: 20,
      fontFamily: 'Lora',
      height: 0);
}
