/*


import 'package:ai_powered_app/data/models/PropertyDetailModel.dart';
import 'package:ai_powered_app/data/providers/propertiesProvider.dart';
import 'package:ai_powered_app/screen/realEstate/location.realEstate.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/providers/propertyDetail.dart';

final furnishingProvider = StateProvider<String?>((ref) => null);
final areaControllerProvider = Provider.autoDispose<TextEditingController>(
      (ref) => TextEditingController(),
);
final bathroomsControllerProvider = Provider.autoDispose<TextEditingController>(
      (ref) => TextEditingController(),
);
final bedroomsControllerProvider = Provider.autoDispose<TextEditingController>(
      (ref) => TextEditingController(),
);

class PropertyRealestateDetails extends ConsumerStatefulWidget {
  final int? propertyId;
  const PropertyRealestateDetails(this.propertyId, {super.key});

  @override
  ConsumerState<PropertyRealestateDetails> createState() => _PropertyRealestateDetailsState();
}

class _PropertyRealestateDetailsState extends ConsumerState<PropertyRealestateDetails> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.propertyId != null && widget.propertyId != -1) {
      _fetchAndSetPropertyData();
    }
  }

  void _fetchAndSetPropertyData() async {
    final propertyId = widget.propertyId;
    if (propertyId == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      final propertyDetail = await ref.read(propertyDetailProvider(propertyId).future);
      final property = propertyDetail.property;
      if (property != null) {
        ref.read(furnishingProvider.notifier).state = ["Fully Furnished", "Semi Furnished", "Unfurnished"].contains(property.furnishSuch)
            ? property.furnishSuch
            : null;
        ref.read(areaControllerProvider).text = (double.tryParse(property.area ?? '')?.toInt().toString()) ?? '';
        ref.read(bathroomsControllerProvider).text = property.bathrooms?.toString() ?? '';
        ref.read(bedroomsControllerProvider).text = property.bedrooms?.toString() ?? '';
      } else {
        Fluttertoast.showToast(
          msg: "No property data found",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.sp,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to load property details: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.sp,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final furnitureList = ["Fully Furnished", "Semi Furnished", "Unfurnished"];
    final bedroomsController = ref.watch(bedroomsControllerProvider);
    final bathroomsController = ref.watch(bathroomsControllerProvider);
    final areaController = ref.watch(areaControllerProvider);
    final furnishing = ref.watch(furnishingProvider);

    void validateAndNavigate() {
      if (furnishing == null) {
        Fluttertoast.showToast(
          msg: "Please select a furnishing type",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.sp,
        );
        return;
      }
      if (areaController.text.trim().isEmpty) {
        Fluttertoast.showToast(
          msg: "Please enter area",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.sp,
        );
        return;
      }
      if (bathroomsController.text.trim().isEmpty) {
        Fluttertoast.showToast(
          msg: "Please enter number of bathrooms",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.sp,
        );
        return;
      }
      if (bedroomsController.text.trim().isEmpty) {
        Fluttertoast.showToast(
          msg: "Please enter number of bedrooms",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.sp,
        );
        return;
      }

      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => LocationRealestatePage(widget.propertyId),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(backgroundColor: const Color(0xFFF5F5F5)),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 24.w, right: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Text(
                widget.propertyId != null && widget.propertyId != -1
                    ? "Update Property Details"
                    : "Property Details",
                style: GoogleFonts.inter(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF030016),
                  letterSpacing: -1.3,
                ),
              ),
              Text(
                widget.propertyId != null && widget.propertyId != -1
                    ? "Update details about your property"
                    : "Tell us about your property",
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF9A97AE),
                ),
              ),
              SizedBox(height: 15.h),
              _buildLabel("Furnishing"),
              SizedBox(height: 10.h),
              BuildDropDown(
                hint: "Select Furnishing",
                items: furnitureList,
                value: furnishing,
                onChange: (value) => ref.read(furnishingProvider.notifier).state = value,
              ),
              SizedBox(height: 15.h),
              _buildLabel("Area (sqft)"),
              SizedBox(height: 10.h),
              TextField(
                keyboardType: TextInputType.number,
                controller: areaController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide(color: const Color(0xFFDADADA), width: 1.5.w),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide(color: const Color(0xFF00796B), width: 2.w),
                  ),
                  hintText: "Enter Area (sqft)",
                  hintStyle: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF9A97AE),
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              _buildLabel("Bathrooms"),
              SizedBox(height: 10.h),
              TextField(
                keyboardType: TextInputType.number,
                controller: bathroomsController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide(color: const Color(0xFFDADADA), width: 1.5.w),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide(color: const Color(0xFF00796B), width: 2.w),
                  ),
                  hintText: "Enter Number of Bathrooms",
                  hintStyle: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF9A97AE),
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              _buildLabel("Bedrooms"),
              SizedBox(height: 10.h),
              TextField(
                keyboardType: TextInputType.number,
                controller: bedroomsController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide(color: const Color(0xFFDADADA), width: 1.5.w),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide(color: const Color(0xFF00796B), width: 2.w),
                  ),
                  hintText: "Enter Number of Bedrooms",
                  hintStyle: GoogleFonts.inter(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF9A97AE),
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              GestureDetector(
                onTap: validateAndNavigate,
                child: Container(
                  width: double.infinity,
                  height: 53.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: const Color(0xFF00796B),
                  ),
                  child: Center(
                    child: Text(
                      widget.propertyId != null && widget.propertyId != -1
                          ? "Update"
                          : "Continue",
                      style: GoogleFonts.inter(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.gothicA1(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF030016),
      ),
    );
  }
}

class BuildDropDown extends StatelessWidget {
  final String hint;
  final List<String> items;
  final String? value;
  final Function(String?) onChange;

  const BuildDropDown({
    super.key,
    required this.hint,
    required this.items,
    this.value,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      icon: const Icon(Icons.keyboard_arrow_down),
      value: value != null && items.contains(value) ? value : null,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: const Color(0xFFDADADA), width: 1.5.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: const Color(0xFF00796B), width: 2.w),
        ),
        hintText: value == null ? hint : null,
        hintStyle: GoogleFonts.inter(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF9A97AE),
          letterSpacing: -0.2,
        ),
      ),
      items: [
        DropdownMenuItem<String>(
          enabled: false,
          value: null,
          child: Text(
            hint,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF9A97AE),
              letterSpacing: -0.2,
            ),
          ),
        ),
        ...items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF1E1E1E),
                letterSpacing: -0.2,
              ),
            ),
          );
        }).toList(),
      ],
      onChanged: (newValue) {
        if (newValue != null) {
          onChange(newValue);
        }
      },
    );
  }
}*/

