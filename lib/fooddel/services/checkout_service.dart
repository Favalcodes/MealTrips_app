import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mealtrips/fooddel/data/model/cart_model.dart';
import 'package:mealtrips/fooddel/data/model/user_model.dart';
import 'package:mealtrips/fooddel/data/model/vendor_model.dart';
import 'package:mealtrips/fooddel/data/repository/cart_repo.dart';
import 'package:mealtrips/fooddel/screens/homepage/home_tab.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';
import 'package:uuid/uuid.dart';

Future<void> checkOut(
    BuildContext context, List<CartModel> catItems, int deliveryFee) async {
  CartRepo cartRepo = CartRepo();
  List<CartModel> myCart = [];

  //fetch cart items
  myCart = await cartRepo.getCart(onlineUser.id);

  //Extract distinct resturant IDS
  final ids = catItems.map((e) => e.resId).toSet();
  catItems.retainWhere((x) => ids.remove(x.resId));

  //get each resturants total item price
  catItems.forEach((element) async {
    double totalPrice = 0.0;
    String orderId = Uuid().v4();
    int totalItems = 0;
    int pTime = 0;

    myCart.forEach((item) async {
      //check if cart item is for online user
      if (item.userId == onlineUser.id && item.resId == element.resId) {
        orderItems(orderId, item);
        totalPrice = totalPrice + item.price;
        totalItems = totalItems + item.quantity;
        pTime = pTime + int.parse(item.pTime);
      }
    });

    //Send order to resturants
    makeOrder(element, orderId, totalPrice, totalItems, pTime);
  });
  //Delivery Earnings
  deliveryEarnings(deliveryFee);
}

Future<void> makeOrder(CartModel element, String orderId, double totalPrice,
    int totalItems, int pTime) async {
  int seconds = DateTime.now().millisecondsSinceEpoch;
  String orderNumber = getRandomString(6);
  await orderRef.doc().set({
    'userId': onlineUser.id,
    'orderId': orderId,
    'resId': element.resId,
    'amount': totalPrice,
    'orderNumber': orderNumber,
    'timestamp': timestamp,
    'packed': false,
    'delivered': false,
    'deliveryMerchant': '',
    'seconds': seconds,
    'cancelled': false,
    'onTransit': false,
    'quantity': totalItems,
    'pTime': pTime,
    'dTime': "",
    'date': date
  });

  //Enable user to add review to this retaurant

  resturantRef.doc(element.resId).update({"userOrder.${onlineUser.id}": true});

  //send notification
  sendVendorNotification(element.resId, orderNumber);

  userNotification(orderNumber);

  //update vendor balance
  updateBalance(element.resId, totalPrice);

  //Delivery transactions
  transactionHistory(element, orderId, orderNumber, totalPrice);
}

var _chars = '123456789';
Random _rnd = Random();
String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

Future<void> orderItems(String orderId, CartModel catItems) async {
  String id = Uuid().v4();
  await orderItemsRef.doc(orderId).collection("Items").doc(id).set({
    'itemId': catItems.itemId,
    'resId': catItems.resId,
    'userId': onlineUser.id,
    'timestamp': timestamp,
    'quantity': catItems.quantity,
    'price': catItems.price,
    'name': catItems.name,
    'image': catItems.image,
    'pTime': catItems.pTime
  });
}

Future<void> transactionHistory(CartModel element, String orderId,
    String orderNumber, double totalPrice) async {
  await vendorTransactionRef
      .doc(element.resId)
      .collection("Items")
      .doc(orderId)
      .set({
    'resId': element.resId,
    'amount': totalPrice,
    'orderId': orderId,
    'orderNumber': orderNumber,
    'timestamp': timestamp,
    'date': date
  });
}

Future<void> updateBalance(String resId, double totalPrice) async {
  await resturantRef.doc(resId).get().then((value) {
    VendorModel vendorModel = VendorModel.fromDocument(value);
    double balance = vendorModel.balance;
    double newBalance = balance + totalPrice;
    resturantRef.doc(resId).update({
      "balance": newBalance,
    });
  });
}

void sendVendorNotification(String resId, String orderNumber) {
  usersReference.doc(resId).get().then((value) {
    String token = UserModel.fromDocument(value).token;

    vendorNotRef.doc(resId).collection("Items").doc().set({
      'timestamp': timestamp,
      'type': 'order',
      'seen': 0,
      'orderId': orderNumber,
      'date': date,
      'token': token
    });
  });
}

void userNotification(String orderNumber) {
  notificationRef.doc(onlineUser.id).collection("Items").doc().set({
    'timestamp': timestamp,
    'body':
        'Your order has been received, a delivery person will contact you shortly.',
    'orderId': orderNumber,
    'seen': false,
    'date': date,
    'token': onlineUser.token
  });
}

void deliveryEarnings(int deliveryFee) {
  if (deliveryFee > 500) {
    int extraFee = deliveryFee - 500;
    double fee = double.parse(extraFee.toString());
     extraEarningsRef
      .doc()
      .set({"date": date, "timestamp": timestamp, "amount": fee});
  }
  deliveryEarningsRef
      .doc()
      .set({"date": date, "timestamp": timestamp, "amount": 500.0});
}
