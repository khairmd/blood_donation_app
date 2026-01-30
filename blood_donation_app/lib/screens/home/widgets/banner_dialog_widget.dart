// import 'package:blood_donation_app/utilities/app_exports.dart';
// import 'package:blood_donation_app/widgets/custom_image_view.dart';
//
// class BannerDialogWidget extends StatelessWidget {
//   const BannerDialogWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       insetPadding: const EdgeInsets.symmetric(horizontal: 20),
//       shape: RoundedRectangleBorder(
//
//         borderRadius: BorderRadius.circular(20.0),
//         // side: BorderSide(color: AppColors.strokeColor, width: 2),
//       ),
//
//       clipBehavior: Clip.hardEdge,
//       backgroundColor: Colors.transparent,
//       child: Stack(
//         clipBehavior: Clip.none, // Allow close button to overflow if needed
//         children: [
//           SizedBox(
//             height: 470.h,
//             child: CustomImageView(imagePath: AppConstants.welcomeBannerImage, fit: BoxFit.fill),
//           ),
//           Positioned(
//             top: 14.h,
//             right: 14.h,
//             child: Material(
//               color: Colors.transparent,
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(30),
//                 onTap: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
//                   child: Icon(Icons.close, color: Colors.white, size: 20),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
