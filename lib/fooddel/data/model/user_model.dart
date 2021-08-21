import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final int type;
  final String image;
  final String date;
  final String subDate;
  final String address;
  final String token;
  UserModel(
      {this.id,
      this.name,
      this.token,
      this.phone,
      this.email,
      this.type,
      this.image,
      this.date,
      this.address,
      this.subDate});

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      id: doc.id,
      name: doc.data()['name'],
      phone: doc.data()['phone'],
      token: doc.data()['token'],
      email: doc.data()['email'],
      type: doc.data()['type'],
      address: doc.data()['address'],
      image: doc.data()['image'],
      date: doc.data()['date'],
      subDate: doc.data()['subDate'],
    );
  }
}
