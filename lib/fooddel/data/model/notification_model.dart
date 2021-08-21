import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String body;
  final String orderId;
  final String date;
  final bool seen;
  final Timestamp timestamp;
  final String token;

  NotificationModel({this.id, this.seen,this.token, this.body, this.orderId, this.date, this.timestamp});

  factory NotificationModel.fromDocument(DocumentSnapshot doc) {
    return NotificationModel(
      id: doc.id,
      body: doc.data()['body'],
      orderId: doc.data()['orderId'],
      token: doc.data()['token'],
      seen: doc.data()['seen'],
      date: doc.data()['date'],
      timestamp: doc.data()['timestamp'],
    );
  }
}
