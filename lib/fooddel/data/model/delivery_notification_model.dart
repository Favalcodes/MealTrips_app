import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryNModel {
  final String id;
  final String body;
  final String orderId;
  final String date;
  final int seen;
  final Timestamp timestamp;
  final String token;

  DeliveryNModel({this.id, this.body,this.token, this.seen, this.orderId, this.date, this.timestamp});

  factory DeliveryNModel.fromDocument(DocumentSnapshot doc) {
    return DeliveryNModel(
      id: doc.id,
      body: doc.data()['body'],
      seen: doc.data()['seen'],
      token: doc.data()['token'],
      orderId: doc.data()['orderId'],
      date: doc.data()['date'],
      timestamp: doc.data()['timestamp'],
    );
  }
}
