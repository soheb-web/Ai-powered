// import 'package:ai_powered_app/screen/matrimony.screen/message.page.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../data/providers/profileGetDataProvider.dart';
// import '../../data/providers/sentInterestToAnother.dart';
// import '../../data/providers/userDetailProvider.dart';
//
// class PartnerPreferencePage extends ConsumerStatefulWidget {
//   final String? targetUserId;
//
//   const PartnerPreferencePage(this.targetUserId,{super.key});
//   @override
//   ConsumerState<PartnerPreferencePage> createState() =>
//       _PartnerPreferencePageState();
// }
//
// class _PartnerPreferencePageState extends ConsumerState<PartnerPreferencePage> {
//   bool isLoading = false;
//   List<String> imageNames = [
//     "assets/1.png",
//     "assets/2.png",
//     "assets/photo.png",
//     "assets/female2.png",
//   ];
//
//
//   @override
//   Widget build(BuildContext context) {
//     final userAsyncValue = ref.watch(targetUserDetailsProvider(widget.targetUserId ?? ""));
//
//     return Scaffold(
//       backgroundColor: Color(0xFFFDF6F8),
//       appBar: AppBar(backgroundColor: Color(0xFFFDF6F8)),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 20.h),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Stack(
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(30.r),
//                     child: Image.asset(
//                       "assets/particularimage.png",
//                       width: 392.w,
//                       height: 396.h,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(30.r),
//                     child: Image.asset(
//                       "assets/femalebgimage.png",
//                       width: 392.w,
//                       height: 396.h,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 25.h),
//               Text(
//                 "Bio",
//                 style: GoogleFonts.gothicA1(
//                   fontSize: 20.sp,
//                   fontWeight: FontWeight.w500,
//                   color: Color(0xFF030016),
//                   letterSpacing: -0.7,
//                 ),
//               ),
//               SizedBox(height: 15.h),
//               Text(
//                 "Hello! I’m Ananya Panday, a vibrant soul from Maharashtra, India. I have a deep love for art and culture, and I enjoy exploring the rich heritage of my surroundings. By profession, I’m a digital marketer, where I create engaging content that connects people. In my free time, you’ll find me practicing yoga, experimenting with new recipes, or enjoying a quiet evening with a captivating novel. I cherish meaningful conversations, weekend getaways, and the joy of discovering new places.",
//                 style: GoogleFonts.gothicA1(
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.w500,
//                   color: Color(0xFF878599),
//                   letterSpacing: -0.7,
//                 ),
//               ),
//               SizedBox(height: 25.h),
//               Text(
//                 "My interest ",
//                 style: GoogleFonts.gothicA1(
//                   fontSize: 20.sp,
//                   fontWeight: FontWeight.w500,
//                   color: Color(0xFF030016),
//                   letterSpacing: -0.7,
//                 ),
//               ),
//               SizedBox(height: 15.h),
//               FilterChip(
//                 backgroundColor: Color(0xFFF2D4DC),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15.r),
//                   side: BorderSide(color: Colors.transparent),
//                 ),
//                 label: Text(
//                   "Music",
//                   style: GoogleFonts.gothicA1(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w400,
//                     color: Color(0xFF030016),
//                   ),
//                 ),
//                 onSelected: (value) {},
//               ),
//               SizedBox(height: 15.h),
//               Text(
//                 "Photo",
//                 style: GoogleFonts.gothicA1(
//                   fontSize: 20.sp,
//                   fontWeight: FontWeight.w500,
//                   color: Color(0xFF030016),
//                   letterSpacing: -0.7,
//                 ),
//               ),
//               SizedBox(height: 15.h),
//
//               GridView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 padding: EdgeInsets.zero,
//                 itemCount: imageNames.length,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 10.w,
//                   mainAxisSpacing: 10.w,
//                 ),
//                 itemBuilder: (context, index) {
//                   return Column(
//                     children: [
//                       Container(
//                         width: 186.w,
//                         height: 190.h,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(15.r),
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(15.r),
//                           child: Image.asset(
//                             imageNames[index],
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//
//               SizedBox(height: 100.h),
//             ],
//           ),
//         ),
//       ),
//       bottomSheet: Padding(
//         padding: EdgeInsets.only(bottom: 10.h, top: 6.h),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             GestureDetector(
//               onTap: () async {
//                 if (widget.targetUserId == null) {
//                   Fluttertoast.showToast(msg: "Invalid target user ID");
//                   return;
//                 }
//
//                 setState(() => isLoading = true); // Show loader
//
//                 try {
//                   await ref.read(
//                     sentInterestProvider({
//                       "target_user_id": widget.targetUserId!,
//                     }).future,
//                   );
//                   // Optionally do something after success
//                 } catch (e) {
//                   Fluttertoast.showToast(msg: "Error: $e");
//                 } finally {
//                   setState(() => isLoading = false); // Hide loader
//                 }
//               },
//
//               child: Container(
//                 width: 160.w,
//                 height: 74.h,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF97144d),
//                   borderRadius: BorderRadius.circular(20.r),
//                   boxShadow: [
//                     BoxShadow(
//                       offset: const Offset(0, -6),
//                       blurRadius: 40,
//                       spreadRadius: 0,
//                       color: const Color.fromARGB(63, 0, 0, 0),
//                     ),
//                   ],
//                 ),
//                 child: Center(
//                   child:
//                       isLoading
//                           ? const SizedBox(
//                             height: 24,
//                             width: 24,
//                             child: CircularProgressIndicator(
//                               color: Colors.white,
//                               strokeWidth: 2.5,
//                             ),
//                           )
//                           : const Icon(
//                             Icons.favorite_border,
//                             color: Colors.white,
//                           ),
//                 ),
//               ),
//             ),
//             SizedBox(width: 20.w),
//
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   CupertinoPageRoute(builder: (context) => MessagePage()),
//                 );
//               },
//               child: Container(
//                 width: 160.w,
//                 height: 74.h,
//                 decoration: BoxDecoration(
//                   color: Color(0xFFF2D4DC),
//                   borderRadius: BorderRadius.circular(20.r),
//                   boxShadow: [
//                     BoxShadow(
//                       offset: Offset(0, -6),
//                       blurRadius: 40,
//                       spreadRadius: 0,
//                       color: Color.fromARGB(63, 0, 0, 0),
//                     ),
//                   ],
//                 ),
//                 child: Center(
//                   child: Icon(Icons.chat, color: Color(0xFF97144d)),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:ai_powered_app/screen/matrimony.screen/message.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../../data/providers/sentInterestToAnother.dart';
import '../../data/providers/userDetailProvider.dart';

