import 'dart:convert';

RegisterRequest registerRequestFromJson(String str) =>
    RegisterRequest.fromJson(json.decode(str));

String registerRequestToJson(RegisterRequest data) =>
    json.encode(data.toJson());

class RegisterRequest {
  String name;
    String email;
    String password;
    String dateOfBirth;
    String gender;
    String age;
    String role;
    String phone;

    RegisterRequest({

      required this.name,
        required this.email,
        required this.password,

        required this.dateOfBirth,
        required this.age,
        required this.role,
        required this.gender,
        required this.phone,
    });

    factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
        RegisterRequest(
          name: json["name"],
            email: json["email"],
            password: json["password"],
          dateOfBirth: json["date_of_birth"],
          age: json["age"],
          role: json["role"],
            gender: json["gender"],
            phone: json["phone"],
        );

    Map<String, dynamic> toJson() => {
      "name": name,
        "email": email,
        "password": password,
        "date_of_birth": dateOfBirth,
        "age": age,
        "role": role,
        "gender": gender,
        "phone": phone,
    };
}
