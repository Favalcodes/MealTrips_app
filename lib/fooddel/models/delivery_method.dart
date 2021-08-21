import 'package:flutter/material.dart';

class DeliveryMethods {
  final String title, subTitle, amount;
  final IconData icon;

  DeliveryMethods({
    this.title,
    this.amount,
    this.subTitle,
    this.icon,
  });
}

List <DeliveryMethods> deliveryMethods = [deliveryMethod1];

DeliveryMethods deliveryMethod1 = DeliveryMethods(
  title: 'Share Delivery',
  subTitle: 'Share 50% of your payment with a friend',
  amount: '\$2.30',
);





