import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryEarnings {
  final String id;
  final double amount;
  final String date;
  final Timestamp timestamp;

  DeliveryEarnings({this.id, this.amount, this.date, this.timestamp});

  factory DeliveryEarnings.fromDocument(DocumentSnapshot doc) {
    return DeliveryEarnings(
      id: doc.id,
      amount: doc.data()['amount'],
      date: doc.data()['date'],
      timestamp: doc.data()['timestamp'],
    );
  }
}
