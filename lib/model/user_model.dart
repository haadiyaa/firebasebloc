class UserModel {

  String? email;
  String? password;
  String? uid;
  String? name;
  String? phone;
  String? age;
  String? image;
  
  UserModel({
    this.email,
    this.password,
    this.uid,
    this.name,
    this.phone,
    this.age,
    this.image,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      password: json['password'],
      uid: json['uid'],
      name: json['name'],
      phone: json['phone'],
      age: json['age'],
      image: json['image'],
    );
  }
}
