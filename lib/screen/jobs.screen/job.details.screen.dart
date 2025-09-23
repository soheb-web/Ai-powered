import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import '../../data/providers/jobApply.dart';
import '../../data/providers/jobDetailProvider.dart';

class JobDetailsScreen extends ConsumerStatefulWidget {
  final dynamic jobId;
  const JobDetailsScreen(this.jobId, {super.key});

  @override
  ConsumerState<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends ConsumerState<JobDetailsScreen> {
  bool isLoading = false;
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final jobDetailAsync = ref.watch(jobDetailProvider(widget.jobId.toString()));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F8FA),
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 24.w,
              right: 24.w,
              top: 10.h,
              bottom: 100.h,
            ),
            child: jobDetailAsync.when(
              data: (jobDetail) {
                final job = jobDetail.data;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Vacancy Details",
                      style: GoogleFonts.alexandria(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF030016),
                        
                      ),
                    ),
                    SizedBox(height: 20.h),
                    _buildJobCard(job),
                    SizedBox(height: 30.h),
                    _sectionTitle("Job Description"),
                    _sectionContent(job.description ?? "No description available"),
                    SizedBox(height: 30.h),
                    _sectionTitle("Responsibilities"),
                    _buildRequirementsList(job.requirements),
                    SizedBox(height: 30.h),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Padding(
                padding: EdgeInsets.all(20.h),
                child: Text(
                  'Error: $e',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 30.h,
            left: 24.w,
            right: 24.w,
            child: _buildApplyButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(dynamic job) {
    return

      Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 40,
            spreadRadius: 0,
            color: Color.fromARGB(12, 10, 102, 194),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [


                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: const Color(0xFF0A66C2),
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/rajveer.png",
                      color: const Color(0xFFFFFFFF),
                    ),
                  ),
                ),
                  // ),
                // ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title ?? "Untitled Job",
                      style: GoogleFonts.alexandria(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1E1E1E),
                        
                      ),
                    ),
                    Text(
                      job.company ?? "Unknown Company",
                      style: GoogleFonts.alexandria(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF9A97AE),
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 15.h),
            _buildJobInfoRow(Icons.location_on_outlined, job.location ?? "Not specified"),
            SizedBox(height: 10.h),
            _buildJobInfoRow(
              Icons.currency_rupee, // Rupee icon
              job.salaryRange ?? (job.salaryMin != null && job.salaryMax != null
                  ? "₹${job.salaryMin} - ₹${job.salaryMax}"
                  : "Salary not specified"),
            ),
            SizedBox(height: 25.h),
            // Row(
            //   children: [
            //     _tag(job.employmentType ??""),
            //     // SizedBox(width: 10.w),
            //     // _tag(job.employmentType ?? "Not specified"),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: const Color(0xFF9A97AE)),
        SizedBox(width: 6.w),
        Text(
          text,
          style: GoogleFonts.alexandria(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF9A97AE),
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildRequirementsList(List<String>? requirements) {
    if (requirements == null || requirements.isEmpty) {
      return Text(
        "No requirements specified",
        style: GoogleFonts.alexandria(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF878599),
          letterSpacing: -0.1,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: requirements
          .asMap()
          .entries
          .map(
            (entry) => Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "• ",
                style: GoogleFonts.alexandria(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF878599),
                ),
              ),
              Expanded(
                child: Text(
                  entry.value,
                  style: GoogleFonts.alexandria(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF878599),
                    letterSpacing: -0.1,
                  ),
                ),
              ),
            ],
          ),
        ),
      )
          .toList(),
    );
  }

  Widget _buildApplyButton() {
    return GestureDetector(
      onTap: () async {
        final jobDetail = ref.read(jobDetailProvider(widget.jobId.toString()));
        final job = jobDetail.value?.data;

        if (job?.id == null) {
          Fluttertoast.showToast(msg: "Job details not loaded");
          return;
        }

        final box = await Hive.openBox('userdata');
        final userId = box.get('user_id');

        if (userId == null) {
          Fluttertoast.showToast(msg: "Please login to apply");
          return;
        }

        setState(() => isLoading = true);

        try {
          await ref.read(jobApplyProvider({
            "job_id": job!.id,
            "user_id": userId,
            "cover_letter": "I'm interested in this position"
          }).future);

          Fluttertoast.showToast(msg: "Application submitted!");
          Navigator.pop(context);
        } catch (e) {
          Fluttertoast.showToast(msg: "Failed to apply: ${e.toString()}");
        } finally {
          setState(() => isLoading = false);
        }
      },
      child: Container(
        width: double.infinity,
        height: 74.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: const Color(0xFF0A66C2),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 10,
              color: Color(0x40000000),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.5,
            ),
          )
              : Text(
            "Apply Now",
            style: GoogleFonts.alexandria(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _tag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      height: 28.h,
      decoration: BoxDecoration(
        color: const Color(0xFFE6EDF2),
        borderRadius: BorderRadius.circular(40.r),
      ),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.alexandria(
            fontSize: 11.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF1E1E1E),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.alexandria(
        fontSize: 20.sp,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF030016),
        
      ),
    );
  }

  Widget _sectionContent(String text) {
    return Text(
      text,
      style: GoogleFonts.alexandria(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF878599),
        letterSpacing: -0.1,
      ),
    );
  }
}