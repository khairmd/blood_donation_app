import '../utilities/app_exports.dart';

class CustomLoader extends StatelessWidget {
  final bool isTrue;
  final Widget child;
  final double? progress;
  final AlignmentGeometry? alignment;

  const CustomLoader({
    super.key,
    required this.isTrue,
    required this.child,
    this.progress,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    if (!isTrue) {
      return SizedBox(child: child);
    }
    return AbsorbPointer(
      absorbing: isTrue,
      child: Stack(
        fit: StackFit.expand, // Changed to expand to ensure children fill the space
        children: <Widget>[
          child, // Keep the child visible without blurring
          Center(
            // Center the loader
            child: RepaintBoundary(
              child: Container(
                height: 70,
                width: 70,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.transparent,
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                  shape: BoxShape.circle,
                ),
                child: CircularProgressIndicator(
                  strokeWidth: 8,
                  backgroundColor: Colors.transparent,
                  color: AppColors.secondary,
                  value: progress,
                  strokeCap: StrokeCap.round,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),
                ),
              ),
            ),
          ),
          Center(
            // Center the small circle avatar
            child: const CircleAvatar(radius: 1.5, backgroundColor: Colors.black),
          ),
        ],
      ),
    );
  }
}
