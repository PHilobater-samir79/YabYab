import 'package:flutter/material.dart';
import 'package:yabyab_app/core/utils/theme/app_colors.dart';

class CustomSocialMediaContainer extends StatelessWidget {
  final String image;
  final Function()? onTap ;

  const CustomSocialMediaContainer(
      {super.key, required this.image,this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: CircleAvatar(
           backgroundColor: AppColors.whiteColor,
          radius: 20,
          child: Image.asset(image),

        ),
      ),
    );
  }
}
