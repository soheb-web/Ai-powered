import 'package:ai_powered_app/screen/login.page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Otpscreen extends StatefulWidget {
  final String colorTitle;
  final String phoneNumber;
  final String title;
   Otpscreen(  {
    super.key,
    required this.colorTitle,
    required this.phoneNumber,
    required this.title
  });

  @override
  State<Otpscreen> createState() => _OtpscreenState();
}

class _OtpscreenState extends State<Otpscreen> {
  final List<TextEditingController> _otpControllers =
  List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }
  void _submitOtp() async {
    if (_isLoading) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP functionality is enabled. Please log in with your email.'),
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) =>  LoginPage(widget.colorTitle)),
            (route) => route.isFirst,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
  Color _getButtonColor() {
    switch (widget.colorTitle.toUpperCase()) {
      case "MATRIMONY":
        return const Color(0xFF97144d);
      case "JOBS":
        return const Color(0xFF0A66C2);
      case "REAL ESTATE":
        return const Color(0xFF00796B);
      default:
        return const Color(0xFF97144d);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50.h),
                Text(
                  "Verify OTP",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.gothicA1(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF030016),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Enter the 4-digit OTP sent to +91${widget.phoneNumber}",
                  style: GoogleFonts.gothicA1(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 30.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(4, (index) {
                    return SizedBox(
                      width: 60.w,
                      child: TextFormField(
                        controller: _otpControllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: GoogleFonts.gothicA1(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          contentPadding:
                          EdgeInsets.symmetric(vertical: 16.h),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide:
                            BorderSide(color: _getButtonColor(), width: 1.5.w),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide:
                            BorderSide(color: _getButtonColor(), width: 1.5.w),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide:
                             BorderSide(color:_getButtonColor(), width: 1.5),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide:
                             BorderSide(color: _getButtonColor(), width: 1.5),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '';
                          }
                          if (!RegExp(r'^\d$').hasMatch(value)) {
                            return '';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (value.length == 1 && index < 3) {
                            _focusNodes[index].unfocus();
                            FocusScope.of(context)
                                .requestFocus(_focusNodes[index + 1]);
                          }
                          if (value.isEmpty && index > 0) {
                            _focusNodes[index].unfocus();
                            FocusScope.of(context)
                                .requestFocus(_focusNodes[index - 1]);
                          }
                        },
                      ),
                    );
                  }),
                ),
                SizedBox(height: 30.h),
                GestureDetector(
                  onTap: _submitOtp,
                  child: Center(
                    child: _isLoading
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF9A97AE)),
                      ),
                    )
                        : Container(
                      width: double.infinity,
                      height: 53.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        color: _getButtonColor(),
                      ),
                      child: Center(
                        child: Text(
                          'Verify OTP',
                          style: GoogleFonts.gothicA1(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Resend OTP not implemented yet')),
                      );
                    },
                    child: Text(
                      'Resend OTP',
                      style: GoogleFonts.gothicA1(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: _getButtonColor(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}


// Otpscreen.dart


//
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:hive/hive.dart';
//
// class Otpscreen extends StatefulWidget {
//   final String phoneNumber;
//   const Otpscreen({required this.phoneNumber, super.key});
//
//   @override
//   State<Otpscreen> createState() => _OtpscreenState();
// }
//
// class _OtpscreenState extends State<Otpscreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final TextEditingController _otpController = TextEditingController();
//   String _verificationId = '';
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _sendOtp();
//   }
//
//   Future<void> _sendOtp() async {
//     setState(() => _isLoading = true);
//     await _auth.verifyPhoneNumber(
//       phoneNumber: '+91${widget.phoneNumber}',
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         await _signIn(credential);
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         _showToast(e.message ?? 'Failed');
//       },
//       codeSent: (String verificationId, int? resendToken) {
//         _verificationId = verificationId;
//         _showToast('OTP Sent!');
//         setState(() => _isLoading = false);
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {},
//     );
//   }
//
//   Future<void> _verifyOtp() async {
//     final otp = _otpController.text.trim();
//     if (otp.isEmpty) return _showToast('Enter OTP');
//
//     final credential = PhoneAuthProvider.credential(
//       verificationId: _verificationId,
//       smsCode: otp,
//     );
//     await _signIn(credential);
//   }
//
//   Future<void> _signIn(PhoneAuthCredential credential) async {
//     try {
//       final userCredential = await _auth.signInWithCredential(credential);
//       final idToken = await userCredential.user?.getIdToken();
//
//       if (idToken != null) {
//         // Send to Laravel
//         await _sendToLaravel(idToken);
//       }
//     } catch (e) {
//       _showToast('Invalid OTP');
//     }
//   }
//
//   Future<void> _sendToLaravel(String idToken) async {
//     // Call your Laravel /auth/firebase-login
//     // Save token in Hive → Go to Home
//     final box = await Hive.openBox('userdata');
//     await box.put('token', 'from_laravel_token_here');
//     Navigator.pushReplacementNamed(context, '/home');
//   }
//
//   void _showToast(String msg) {
//     Fluttertoast.showToast(msg: msg);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Verify OTP')),
//       body: Padding(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           children: [
//             Text('OTP sent to +91${widget.phoneNumber}'),
//             TextField(controller: _otpController, keyboardType: TextInputType.number),
//             ElevatedButton(
//               onPressed: _isLoading ? null : _verifyOtp,
//               child: _isLoading ? CircularProgressIndicator() : Text('Verify'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }