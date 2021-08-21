import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:monnify_flutter_sdk/monnify_flutter_sdk.dart';
import 'package:mealtrips/fooddel/data/model/cart_model.dart';
import 'package:mealtrips/fooddel/screens/order_confirmed/order_confirmed.dart';
import 'package:mealtrips/fooddel/services/checkout_service.dart';

//Api key MK_PROD_NFNVRYFKKK
//128269925119
//MFY_SUB_346899696116
Future<void> initializeSdk() async {
  try {
    if (await MonnifyFlutterSdk.initialize(
        'MK_PROD_NFNVRYFKKK', '128269925119', ApplicationMode.LIVE)) {
      print("initialized sdk");
    }
  } on PlatformException catch (e, s) {
    print("Error initializing sdk");
  }
}

Future<void> initPayment(BuildContext context, List<CartModel> cartItemList,
    String userName, double amount, String email, int deliveryFee) async {
  double percent = (deliveryFee / amount) * 100;
  TransactionResponse transactionResponse;
  try {
    transactionResponse = await MonnifyFlutterSdk.initializePayment(Transaction(
        amount, "NGN", userName, email, getRandomString(15), "Food order",
        paymentMethods: [
          PaymentMethod.CARD
        ],
        incomeSplitConfig: [
          SubAccountDetails("MFY_SUB_346899696116", percent,
              double.parse(deliveryFee.toString()), false),
        ]));

    _showToast(transactionResponse.transactionStatus.toString(), context);

    if (transactionResponse.transactionStatus.toString() == "PAID") {
      checkOut(context, cartItemList, deliveryFee);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => OrderConfirmed()));
    }
  } on PlatformException catch (e, s) {
    print("Error initializing payment");
    _showToast("Failed to init payment!", context);
  }
}

String getRandomString(int length) {
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  return String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}

void _showToast(String message, BuildContext context) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
        content: Text(message),
        action: SnackBarAction(
            label: 'CLOSE', onPressed: scaffold.hideCurrentSnackBar)),
  );
}
