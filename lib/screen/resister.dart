import 'dart:developer';

import 'package:ai_powered_app/screen/login.page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../core/auth/login.auth.dart';
import 'dart:io';

class RegisterPage extends StatefulWidget {
  final String title;
  const RegisterPage({super.key, required this.title});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _paymentSuccess = false;
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _openCheckout() {
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag', // Test Key
      'amount': 50000, // ₹500 in paise
      'name': 'Test App',
      'description': 'Testing Payment',
      'prefill': {'contact': '9876543210', 'email': 'test@example.com'},
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      _paymentSuccess = true;
      Navigator.pop(context);
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("ERROR: ${response.code} | ${response.message}");
    Navigator.pop(context);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("EXTERNAL WALLET: ${response.walletName}");
    Navigator.pop(context);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  /////////////////////////////////////////////////////////////
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  bool _buttonLoader = false;
  String? listGender;
  String? listRole;
  final genderList = ["Male", "Female"];
  final roleList = ["Buyer", "Seller"];

  Future<void> _pickFile() async {
    // Pick a file (image or document) from the gallery
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx',
        'jpg',
        'jpeg',
        'png',
      ], // Allow both documents and images
    );
    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(
          pickedFile.files.single.path!,
        ); // Store the selected file
      });
    } else {
      // No file was picked
      print("No file selected");
    }
  }

  File? _selectedFile;

  Widget _getFilePreview(File file) {
    String fileExtension = file.path.split('.').last.toLowerCase();
    if (fileExtension == 'jpg' ||
        fileExtension == 'jpeg' ||
        fileExtension == 'png') {
      // It's an image, so show it as an image
      return Image.file(file, fit: BoxFit.cover, width: double.infinity);
    } else if (fileExtension == 'pdf') {
      // It's a PDF, show an icon or file name (as preview)
      return Center(
        child: Icon(Icons.picture_as_pdf, color: Colors.red, size: 50),
      );
    } else if (fileExtension == 'doc' || fileExtension == 'docx') {
      // It's a DOC file, show an icon or file name (as preview)
      return Center(
        child: Icon(Icons.insert_drive_file, color: Colors.blue, size: 50),
      );
    } else {
      // For unsupported file types, show the file name
      return Center(
        child: Text(
          "Selected file: ${file.path.split('/').last}",
          style: TextStyle(color: Colors.black),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = _getThemeColor(widget.title);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Register",
          style: GoogleFonts.gothicA1(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("Full Name"),

              _buildTextField(
                controller: nameController,
                hint: "Enter Your Name",
                label: "name",
                borderColor: themeColor,
              ),

              SizedBox(height: 15.h),

              _buildLabel("Email"),

              _buildTextField(
                controller: emailController,
                hint: "Enter Your Email",
                label: "email",
                keyboardType: TextInputType.emailAddress,
                borderColor: themeColor,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter email';
                  }
                  final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                  if (!emailRegex.hasMatch(value.trim())) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),

              SizedBox(height: 15.h),

              _buildLabel("Password"),

              _buildTextField(
                controller: passwordController,
                hint: "Enter Password",
                label: "password",
                obscure: true,
                borderColor: themeColor,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter password';
                  }
                  if (value.trim().length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),

              SizedBox(height: 15.h),
              _buildLabel("Phone"),

              _buildTextField(
                maxLength: 10,
                controller: phoneController,
                hint: "Enter Phone Number",
                label: "phone number",
                keyboardType: TextInputType.phone,
                borderColor: themeColor,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter phone number';
                  }
                  if (value.trim().length < 10) {
                    return 'Phone number must be at least 10 digits';
                  }
                  if (!RegExp(r'^\d+$').hasMatch(value.trim())) {
                    return 'Phone number must contain only digits';
                  }
                  return null;
                },
              ),

              SizedBox(height: 15.h),
              if (widget.title.toUpperCase() == "REAL ESTATE") ...[
                _buildLabel("Role"),
                BuildDropDown(
                  title: widget.title,
                  hint: "Role",
                  items: roleList,
                  onChange: (value) {
                    setState(() {
                      listRole = value;
                    });
                  },
                ),
                SizedBox(height: 15.h),
              ],
              SizedBox(height: 15.h),
              if (widget.title.toUpperCase() == "MATRIMONY") ...[
                _buildLabel("Age"),
                _buildTextField(
                  keyboardType: TextInputType.number,
                  controller: ageController,
                  hint: "Age",
                  label: "Age",
                  borderColor: themeColor,
                ),
                SizedBox(height: 15.h),

                _buildLabel("Gender"),
                BuildDropDown(
                  title: widget.title,
                  hint: "Select Gender",
                  items: genderList,
                  onChange: (value) {
                    setState(() {
                      listGender = value;
                    });
                  },
                ),

                SizedBox(height: 15.h),

                _buildLabel("Date of Birth"),

                buildDatePickerField(dobController, "Date of birth"),
                SizedBox(height: 30.h),
              ],

              if (widget.title.toUpperCase() == "JOBS") ...[
                _buildLabel("Upload Resume (Pdf, Doc, Docx, jpg, jpeg, png)"),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: _pickFile, // Changed to pickFile
                  child: Container(
                    width: double.infinity,
                    height: 150.h,
                    decoration: BoxDecoration(
                      border: Border.all(color: themeColor, width: 1.5.w),
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child:
                        _selectedFile == null
                            ? Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.file_upload_outlined,
                                    color: Colors.grey,
                                    size: 35.sp,
                                  ),
                                  Text(
                                    "Upload Document",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            )
                            : ClipRRect(
                              borderRadius: BorderRadius.circular(15.r),
                              child:
                                  _selectedFile is File
                                      ? _getFilePreview(
                                        _selectedFile!,
                                      ) // Use a helper method to display the file preview
                                      : Center(
                                        child: Text(
                                          "Selected file: ${_selectedFile?.path.split('/').last}",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                            ),
                  ),
                ),
                SizedBox(height: 15.h),
              ],

              GestureDetector(
                onTap: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    setState(() => _buttonLoader = true);
                    try {
                      if (widget.title.toUpperCase() == "JOBS") {
                        if (_selectedFile == null) {
                          // If no file is selected, show an error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Please select a resume (Image or Document)",
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return; // Exit the method to prevent further execution
                        }
                        await Auth.registerJobSeeker(
                          name: nameController.text.trim(),
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          phone: phoneController.text.trim(),
                          resumeFile: _selectedFile!, // This is a File object
                          context: context,
                          onSuccess: () {
                            // _openCheckout();
                          },
                        );

                        // Navigation already handled in Auth.registerJobSeeker
                      } else if (widget.title.toUpperCase() == "REAL ESTATE") {
                        await Auth.registerRealState(
                          nameController.text.trim(),
                          emailController.text.trim(),
                          passwordController.text.trim(),
                          phoneController.text.trim(),
                          listRole == "Seller" ? "agent" : "buyer",
                          context,
                        );
                      } else {
                        await Auth.register(
                          emailController.text,
                          passwordController.text,
                          nameController.text,
                          phoneController.text,
                          ageController.text,
                          listGender!.toLowerCase().toString(),
                          dobController.text,
                          context,
                        );
                      }
                    } catch (e, st) {
                      log("${e.toString()} /n ${st.toString()}");
                    } finally {
                      if (mounted) setState(() => _buttonLoader = false);
                    }
                  }
                },
                child: Center(
                  child: Container(
                    width: double.infinity,
                    height: 53.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: themeColor,
                    ),
                    child: Center(
                      child:
                          _buttonLoader
                              ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : Text(
                                'Register',
                                style: GoogleFonts.gothicA1(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /*  Text(
                      "Already have Account? Login ",
                      style: GoogleFonts.gothicA1(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),*/
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Already have Account? ",
                            style: GoogleFonts.gothicA1(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color:
                                  Colors
                                      .black, // Color for "Already have Account?"
                            ),
                          ),
                          TextSpan(
                            text: "Login",
                            style: GoogleFonts.gothicA1(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: _getThemeColor(widget.title),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required Color borderColor,
    String? hint,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    OutlineInputBorder customBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15.r),
      borderSide: BorderSide(color: borderColor, width: 1.5.w),
    );
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      maxLength: maxLength,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        hintText: hint,
        hintStyle: GoogleFonts.gothicA1(color: Colors.grey, fontSize: 14.sp),
        enabledBorder: customBorder,
        focusedBorder: customBorder,
        errorBorder: customBorder,
        focusedErrorBorder: customBorder,
        disabledBorder: customBorder,
        counterText: '', // hide character counter
      ),
      validator:
          validator ??
          (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter $label';
            }
            return null;
          },
    );
  }

  Color _getThemeColor(String title) {
    switch (title.toUpperCase()) {
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

  /*

  Widget buildDatePickerField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      readOnly: true, // Prevent manual typing
      decoration: InputDecoration(

        hintText: hint,
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
        border: OutlineInputBorder(

          borderRadius: BorderRadius.circular(12.r),
        ),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900), // Only allow dates after today
          lastDate: DateTime(2100),
        );

        if (pickedDate != null) {
          // Format date to e.g. 2025-06-30
          final formattedDate = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
          controller.text = formattedDate;
        }
      },
    );
  }*/

  Widget buildDatePickerField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      readOnly: true, // Prevent manual typing
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
        suffixIcon: const Icon(Icons.calendar_today),

        // Border when not focused
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: _getThemeColor(widget.title),
            width: 1.5,
          ),
        ),

        // Border when focused
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: _getThemeColor(widget.title),
            width: 2.0,
          ),
        ),

        // Optional: default border for consistency
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: _getThemeColor(widget.title)),
        ),
      ),
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );

        if (pickedDate != null) {
          final formattedDate =
              "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
          controller.text = formattedDate;
        }
      },
    );
  }
}

class BuildDropDown extends StatelessWidget {
  final String hint;
  final String title;
  final List<String> items;
  final String? value;
  final Function(String?) onChange;
  const BuildDropDown({
    super.key,
    required this.title,
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
          borderSide: BorderSide(color: _getThemeColor(title), width: 2.w),
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

  Color _getThemeColor(String title) {
    switch (title.toUpperCase()) {
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
}