class PartnerPreferencePage extends ConsumerStatefulWidget {
  final String? targetUserId;

  const PartnerPreferencePage(this.targetUserId, {super.key});

  @override
  ConsumerState<PartnerPreferencePage> createState() =>
      _PartnerPreferencePageState();
}

class _PartnerPreferencePageState extends ConsumerState<PartnerPreferencePage> {
  int currentIndex = 0;

  bool isLoading = false;
  String _formatInterest(String? interest) {
    if (interest == null || interest.isEmpty) return "Not specified";

    try {
      final List<dynamic> parsedList = json.decode(interest);

      final capitalized =
          parsedList
              .map((e) => e.toString().trim())
              .map(
                (word) =>
                    word.isNotEmpty
                        ? word[0].toUpperCase() + word.substring(1)
                        : '',
              )
              .toList();

      return capitalized.join(', ');
    } catch (e) {
      return interest;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(
      targetUserDetailsProvider(widget.targetUserId ?? ""),
    );
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F8),

      appBar: AppBar(backgroundColor: const Color(0xFFFDF6F8)),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 20.h),
          child: userAsyncValue.when(
            data: (profile) {
              // Extract photos from profile.data.photos
              List<String> photos =
                  profile.data.photos
                      .where((photo) => photo is String)
                      .cast<String>()
                      .toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display the first photo from photos list above Bio
                  InkWell(
                    onTap: () {
                      int currentIndex =
                          0; // since you’re showing only one image here
                      final PageController controller = PageController(
                        initialPage: currentIndex,
                      );

                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            insetPadding: EdgeInsets.zero,
                            child: StatefulBuilder(
                              builder: (context, setState) {
                                return Stack(
                                  children: [
                                    PhotoViewGallery.builder(
                                      itemCount: photos.length,
                                      pageController: controller, // ✅ important
                                      backgroundDecoration: const BoxDecoration(
                                        color: Colors.black,
                                      ),
                                      builder: (context, i) {
                                        return PhotoViewGalleryPageOptions(
                                          imageProvider: NetworkImage(
                                            photos[i], // ✅ show the actual photo
                                          ),
                                          minScale:
                                              PhotoViewComputedScale.contained,
                                          maxScale:
                                              PhotoViewComputedScale.covered *
                                              3,
                                          heroAttributes:
                                              PhotoViewHeroAttributes(
                                                tag: photos[i],
                                              ),
                                        );
                                      },
                                      onPageChanged: (i) {
                                        setState(() {
                                          currentIndex = i;
                                        });
                                      },
                                    ),
                                    Positioned(
                                      top: 10,
                                      left: 10,
                                      right: 10,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 28,
                                            ),
                                            onPressed:
                                                () => Navigator.pop(context),
                                          ),
                                          Text(
                                            "${currentIndex + 1} / ${photos.length}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(width: 48.w),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.r),
                      child:
                          photos.isNotEmpty
                              ? Image.network(
                                photos[0],
                                width: 392.w,
                                height: 396.h,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) => Image.asset(
                                      'assets/start.png', // Fallback placeholder image
                                      width: 392.w,
                                      height: 396.h,
                                      fit: BoxFit.cover,
                                    ),
                              )
                              : Image.asset(
                                'assets/start.png', // Fallback if no photos
                                width: 392.w,
                                height: 396.h,
                                fit: BoxFit.cover,
                              ),
                    ),
                  ),
                  SizedBox(height: 25.h),
                  Text(
                    "Bio",
                    style: GoogleFonts.gothicA1(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF030016),
                      letterSpacing: -0.7,
                    ),
                  ),

                  SizedBox(height: 15.h),

                  /* Text(
                    profile.data.profile.bio ??
                        "Hello! I’m Ananya Panday, a vibrant soul from Maharashtra, India. I have a deep love for art and culture, and I enjoy exploring the rich heritage of my surroundings. By profession, I’m a digital marketer, where I create engaging content that connects people. In my free time, you’ll find me practicing yoga, experimenting with new recipes, or enjoying a quiet evening with a captivating novel. I cherish meaningful conversations, weekend getaways, and the joy of discovering new places.",
                    style: GoogleFonts.gothicA1(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF878599),
                      letterSpacing: -0.7,
                    ),
                  ),*/
                  Text(
                    "Hello! I’m ${profile.data.profile.name ?? 'User'}, a vibrant soul from ${profile.data.profile.city ?? 'Unknown City'}, ${profile.data.profile.country ?? 'Unknown Country'}.",
                    style: GoogleFonts.gothicA1(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF878599),
                      letterSpacing: -0.7,
                    ),
                  ),
                  SizedBox(height: 25.h),

                  Text(
                    "My Interest",
                    style: GoogleFonts.gothicA1(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF030016),
                      letterSpacing: -0.7,
                    ),
                  ),

                  SizedBox(height: 15.h),

                  // FilterChip(
                  //   backgroundColor: const Color(0xFFF2D4DC),
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(15.r),
                  //     side: const BorderSide(color: Colors.transparent),
                  //   ),
                  //   label:
                  //   Text(
                  //     profile.data.profile.interest ?? "Music",
                  //     style: GoogleFonts.gothicA1(
                  //       fontSize: 16.sp,
                  //       fontWeight: FontWeight.w400,
                  //       color: const Color(0xFF030016),
                  //     ),
                  //   ),
                  //   onSelected: (value) {},
                  // ),
                  /*  Text(
                    _formatInterest(profile.data.profile.interest),
                    style: GoogleFonts.gothicA1(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF030016),
                    ),
                  ),*/
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      _formatInterest(profile.data.profile.interest),
                      style: GoogleFonts.gothicA1(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF030016),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Text(
                    "Photo",
                    style: GoogleFonts.gothicA1(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF030016),
                      letterSpacing: -0.7,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  // GridView to show all photos
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: photos.isNotEmpty ? photos.length : 1,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.w,
                      mainAxisSpacing: 10.w,
                    ),
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              int currentIndex =
                                  index; // start with tapped image
                              final PageController controller = PageController(
                                initialPage: index,
                              );

                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    insetPadding: EdgeInsets.zero,
                                    child: StatefulBuilder(
                                      builder: (context, setState) {
                                        return Stack(
                                          children: [
                                            PhotoViewGallery.builder(
                                              itemCount: photos.length,
                                              pageController:
                                                  controller, // ✅ important
                                              backgroundDecoration:
                                                  const BoxDecoration(
                                                    color: Colors.black,
                                                  ),
                                              builder: (context, i) {
                                                return PhotoViewGalleryPageOptions(
                                                  imageProvider: NetworkImage(
                                                    photos[i],
                                                  ),
                                                  minScale:
                                                      PhotoViewComputedScale
                                                          .contained,
                                                  maxScale:
                                                      PhotoViewComputedScale
                                                          .covered *
                                                      3,
                                                  heroAttributes:
                                                      PhotoViewHeroAttributes(
                                                        tag: photos[i],
                                                      ),
                                                );
                                              },
                                              onPageChanged: (i) {
                                                setState(() {
                                                  currentIndex = i;
                                                });
                                              },
                                            ),
                                            Positioned(
                                              top: 10,
                                              left: 10,
                                              right: 10,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                      size: 28,
                                                    ),
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                        ),
                                                  ),
                                                  Text(
                                                    "${currentIndex + 1} / ${photos.length}",
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  SizedBox(width: 48.w),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                              ;
                            },
                            child: Container(
                              width: 186.w,
                              height: 190.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.r),
                                child:
                                    photos.isNotEmpty
                                        ? Image.network(
                                          photos[index],
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Image.asset(
                                                    'assets/start.png',
                                                    fit: BoxFit.cover,
                                                  ),
                                        )
                                        : Image.asset(
                                          'assets/start.png',
                                          fit: BoxFit.cover,
                                        ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 100.h),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error:
                (error, stack) => Center(
                  child: Text(
                    "Error loading profile: $error",
                    style: GoogleFonts.gothicA1(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF878599),
                    ),
                  ),
                ),
          ),
        ),
      ),

