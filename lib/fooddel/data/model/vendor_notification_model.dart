import 'package:cloud_firestore/cloud_firestore.dart';

class VendorNModel {
  final String id;
  final String type;
  final String orderId;
  final String date;
  final int seen;
  final Timestamp timestamp;
  final String token;

  VendorNModel({this.id, this.seen, this.type, this.token, this.orderId, this.date, this.timestamp});

  factory VendorNModel.fromDocument(DocumentSnapshot doc) {
    return VendorNModel(
      id: doc.id,
      type: doc.data()['type'],
      orderId: doc.data()['orderId'],
      seen: doc.data()['seen'],
      date: doc.data()['date'],
      timestamp: doc.data()['timestamp'],
      token: doc.data()['token'],
    );
  }
}
