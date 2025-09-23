

import 'dart:io';
import 'package:ai_powered_app/data/models/PropertyDetailModel.dart' hide Image;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart' hide Image;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/providers/profileGetDataProvider.dart';
import '../../data/providers/uploadFile.dart';
import 'location.lifeStyle.page.dart';

final propertyImageProvider = StateProvider<List<File>>((ref) => []);
final propertyImageUrlsProvider = StateProvider<List<String>>((ref) => []);

class UploadPhotoPage extends ConsumerStatefulWidget {
  const UploadPhotoPage({super.key});
  @override
  ConsumerState<UploadPhotoPage> createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends ConsumerState<UploadPhotoPage> {
  List<File> selectedFiles = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );
    if (result != null) {
      setState(() {
        selectedFiles.addAll(
          result.paths
              .where((path) => path != null)
              .map((path) => File(path!))
              .toList(),
        );
      });
      // Update provider
      ref.read(propertyImageProvider.notifier).state = selectedFiles;
    }
  }

  void removeFile(int index) {
    setState(() {
      selectedFiles.removeAt(index);
    });
    ref.read(propertyImageProvider.notifier).state = [...selectedFiles];
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileDataProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(backgroundColor: const Color(0xFFF5F5F5)),
      body:
          isLoading
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
                          // Assuming PropertyDetailModel has a 'photos' field similar to DetailModel
                          List<String> oldPhotos =
                              profile.data.photos
                                  .where((photo) => photo is String)
                                  .cast<String>()
                                  .toList() ??
                              [];
                          return oldPhotos.isNotEmpty
                              ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: oldPhotos.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 10.w,
                                          mainAxisSpacing: 10.h,
                                          childAspectRatio: 1,
                                        ),
                                    itemBuilder: (context, index) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                          color: Colors.grey[300],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                          child: Image.network(
                                            oldPhotos[index],
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Image.asset(
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
                              )
                              : const SizedBox.shrink();
                        },
                        loading:
                            () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                        error:
                            (error, stack) => Text(
                              "Error loading photos: $error",
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF030016),
                              ),
                            ),
                      ),
                      // Upload Button
                      GestureDetector(
                        onTap: pickFiles,
                        child: Container(
                          width: double.infinity,
                          height: 134.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            border: Border.all(
                              color: const Color(0xFFDADADA),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.file_upload_outlined,
                                size: 30.sp,
                                color: const Color(0xFFA95C68),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                "Upload your Photos",
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF9A97AE),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // GridView for newly selected files
                      if (selectedFiles.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10.h),
                            Text(
                              "Newly Uploaded Photos",
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
                              itemCount: selectedFiles.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 10.w,
                                    mainAxisSpacing: 10.h,
                                    childAspectRatio: 1,
                                  ),
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
                                        color: Colors.grey[300],
                                      ),
                                      child: ClipRect(
                                        // borderRadius: BorderRadius.circular(10.r),
                                        child: Image.file(
                                          selectedFiles[index],
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 5,
                                      right: 5,
                                      child: GestureDetector(
                                        onTap: () => removeFile(index),
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: Colors.black54,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.close,
                                            size: 20.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      SizedBox(height: 20.h),

                      // GestureDetector(
                      //   onTap: () async {
                      //     bool isProfileCreation = false;
                      //     bool hasExistingPhotos = false;
                      //     // Check if this is profile creation or update
                      //     profileAsync.whenData((profile) {
                      //       hasExistingPhotos = profile.data.photos?.isNotEmpty ?? false;
                      //       // Assume profile creation if no photos exist and no profile data
                      //       isProfileCreation = profile.data.photos == null || profile.data.photos!.isEmpty;
                      //     });
                      //
                      //     // Validation: Mandatory photo upload for profile creation
                      //     // if (selectedFiles.isEmpty) {
                      //     //   ScaffoldMessenger.of(context).showSnackBar(
                      //     //     const SnackBar(
                      //     //       content: Text('Please upload at least one photo for profile creation.'),
                      //     //       backgroundColor: Colors.redAccent,
                      //     //     ),
                      //     //   );
                      //     //   return;
                      //     // }
                      //
                      //     // Proceed with upload if there are new photos
                      //
                      //     if (hasExistingPhotos==false && selectedFiles.isEmpty) {
                      //       ScaffoldMessenger.of(context).showSnackBar(
                      //         const SnackBar(
                      //           content: Text("Please upload at least one photo for profile creation !"),
                      //         ),
                      //       );
                      //     }
                      //     else{
                      //       setState(() {
                      //         isLoading = true;
                      //       });
                      //
                      //       try {
                      //         await ref.read(uploadProfilePhotosProvider(selectedFiles).future);
                      //
                      //         ScaffoldMessenger.of(context).showSnackBar(
                      //           const SnackBar(
                      //             content: Text("Photos uploaded successfully!"),
                      //           ),
                      //         );
                      //       } catch (e) {
                      //         ScaffoldMessenger.of(context).showSnackBar(
                      //           SnackBar(content: Text("Upload failed: $e")),
                      //         );
                      //         setState(() {
                      //           isLoading = false;
                      //         });
                      //         return;
                      //       }
                      //
                      //     }
                      //
                      //     setState(() {
                      //       isLoading = false;
                      //     });
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => const LocationLifestylePage(),
                      //       ),
                      //     );
                      //   },
                      //   child: Container(
                      //     width: double.infinity,
                      //     height: 53.h,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(15.r),
                      //       color: const Color(0xFF97144d),
                      //     ),
                      //     child: Center(
                      //       child: isLoading
                      //
                      //           ? SizedBox(
                      //
                      //         width: 24.sp,
                      //         height: 24.sp,
                      //         child: const CircularProgressIndicator(
                      //           valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      //           strokeWidth: 2,
                      //         ),
                      //       )
                      //           : Text(
                      //         "Continue",
                      //         style: GoogleFonts.inter(
                      //           fontSize: 18.sp,
                      //           fontWeight: FontWeight.w500,
                      //           color: Colors.white,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      GestureDetector(
                        // onTap: () async {
                        //   setState(() {
                        //     isLoading = true;
                        //   });
                        //
                        //   bool isProfileCreation = false;
                        //   bool hasExistingPhotos = false;
                        //
                        //   final profileData = ref.read(profileDataProvider).maybeWhen(
                        //     data: (profile) {
                        //       hasExistingPhotos = profile.data.photos?.isNotEmpty ?? false;
                        //       isProfileCreation = !hasExistingPhotos;
                        //       return profile;
                        //     },
                        //     orElse: () => null,
                        //   );
                        //
                        //   // Validation: Require at least one photo if creating profile
                        //   if (isProfileCreation && selectedFiles.isEmpty) {
                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //       const SnackBar(
                        //         content: Text("Please upload at least one photo for profile creation!"),
                        //         backgroundColor: Colors.redAccent,
                        //       ),
                        //     );
                        //     setState(() {
                        //       isLoading = false;
                        //     });
                        //     return;
                        //   }
                        //
                        //   // Proceed with upload if needed
                        //   try {
                        //     if (selectedFiles.isNotEmpty) {
                        //       await ref.read(uploadProfilePhotosProvider(selectedFiles).future);
                        //
                        //       ScaffoldMessenger.of(context).showSnackBar(
                        //         const SnackBar(content: Text("Photos uploaded successfully!")),
                        //       );
                        //     }
                        //   } catch (e) {
                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //       SnackBar(content: Text("Upload failed: $e")),
                        //     );
                        //     setState(() {
                        //       isLoading = false;
                        //     });
                        //     return;
                        //   }
                        //
                        //   setState(() {
                        //     isLoading = false;
                        //   });
                        //
                        //   // Navigate after all processes are done
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => const LocationLifestylePage(),
                        //     ),
                        //   );
                        // },
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                          });

                          bool hasExistingPhotos = false;

                          ref.read(profileDataProvider).maybeWhen(
                            data: (profile) {
                              hasExistingPhotos = profile.data.photos?.isNotEmpty ?? false;
                            },
                            orElse: () => null,
                          );

                          // ✅ Unified validation: At least 1 image must exist
                          if (!hasExistingPhotos && selectedFiles.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please upload at least one photo before continuing!"),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                            setState(() {
                              isLoading = false;
                            });
                            return;
                          }

                          try {
                            // Upload only if new files are selected
                            if (selectedFiles.isNotEmpty) {
                              await ref.read(uploadProfilePhotosProvider(selectedFiles).future);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Photos uploaded successfully!")),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Upload failed: $e")),
                            );
                            setState(() {
                              isLoading = false;
                            });
                            return;
                          }

                          setState(() {
                            isLoading = false;
                          });

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LocationLifestylePage(),
                            ),
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
                  ),
                ),
              ),
    );
  }
}
