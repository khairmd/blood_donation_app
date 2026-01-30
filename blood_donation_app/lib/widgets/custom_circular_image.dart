

import '../utilities/app_exports.dart';

class ProfilePicture extends StatelessWidget {
  final String imageUrl;
  final double size;
  final String placeholderAsset;
  final String errorAsset;

  const ProfilePicture({
    super.key,
    required this.imageUrl,
    this.size = 50.0,
    this.placeholderAsset = '',
    this.errorAsset = '',
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: imageUrl.isNotEmpty
          ? Image.network(
              imageUrl,
              width: size,
              height: size,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return placeholderAsset.isNotEmpty
                    ? Image.asset(
                        placeholderAsset,
                        width: size,
                        height: size,
                        fit: BoxFit.cover,
                      )
                    : CircularProgressIndicator();
              },
              errorBuilder: (context, error, stackTrace) {
                return errorAsset.isNotEmpty
                    ? Image.asset(
                        errorAsset,
                        width: size,
                        height: size,
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.error,
                        size: size,
                      );
              },
            )
          : Image.asset(
              AppConstants.mail,
              height: size,
              width: size,
            ),
    );
  }
}
