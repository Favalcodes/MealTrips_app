import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItemsModel{
   String id;
   String itemId;
   String orderId;

  OrderItemsModel({
    this.id,
    this.itemId,
    this.orderId,
  });

  factory OrderItemsModel.fromDocument(DocumentSnapshot doc) {
    return OrderItemsModel(
      id: doc.id,
      orderId: doc.data()['orderId'],
      itemId: doc.data()['itemId'],
    );
   }
}