      bottomSheet: Padding(
        padding: EdgeInsets.only(bottom: 10.h, top: 6.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                if (widget.targetUserId == null) {
                  Fluttertoast.showToast(msg: "Invalid target user ID");
                  return;
                }

                setState(() => isLoading = true);

                try {
                  await ref.read(
                    sentInterestProvider({
                      "target_user_id": widget.targetUserId!,
                    }).future,
                  );
                  Fluttertoast.showToast(msg: "Interest sent successfully");
                } catch (e) {
                  Fluttertoast.showToast(msg: "Error: $e");
                } finally {
                  setState(() => isLoading = false);
                }
              },
              child: Container(
                width: 160.w,
                height: 74.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF97144d),
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(0, -6),
                      blurRadius: 40,
                      spreadRadius: 0,
                      color: Color.fromARGB(63, 0, 0, 0),
                    ),
                  ],
                ),
                child: Center(
                  child:
                      isLoading
                          ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                          : const Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                          ),
                ),
              ),
            ),
            SizedBox(width: 20.w),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => MessagePage()),
                );
              },
              child: Container(
                width: 160.w,
                height: 74.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2D4DC),
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(0, -6),
                      blurRadius: 40,
                      spreadRadius: 0,
                      color: Color.fromARGB(63, 0, 0, 0),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.chat, color: Color(0xFF97144d)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
