// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../../core/constants/app_assets.dart';
// import '../../../core/constants/app_colors.dart';
// import '../../widgets/app_image.dart';
//
// class SpecialOffersBanner extends StatelessWidget {
//   final VoidCallback onTap;
//
//   const SpecialOffersBanner({super.key, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: const Color(0xFFEEEEEE)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.03),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           // Image / graphic
//           Image.asset(
//             AppAssets.offerBadge,
//             width: 60,
//             height: 60,
//             fit: BoxFit.contain,
//           ),
//           const SizedBox(width: 14),
//
//           // Details
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       'Special Offers',
//                       style: GoogleFonts.montserrat(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.textDark,
//                       ),
//                     ),
//                     const SizedBox(width: 6),
//                     const Text('😱', style: TextStyle(fontSize: 16)),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   'We make sure you get the\noffer you need at best prices',
//                   style: GoogleFonts.montserrat(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w400,
//                     color: AppColors.textMuted,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
