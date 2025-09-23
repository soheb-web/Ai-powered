//
//
// import 'dart:io';
// import 'package:ai_powered_app/screen/matrimony.screen/ProfileShow/profileGetLocation.dart';
// import 'package:flutter/cupertino.dart' hide Image;
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import '../../../data/providers/profileGetDataProvider.dart';
//
// final propertyImageProvider = StateProvider<List<File>>((ref) => []);
// final propertyImageUrlsProvider = StateProvider<List<String>>((ref) => []);
// class ProfileGetPhoto extends ConsumerStatefulWidget {
//   const ProfileGetPhoto({super.key});
//   @override
//   ConsumerState<ProfileGetPhoto> createState() => _ProfileGetPhotoState();
// }
// class _ProfileGetPhotoState extends ConsumerState<ProfileGetPhoto> {
//   bool isLoading = false;
//
//
//   @override
//   Widget build(BuildContext context) {
//     final profileAsync = ref.watch(profileDataProvider);
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       appBar: AppBar(backgroundColor: const Color(0xFFF5F5F5)),
//       body:
//       isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 24.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 20.h),
//               // Previously Uploaded Photos
//               profileAsync.when(
//                 data: (profile) {
//                   // Assuming PropertyDetailModel has a 'photos' field similar to DetailModel
//                   List<String> oldPhotos =
//                       profile.data.photos
//                           .where((photo) => photo is String)
//                           .cast<String>()
//                           .toList() ??
//                           [];
//                   final hasData = oldPhotos.isNotEmpty;
//                   return oldPhotos.isNotEmpty
//                       ? Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       if (hasData) ...[
//                       Text(
//                         "Previously Uploaded Photos",
//                         style: GoogleFonts.inter(
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.w500,
//                           color: const Color(0xFF030016),
//                         ),
//                       ),
//                       SizedBox(height: 10.h),
//                       GridView.builder(
//                         shrinkWrap: true,
//                         physics:
//                         const NeverScrollableScrollPhysics(),
//                         itemCount: oldPhotos.length,
//                         gridDelegate:
//                         SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 3,
//                           crossAxisSpacing: 10.w,
//                           mainAxisSpacing: 10.h,
//                           childAspectRatio: 1,
//                         ),
//                         itemBuilder: (context, index) {
//                           return Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(
//                                 10.r,
//                               ),
//                               color: Colors.grey[300],
//                             ),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(
//                                 10.r,
//                               ),
//                               child: Image.network(
//                                 oldPhotos[index],
//                                 fit: BoxFit.cover,
//                                 errorBuilder:
//                                     (context, error, stackTrace) =>
//                                     Image.asset(
//                                       'assets/placeholder.png',
//                                       fit: BoxFit.cover,
//                                     ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                       SizedBox(height: 20.h),
//                     ],
//                   )
//                       : const SizedBox.shrink();
//                 },
//                 loading:
//                     () => const Center(
//                   child: CircularProgressIndicator(),
//                 ),
//                 error:
//                     (error, stack) => Text(
//                   "Error loading photos: $error",
//                   style: GoogleFonts.inter(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w500,
//                     color: const Color(0xFF030016),
//                   ),
//                 ),
//               ),
//               // Upload Button
//
//               SizedBox(height: 20.h),
//
//
//               SizedBox(height: 20.h),
//
//               GestureDetector(
//                 onTap: () async {
// Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileGetLocation()));
//                 },
//                 child: Container(
//                   width: double.infinity,
//                   height: 53.h,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(15.r),
//                     color: const Color(0xFF97144d),
//                   ),
//                   child: Center(
//                     child: isLoading
//
//                         ? SizedBox(
//
//                       width: 24.sp,
//                       height: 24.sp,
//                       child: const CircularProgressIndicator(
//                         valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                         strokeWidth: 2,
//                       ),
//                     )
//                         : Text(
//                       "Continue",
//                       style: GoogleFonts.inter(
//                         fontSize: 18.sp,
//                         fontWeight: FontWeight.w500,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20.h),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'dart:io';
import 'package:ai_powered_app/screen/matrimony.screen/ProfileShow/profileGetLocation.dart';
import 'package:flutter/cupertino.dart' hide Image;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/providers/profileGetDataProvider.dart';
import 'basicDetail.dart';

final propertyImageProvider = StateProvider<List<File>>((ref) => []);
final propertyImageUrlsProvider = StateProvider<List<String>>((ref) => []);

class ProfileGetPhoto extends ConsumerStatefulWidget {
  const ProfileGetPhoto({super.key});

  @override
  ConsumerState<ProfileGetPhoto> createState() => _ProfileGetPhotoState();
}

class _ProfileGetPhotoState extends ConsumerState<ProfileGetPhoto> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileDataProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(backgroundColor: const Color(0xFFF5F5F5)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              // Previously Uploaded Photos
              profileAsync.when(
                data: (profile) {
                  // Filter valid photo URLs
                  List<String> oldPhotos = profile.data.photos
                      ?.where((photo) => photo is String && photo.isNotEmpty)
                      .cast<String>()
                      .toList() ??
                      [];
                  // Check if there is valid data
                  final hasData = oldPhotos.isNotEmpty;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Conditionally display photos section
                      if (hasData) ...[
                        Text(
                          "Previously Uploaded Photos",
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF030016),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: oldPhotos.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10.w,
                            mainAxisSpacing: 10.h,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                color: Colors.grey[300],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: Image.network(
                                  oldPhotos[index],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Image.asset(
                                    'assets/placeholder.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 20.h),
                      ],
                      // Show Continue button only if there is valid data
                      if (hasData) ...[
                        SizedBox(height: 20.h),
                        GestureDetector(
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProfileGetLocation()),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            height: 53.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              color: const Color(0xFF97144d),
                            ),
                            child: Center(
                              child: isLoading
                                  ? SizedBox(
                                width: 24.sp,
                                height: 24.sp,
                                child: const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  strokeWidth: 2,
                                ),
                              )
                                  : Text(
                                "Continue",
                                style: GoogleFonts.inter(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],


                      if (!hasData) ...[
                        SizedBox(height: 20.h),
                        GestureDetector(
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BasicDetail()),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            height: 53.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              color: const Color(0xFF97144d),
                            ),
                            child: Center(
                              child: isLoading
                                  ? SizedBox(
                                width: 24.sp,
                                height: 24.sp,
                                child: const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  strokeWidth: 2,
                                ),
                              )
                                  : Text(
                                "Update Profile",
                                style: GoogleFonts.inter(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],


                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Text(
                  "Error loading photos: $error",
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF030016),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}