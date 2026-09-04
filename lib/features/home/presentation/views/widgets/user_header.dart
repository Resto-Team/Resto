import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:resto/core/localization/app_strings.dart';
import 'package:resto/core/theme/app_colors.dart';
import 'package:resto/core/widgets/custom_text.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({
    super.key,
    required this.userName,
    required this.userImage,
  });
  final String userName, userImage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomText(
                    text: context.strings.hello,
                    size: 20.sp,
                    weight: FontWeight.w600,
                    color: Colors.grey.shade400,
                    maxLines: 1,
                  ),
                  Flexible(
                    child: CustomText(
                      text: userName,
                      size: 20.sp,
                      weight: FontWeight.w600,
                      color: Colors.grey.shade400,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              Gap(8.h),
              SvgPicture.asset(
                'assets/vectors/resto_name.svg',
                width: 30.w,
                height: 30.h,
              ),
            ],
          ),
        ),
        Gap(12.w),
        GestureDetector(
          onTap: () async {},
          child: CircleAvatar(
            radius: 28.r,
            backgroundColor: AppColors.primaryColor,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(200.r),
              child: Image.network(
                userImage,
                fit: BoxFit.cover,
                cacheWidth: 100,
                errorBuilder: (context, err, builder) =>
                    Icon(Icons.person, color: Colors.white, size: 24.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
