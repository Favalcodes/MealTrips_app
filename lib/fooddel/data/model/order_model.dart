import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String id;
  String userId;
  String orderNumber;
  int quantity;
  double amount;
  bool packed;
  bool cancelled;
  String orderId;
  String resId;
  bool delivered;
  String deliveryMerchant;
  int pTime;
  String date;
  String dTime;
  bool onTransit;
  int seconds;
  Timestamp timestamp;

  OrderModel(
      {this.id,
      this.amount,
      this.packed,
      this.quantity,
      this.delivered,
      this.orderNumber,
      this.dTime,
      this.userId,
      this.date,
      this.timestamp,
      this.resId,
      this.orderId,
      this.cancelled,
      this.pTime,
      this.onTransit,
      this.seconds,
      this.deliveryMerchant});

  factory OrderModel.fromDocument(DocumentSnapshot doc) {
    return OrderModel(
      id: doc.id,
      userId: doc.data()['userId'],
      amount: doc.data()['amount'],
      pTime: doc.data()['pTime'],
      quantity: doc.data()['quantity'],
      seconds: doc.data()['seconds'],
      dTime: doc.data()['dTime'],
      onTransit: doc.data()['onTransit'],
      orderNumber: doc.data()['orderNumber'],
      packed: doc.data()['packed'],
      delivered: doc.data()['delivered'],
      date: doc.data()['date'],
      resId: doc.data()['resId'],
      timestamp: doc.data()['timestamp'],
      orderId: doc.data()['orderId'],
      cancelled: doc.data()['cancelled'],
      deliveryMerchant: doc.data()['deliveryMerchant'],
    );
  }
}
