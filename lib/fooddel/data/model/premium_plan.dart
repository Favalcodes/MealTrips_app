import 'package:cloud_firestore/cloud_firestore.dart';

class PremiumModel {
  String id;
  double planA;
  double planB;
  double planC;


  PremiumModel({
    this.id,
    this.planA,
    this.planB,
    this.planC
  });

  factory PremiumModel.fromDocument(DocumentSnapshot doc) {
    return PremiumModel(
      id: doc.id,
      planA: doc.data()['planA'],
      planB: doc.data()['planB'],
      planC: doc.data()['planC'],
    );
  }
}
