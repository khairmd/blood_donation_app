import '../utilities/app_exports.dart';

class CustomIconButton extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;
  final Color? backGroundColor;

  const CustomIconButton({super.key, required this.icon, required this.onTap,this.backGroundColor=Colors.transparent});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        width: 52,
        decoration: BoxDecoration(
            color: backGroundColor,
            border: Border.all(color: Color(0xffC8C8C8)),
            borderRadius: BorderRadius.circular(7)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SvgPicture.asset(icon),
        ),
      ),
    );
  }
}
