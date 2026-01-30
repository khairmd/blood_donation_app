import 'package:flutter/cupertino.dart'; // For CupertinoActivityIndicator
import '../utilities/app_exports.dart'; // For AppConstants, AppUrl

class CustomProfileImage extends StatelessWidget {
  final String? imageUrl;
  final double size; // Size for both width and height, and radius for CircleAvatar

  const CustomProfileImage({
    super.key,
    required this.imageUrl,
    this.size = 40.0, // Default size
  });

  @override
  Widget build(BuildContext context) {


    if (imageUrl.isNullOREmpty) {
      // If profile URL is null or empty, show the empty profile picture
      return CircleAvatar(
        radius: size / 2, // CircleAvatar uses radius
        backgroundImage: AssetImage(AppConstants.mail),
      );
    } else {
      // If profile URL exists, try to load the network image
      return ClipOval(
        child: Image.network(
          '$imageUrl', // Construct full URL
          width: size,
          height: size,
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child; // Image is fully loaded, show the image
            }
            // Show CupertinoActivityIndicator while loading
            return SizedBox(
              width: size,
              height: size,
              child: const Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          },
          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
            // If network image fails to load, show the empty profile picture
            return Image.asset(
              AppConstants.mail,
              width: size,
              height: size,
              fit: BoxFit.cover,
            );
          },
        ),
      );
    }
  }
}