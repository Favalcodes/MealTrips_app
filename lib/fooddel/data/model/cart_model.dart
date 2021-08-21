import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel{
   String id;
   String itemId;
   int quantity;
   double price;
   String image;
   String name;
   String resId;
   String userId;
   Timestamp timestamp;
   String pTime;

  CartModel({
    this.id,
    this.itemId,
    this.price,
    this.quantity,
    this.image,
    this.name,
    this.timestamp,
    this.userId,
    this.resId,
    this.pTime
  });

  factory CartModel.fromDocument(DocumentSnapshot doc) {
    return CartModel(
      id: doc.id,
      itemId: doc.data()['itemId'],
      quantity: doc.data()['quantity'],
      price: doc.data()['price'],
      image: doc.data()['image'],
      name: doc.data()['name'],
      userId: doc.data()['userId'],
      resId: doc.data()['resId'],
      pTime: doc.data()['pTime'],
      timestamp: doc.data()['timestamp'],
    );
   }
}