import 'package:cloud_firestore/cloud_firestore.dart';

class RatingModel {
  final String userId;
  final String review;
  final int rating;
  final Timestamp timestamp;
  final String username;
  final String profileImage;
  final String date;
  RatingModel({this.userId, this.date,this.review, this.rating, this.profileImage, this.username,this.timestamp});

  factory RatingModel.fromDocument(DocumentSnapshot documentSnapshot) {
    return RatingModel(
      userId: documentSnapshot["userId"],
      review: documentSnapshot["review"],
      rating: documentSnapshot["rating"],
      timestamp: documentSnapshot["timestamp"],
      username: documentSnapshot["username"],
      date: documentSnapshot["date"],
      profileImage: documentSnapshot["profileImage"],
    );
  }
}
