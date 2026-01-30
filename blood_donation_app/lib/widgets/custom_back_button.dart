import 'package:flutter/cupertino.dart';

import '../utilities/app_exports.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>Navigator.pop(context),
      child: Container(
        margin: EdgeInsets.only(left: 2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            CupertinoIcons.back,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