import 'package:ai_powered_app/data/models/PropertyDetailModel.dart';
import 'package:ai_powered_app/data/providers/propertiesProvider.dart';
import 'package:ai_powered_app/screen/realEstate/location.realEstate.page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/providers/propertyDetail.dart';

final furnishingProvider = StateProvider<String?>((ref) => null);
final areaControllerProvider = Provider.autoDispose<TextEditingController>(
  (ref) => TextEditingController(),
);
final bathroomsControllerProvider = Provider.autoDispose<TextEditingController>(
  (ref) => TextEditingController(),
);
final bedroomsControllerProvider = Provider.autoDispose<TextEditingController>(
  (ref) => TextEditingController(),
);

class PropertyRealestateDetails extends ConsumerStatefulWidget {
  final int? propertyId;
  const PropertyRealestateDetails(this.propertyId, {super.key});

  @override
  ConsumerState<PropertyRealestateDetails> createState() =>
      _PropertyRealestateDetailsState();
}

class _PropertyRealestateDetailsState
    extends ConsumerState<PropertyRealestateDetails> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.propertyId != null && widget.propertyId != -1) {
      _fetchAndSetPropertyData();
    }
  }

  void _fetchAndSetPropertyData() async {
    final propertyId = widget.propertyId;
    if (propertyId == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      final propertyDetail = await ref.read(
        propertyDetailProvider(propertyId).future,
      );
      final property = propertyDetail.property;
      if (property != null) {
        ref.read(furnishingProvider.notifier).state =
            [
                  "Fully Furnished",
                  "Semi Furnished",
                  "Unfurnished",
                ].contains(property.furnishSuch)
                ? property.furnishSuch
                : null;
        ref.read(areaControllerProvider).text =
            (double.tryParse(property.area ?? '')?.toInt().toString()) ?? '';
        ref.read(bathroomsControllerProvider).text =
            property.bathrooms?.toString() ?? '';
        ref.read(bedroomsControllerProvider).text =
            property.bedrooms?.toString() ?? '';
      } else {
        Fluttertoast.showToast(
          msg: "No property data found",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.sp,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to load property details: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.sp,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final furnitureList = ["Fully Furnished", "Semi Furnished", "Unfurnished"];
    final bedroomsController = ref.watch(bedroomsControllerProvider);
    final bathroomsController = ref.watch(bathroomsControllerProvider);
    final areaController = ref.watch(areaControllerProvider);
    final furnishing = ref.watch(furnishingProvider);
    final isUpdateMode = widget.propertyId != null && widget.propertyId != -1;

    void validateAndNavigate() {
      // Validate furnishing only in create mode
      if (furnishing == null && !isUpdateMode) {
        Fluttertoast.showToast(
          msg: "Please select a furnishing type",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.sp,
        );
        return;
      }
      // Validate area
      final area = double.tryParse(areaController.text.trim());
      if (areaController.text.trim().isEmpty || area == null || area <= 0) {
        Fluttertoast.showToast(
          msg: "Please enter a valid area",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.sp,
        );
        return;
      }
      // Validate bathrooms
      final bathrooms = int.tryParse(bathroomsController.text.trim());
      if (bathroomsController.text.trim().isEmpty ||
          bathrooms == null ||
          bathrooms <= 0) {
        Fluttertoast.showToast(
          msg: "Please enter a valid number of bathrooms",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.sp,
        );
        return;
      }
      // Validate bedrooms
      final bedrooms = int.tryParse(bedroomsController.text.trim());
      if (bedroomsController.text.trim().isEmpty ||
          bedrooms == null ||
          bedrooms <= 0) {
        Fluttertoast.showToast(
          msg: "Please enter a valid number of bedrooms",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.sp,
        );
        return;
      }

      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => LocationRealestatePage(widget.propertyId),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(backgroundColor: const Color(0xFFF5F5F5)),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 24.w, right: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      Text(
                        widget.propertyId != null && widget.propertyId != -1
                            ? "Update Property Details"
                            : "Property Details",
                        style: GoogleFonts.inter(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF030016),
                          letterSpacing: -1.3,
                        ),
                      ),
                      Text(
                        widget.propertyId != null && widget.propertyId != -1
                            ? "Update details about your property"
                            : "Tell us about your property",
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF9A97AE),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      _buildLabel("Furnishing"),
                      SizedBox(height: 10.h),
                      BuildDropDown(
                        hint: "Select Furnishing",
                        items: furnitureList,
                        value: furnishing,
                        onChange:
                            isUpdateMode
                                ? null
                                : (value) =>
                                    ref
                                        .read(furnishingProvider.notifier)
                                        .state = value,
                      ),
                      SizedBox(height: 15.h),
                      _buildLabel("Area (sqft)"),
                      SizedBox(height: 10.h),
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: areaController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 12.h,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(
                              color: const Color(0xFFDADADA),
                              width: 1.5.w,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(
                              color: const Color(0xFF00796B),
                              width: 2.w,
                            ),
                          ),
                          hintText: "Enter Area (sqft)",
                          hintStyle: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9A97AE),
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      _buildLabel("Bathrooms"),
                      SizedBox(height: 10.h),
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: bathroomsController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 12.h,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(
                              color: const Color(0xFFDADADA),
                              width: 1.5.w,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(
                              color: const Color(0xFF00796B),
                              width: 2.w,
                            ),
                          ),
                          hintText: "Enter Number of Bathrooms",
                          hintStyle: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9A97AE),
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      _buildLabel("Bedrooms"),
                      SizedBox(height: 10.h),
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: bedroomsController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 12.h,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(
                              color: const Color(0xFFDADADA),
                              width: 1.5.w,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide: BorderSide(
                              color: const Color(0xFF00796B),
                              width: 2.w,
                            ),
                          ),
                          hintText: "Enter Number of Bedrooms",
                          hintStyle: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF9A97AE),
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      GestureDetector(
                        onTap: validateAndNavigate,
                        child: Container(
                          width: double.infinity,
                          height: 53.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            color: const Color(0xFF00796B),
                          ),
                          child: Center(
                            child: Text(
                              widget.propertyId != null &&
                                      widget.propertyId != -1
                                  ? "Update"
                                  : "Continue",
                              style: GoogleFonts.inter(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.gothicA1(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF030016),
      ),
    );
  }
}

class BuildDropDown extends StatelessWidget {
  final String hint;
  final List<String> items;
  final String? value;
  final Function(String?)? onChange; // Made onChange nullable

  const BuildDropDown({
    super.key,
    required this.hint,
    required this.items,
    this.value,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      icon: const Icon(Icons.keyboard_arrow_down),
      value: value != null && items.contains(value) ? value : null,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: const Color(0xFFDADADA), width: 1.5.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: const Color(0xFF00796B), width: 2.w),
        ),
        hintText: value == null ? hint : null,
        hintStyle: GoogleFonts.inter(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF9A97AE),
          letterSpacing: -0.2,
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide(color: const Color(0xFFDADADA), width: 1.5.w),
        ),
      ),
      items: [
        DropdownMenuItem<String>(
          enabled: false,
          value: null,
          child: Text(
            hint,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF9A97AE),
              letterSpacing: -0.2,
            ),
          ),
        ),
        ...items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF1E1E1E),
                letterSpacing: -0.2,
              ),
            ),
          );
        }).toList(),
      ],
      onChanged: onChange, // Use nullable onChange
    );
  }
}
