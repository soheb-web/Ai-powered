import 'dart:developer';
import 'dart:io';
import 'package:ai_powered_app/screen/jobs.screen/basic.info.screen.dart';
import 'package:ai_powered_app/screen/login.page.dart';
import 'package:ai_powered_app/screen/matrimony.screen/home.page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http_parser/http_parser.dart';
import '../../data/models/employerResisterRequestModel.dart';
import '../../data/models/login.body.dart';
import '../../data/models/login.response.dart';
import '../../data/models/register.req.model.dart';
import '../../data/models/register.response.dart';
import '../../screen/jobs.screen/home.screen.dart';
import '../../screen/realEstate/realEstate.home.page.dart';
import '../network/api.state.dart';
import '../utils/preety.dio.dart';

class Auth {
  //
  // static Future<void> login(
  //     String email,
  //     String password,
  //     BuildContext context,
  //     ) async {
  //   final dio = await createDio();
  //   final service = APIStateNetwork(dio);
  //   final response = await service.login(
  //     LoginBody(email_or_phone: email, password: password),);
  //   if (response.response.statusCode == 200) {
  //     final data = response.response.data;
  //     final loginData = LoginResponse.fromJson(data);
  //     final box = await Hive.openBox('userdata');
  //     await box.clear(); // Optional: Clear previous session
  //     await box.put('token', loginData.token);
  //     await box.put('user_id', loginData.userId);
  //     await box.put('expiresIn', loginData.expiresIn);
  //     await box.put('type', "MATRIMONY");
  //     final userId = box.get('user_id');
  //     final token = box.get('token');
  //     print('User ID: $userId');
  //     print('Token: $token');
  //     Fluttertoast.showToast(
  //       msg: data['message'] ?? 'Login successful',
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.TOP,
  //       backgroundColor: Colors.green,
  //       textColor: Colors.white,
  //       fontSize: 12.0,
  //     );
  //     log('Login successful: $data');
  //     Navigator.pushAndRemoveUntil(
  //       context,
  //       CupertinoPageRoute(builder: (context) => const HomePage()),
  //           (route) => false,
  //     );
  //   } else {
  //     Fluttertoast.showToast(
  //       msg: response.response.data['message'] ?? 'Login failed',
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.TOP,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //       fontSize: 12.0,
  //     );
  //
  //     throw Exception('Failed to login');
  //   }
  // }

