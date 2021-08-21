import 'package:cloud_firestore/cloud_firestore.dart';

class WishListModel{
  final String id;
  final String itemId;
  final double price;
  final String image;
  final String name;
  final double rating;
  final Timestamp timestamp;

  WishListModel({
    this.id,
    this.itemId,
    this.price,
    this.image,
    this.name,
    this.rating,
    this.timestamp
  });

  factory WishListModel.fromDocument(DocumentSnapshot doc) {
    return WishListModel(
      id: doc.id,
      itemId: doc.data()['itemId'],
      price: doc.data()['price'],
      image: doc.data()['image'],
      rating: doc.data()['rating'],
      name: doc.data()['name'],
      timestamp: doc.data()['timestamp'],
    );
   }
}