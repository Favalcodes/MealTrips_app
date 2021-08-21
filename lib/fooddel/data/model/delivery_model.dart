import 'package:cloud_firestore/cloud_firestore.dart';
class DeliveryModel{
  final String id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String date;
  final String subDate;
  final String image;
  final double rating;

  DeliveryModel({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.address,
    this.subDate,
    this.date,
    this.rating,
    this.image
  });

  factory DeliveryModel.fromDocument(DocumentSnapshot doc) {
    return DeliveryModel(
      id: doc.id,
      name: doc.data()['name'],
      phone: doc.data()['phone'],
      email: doc.data()['email'],
      image: doc.data()['image'],
      address: doc.data()['address'],
      rating: doc.data()['rating'],
      date: doc.data()['date'],
      subDate: doc.data()['subDate'],
      );
   }
}