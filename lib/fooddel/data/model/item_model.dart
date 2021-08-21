import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  final String id;
  final String resId;
  final String vendorName;
  final String itemName;
  final double itemPrice;
  final String pTime;
  final String image;
  final String category;
  final double rating;
  final String description;
  final int discount;
  final int totalOrder;
  final dynamic rateId;
  final Timestamp timestamp;

  ItemModel(
      {this.id,
      this.resId,
      this.rateId,
      this.vendorName,
      this.itemName,
      this.itemPrice,
      this.pTime,
      this.totalOrder,
      this.image,
      this.category,
      this.discount,
      this.description,
      this.rating,
      this.timestamp});

  factory ItemModel.fromDocument(DocumentSnapshot doc) {
    return ItemModel(
      id: doc.id,
      resId: doc.data()['resId'],
      vendorName: doc.data()['vendorName'],
      itemName: doc.data()['itemName'],
      itemPrice: doc.data()['itemPrice'],
      totalOrder: doc.data()['totalOrder'],
      pTime: doc.data()['pTime'],
      image: doc.data()['image'],
      rateId: doc.data()['rateId'],
      category: doc.data()['category'],
      discount: doc.data()['discount'],
      rating: doc.data()['rating'],
      description: doc.data()['description'],
      timestamp: doc.data()['timestamp'],
    );
  }
}
