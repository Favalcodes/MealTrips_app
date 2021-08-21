import 'package:cloud_firestore/cloud_firestore.dart';

class VendorModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final String date;
  final String subDate;
  final String image;
  final double rating;
  final String bankName;
  final dynamic userOrder;
  final dynamic rateId;
  final int plan;
  final bool premium;
  final String accountName;
  final String accountNumber;
  final double balance;

  VendorModel(
      {this.id,
      this.name,
      this.phone,
      this.rating,
      this.rateId,
      this.plan,
      this.premium,
      this.email,
      this.address,
      this.subDate,
      this.date,
      this.accountName,
      this.accountNumber,
      this.balance,
      this.bankName,
      this.image,
      this.userOrder
      });

  factory VendorModel.fromDocument(DocumentSnapshot doc) {
    return VendorModel(
      id: doc.id,
      name: doc.data()['name'],
      phone: doc.data()['phone'],
      email: doc.data()['email'],
      image: doc.data()['image'],
      plan: doc.data()['plan'],
      premium: doc.data()['premium'],
      address: doc.data()['address'],
      date: doc.data()['date'],
      rating: doc.data()['rating'],
      accountName: doc.data()['accountName'],
      accountNumber: doc.data()['accountNumber'],
      balance: doc.data()['balance'],
      bankName: doc.data()['bankName'],
      subDate: doc.data()['subDate'],
      userOrder: doc.data()['userOrder'],
      rateId: doc.data()['rateId'],
    );
  }
}
