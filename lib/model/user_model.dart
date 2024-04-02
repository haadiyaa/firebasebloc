import 'dart:convert';

class UserModel {
  
  String? email;
  String? password;
  String? uid;
  String? name;
  String? phone;
  String? age;
  String? image;
  String? location;
  
  UserModel({
    this.email,
    this.password,
    this.uid,
    this.name,
    this.phone,
    this.age,
    this.image,
    this.location,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      password: json['password'],
      uid: json['uid'],
      name: json['name'],
      age: json["age"],
      image: json["image"],
      location: json['location'],
      
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email': email,
      'password': password,
      'uid': uid,
      'name': name,
      'phone': phone,
      'age': age,
      'image': image,
      'location': location,
    };
  }

  
}