  static Future<void> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      final dio = await createDio();
      final service = APIStateNetwork(dio);
      final response = await service.login(
        LoginBody(email_or_phone: email, password: password),
      );
      if (response.response.statusCode == 200) {
        final data = response.response.data;
        final loginData = LoginResponse.fromJson(data);
        final box = await Hive.openBox('userdata');
        await box.clear(); // Optional: Clear previous session
        await box.put('token', loginData.token);
        await box.put('user_id', loginData.userId);
        await box.put('expiresIn', loginData.expiresIn);
        await box.put('type', "MATRIMONY");
        final userId = box.get('user_id');
        final token = box.get('token');
        print('User ID: $userId');
        print('Token: $token');
        Fluttertoast.showToast(
          msg: data['message'] ?? 'Login successful',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 12.0,
        );
        log('Login successful: $data');
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => const HomePage()),
          (route) => false,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        // Handle 403 specifically
        Fluttertoast.showToast(
          msg:
              e.response?.data['message'] ??
              'Your profile is under review. Please wait for approval.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 12.0,
        );
      } else {
        // Handle other errors
        Fluttertoast.showToast(
          msg: e.response?.data['message'] ?? 'Login failed',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0,
        );
      }
      throw Exception('Failed to login: ${e.message}');
    } catch (e) {
      // Catch any other unexpected errors
      Fluttertoast.showToast(
        msg: 'An unexpected error occurred: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0,
      );
      throw Exception('Failed to login: $e');
    }
  }

  static Future<void> jobsLogin(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      final dio = await createDio();
      final service = APIStateNetwork(dio);
      final response = await service.jobsLogin(
        LoginBody(email_or_phone: email, password: password),
      );
      if (response.response.statusCode == 200) {
        final data = response.response.data;
        final loginData = LoginResponse.fromJson(data);
        final box = await Hive.openBox('userdata');
        await box.clear(); // optional: remove old data
        await box.put('token', loginData.token);
        await box.put('token', loginData.token);
        await box.put('user_id', loginData.userId);
        await box.put('type', "JOBS");
        String userName = email.split('@').first; // Gets everything before '@'
        await box.put('userName', userName);
        // await box.put('expiresIn', loginData.expiresIn);
        final userId = box.get('user_id');
        final token = box.get('token');
        print('User ID: $userId');
        print('Token: $token');
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
        Fluttertoast.showToast(
          msg: response.response.data['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 12.0,
        );
        log('Login successful: ${response.response.data}');
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      } else {
        Fluttertoast.showToast(
          msg: response.response.data['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0,
        );
        throw Exception('Failed to login');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        // Handle 403 specifically
        Fluttertoast.showToast(
          msg:
              e.response?.data['message'] ??
              'Your profile is under review. Please wait for approval.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 12.0,
        );
      } else {
        // Handle other errors
        Fluttertoast.showToast(
          msg: e.response?.data['message'] ?? 'Login failed',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0,
        );
      }
      throw Exception('Failed to login: ${e.message}');
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'An unexpected error occurred: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0,
      );
      throw Exception('Failed to login: $e');
    }
  }

  static Future<void> realStateLogin(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      final dio = await createDio();
      final service = APIStateNetwork(dio);

      final response = await service.realStateLogin(
        LoginBody(email_or_phone: email, password: password),
      );

      if (response.response.statusCode == 200) {
        final data = response.response.data;
        final loginData = LoginResponse.fromJson(data);

        final box = await Hive.openBox('userdata');
        await box.clear(); // Optional: remove old data
        await box.put('token', loginData.token);
        await box.put('user_id', loginData.userId);
        await box.put('role', loginData.role);
        await box.put('type', "REAL ESTATE");

        // Extract username from email
        String userName = email.split('@').first;
        await box.put('userName', userName);

        print('User ID: ${loginData.userId}');
        print('Token: ${loginData.token}');

        Fluttertoast.showToast(
          msg: data['message'] ?? 'Login successful',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 12.0,
        );

        log('Login successful: $data');

        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => const RealestateHomePage()),
          (route) => false,
        );
      } else {
        Fluttertoast.showToast(
          msg: response.response.data['message'] ?? 'Login failed',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0,
        );
        throw Exception('Failed to login');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        // Handle 403 specifically
        Fluttertoast.showToast(
          msg:
              e.response?.data['message'] ??
              'Your profile is under review. Please wait for approval.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 12.0,
        );
      } else {
        // Handle other errors
        Fluttertoast.showToast(
          msg: e.response?.data['message'] ?? 'Login failed',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0,
        );
      }
      throw Exception('Failed to login: ${e.message}');
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'An unexpected error occurred: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0,
      );
      throw Exception('Failed to login: $e');
    }
  }

  static Future<void> register(
    String email,
    String password,
    String name,
    String phone,
    String age,
    String gender,
    String date_of_birth,
    BuildContext context,
  ) async {
    final dio = await createDio();
    final service = APIStateNetwork(dio);
    final response = await service.register(
      RegisterRequest(
        email: email,
        password: password,
        name: name,
        phone: phone,
        age: age,
        gender: gender,
        dateOfBirth: date_of_birth,
        role: '',
      ),
    );
    if (response.response.data['message'] == "Registration successful") {
      Fluttertoast.showToast(
        msg: response.response.data['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 12.0,
      );
      log('Register successful: ${response.response.data}');
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
        msg: response.response.data['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0,
      );
      throw Exception('Failed to login');
    }
  }

  static Future<void> registerRealState(
    String name,
    String email,
    String password,
    String phone,
    String role,
    BuildContext context,
  ) async {
    final dio = await createDio();
    final service = APIStateNetwork(dio);
    final response = await service.registerRealState(
      RegisterRequest(
        name: name,
        email: email,
        password: password,
        phone: phone,
        role: role,
        dateOfBirth: '',
        age: '',
        gender: '',
      ),
    );
    if (response.response.data['message'] == "Registration successful") {
      Fluttertoast.showToast(
        msg: response.response.data['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 12.0,
      );
      log('Register successful: ${response.response.data}');
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
        msg: response.response.data['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0,
      );
      throw Exception('Failed to login');
    }
  }

  /*


  static Future<void> registerJobSeeker({
  required String email,
  required String password,
  required String name,
  required String phone,
  required File resumeFile,
  required BuildContext context,
  }) async {
  final dio = await createDio();
  final fileExtension = resumeFile.path.split('.').last.toLowerCase();
  MediaType mediaType;
  if (fileExtension == 'pdf') {
  mediaType = MediaType("application", "pdf");
  } else if (fileExtension == 'doc') {
  mediaType = MediaType("application", "msword");
  } else if (fileExtension == 'docx') {
  mediaType = MediaType("application", "vnd.openxmlformats-officedocument.wordprocessingml.document");
  } else {
  Fluttertoast.showToast(
  msg: "Invalid file type. Please upload a PDF, DOC, or DOCX file.",
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.TOP,
  backgroundColor: Colors.red,
  textColor: Colors.white,
  fontSize: 12.0,
  );
  return; // Exit early if the file type is not allowed
  }
  final formData = FormData.fromMap({
  'name': name,
  'email': email,
  'password': password,
  'phone': phone,
  'resume': await MultipartFile.fromFile(
  resumeFile.path,
  filename: resumeFile.path.split('/').last,
  contentType: mediaType,
  ),
  });
  try {
  final response = await dio.post(
  'https://aipowered.globallywebsolutions.com/api/jobs/auth/register',
  data: formData,
  );

  if (response.data['message'] == "Registration successful") {
  Fluttertoast.showToast(
  msg: "Registration successful",
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.TOP,
  backgroundColor: Colors.green,
  textColor: Colors.white,
  fontSize: 12.0,
  );
  Navigator.pop(context);
  } else {
  Fluttertoast.showToast(
  msg: "Registration failed: ${response.data['message']}",
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.TOP,
  backgroundColor: Colors.red,
  textColor: Colors.white,
  fontSize: 12.0,
  );
  throw Exception('Job registration failed');
  }
  }
  catch (e) {
  Fluttertoast.showToast(
  msg: "Error: $e",
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.TOP,
  backgroundColor: Colors.red,
  textColor: Colors.white,
  fontSize: 12.0,
  );
  }

  }





*/

  static Future<void> registerJobSeeker({
    required String email,
    required String password,
    required String name,
    required String phone,
    required File resumeFile,
    required BuildContext context,
    required VoidCallback onSuccess, // Add callback parameter
  }) async {
    final dio = await createDio();
    final fileExtension = resumeFile.path.split('.').last.toLowerCase();
    MediaType mediaType;
    if (fileExtension == 'pdf') {
      mediaType = MediaType("application", "pdf");
    } else if (fileExtension == 'doc') {
      mediaType = MediaType("application", "msword");
    } else if (fileExtension == 'docx') {
      mediaType = MediaType(
        "application",
        "vnd.openxmlformats-officedocument.wordprocessingml.document",
      );
    } else {
      Fluttertoast.showToast(
        msg: "Invalid file type. Please upload a PDF, DOC, or DOCX file.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0,
      );
      return; // Exit early if the file type is not allowed
    }
    final formData = FormData.fromMap({
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'resume': await MultipartFile.fromFile(
        resumeFile.path,
        filename: resumeFile.path.split('/').last,
        contentType: mediaType,
      ),
    });
    try {
      final response = await dio.post(
        'https://aipowered.globallywebsolutions.com/api/jobs/auth/register',
        data: formData,
      );

      if (response.data['message'] == "Registration successful") {
        Fluttertoast.showToast(
          msg: "Registration successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 12.0,
        );
        onSuccess();
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
          msg: "Registration failed: ${response.data['message']}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 12.0,
        );
        throw Exception('Job registration failed');
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0,
      );
    }
  }

  static Future<void> registerEmployer(
    String email,
    String password,
    String name,
    String phone,
    String age,
    String gender,
    String date_of_birth,

    BuildContext context,
  ) async {
    final dio = await createDio();
    final service = APIStateNetwork(dio);
    final response = await service.register(
      RegisterRequest(
        email: email,
        password: password,
        name: name,
        phone: phone,
        age: age,
        gender: gender,
        dateOfBirth: date_of_birth,
        role: '',
      ),
    );
    if (response.response.data['message'] == "Registration successful") {
      Fluttertoast.showToast(
        msg: response.response.data['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 12.0,
      );
      log('Register successful: ${response.response.data}');
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
        msg: response.response.data['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0,
      );
      throw Exception('Failed to login');
    }
  }

  static Future<void> resisterEmployerRequestBody(
    String contact_person,
    String email,
    String password,
    String company_name,
    String phone,
    BuildContext context,
  ) async {
    final dio = await createDio();
    final service = APIStateNetwork(dio);
    final response = await service.resisterEmployer(
      EmployerRegisterRequestBody(
        contactPerson: contact_person,
        password: password,
        email: email,
        companyName: company_name,
        phone: phone,
      ),
    );
    if (response.response.statusCode == 200 ||
        response.response.statusCode == 201) {
      final box = await Hive.openBox('userdata');
      await box.put('employer_id', response.response.data["employer_id"]);
      final employer_id = box.get('employer_id');
      print('employer_id: $employer_id');
      Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => const BasicInfoScreen()),
      );
      Fluttertoast.showToast(
        msg: response.response.data['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 12.0,
      );
      log('Login successful: ${response.response.data}');
      Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => const BasicInfoScreen()),
      );
    } else {
      Fluttertoast.showToast(
        msg: response.response.data['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 12.0,
      );
      throw Exception('Failed to login');
    }
  }
}
