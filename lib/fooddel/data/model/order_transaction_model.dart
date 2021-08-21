import 'package:cloud_firestore/cloud_firestore.dart';

class OrderTransactionModel {
  String id;
  double amount;
  String resId;
  String date;
  String orderId;
  final String orderNumber;
  Timestamp timestamp;

  OrderTransactionModel(
      {this.id,
      this.amount,
      this.orderId,
      this.date,
      this.orderNumber,
      this.timestamp,
      this.resId});

  factory OrderTransactionModel.fromDocument(DocumentSnapshot doc) {
    return OrderTransactionModel(
      id: doc.id,
      amount: doc.data()['amount'],
      date: doc.data()['date'],
      orderId:doc.data()['orderId'],
      orderNumber: doc.data()['orderNumber'],
      resId: doc.data()['resId'],
      timestamp: doc.data()['timestamp'],
    );
  }
}
