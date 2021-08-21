import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:mealtrips/fooddel/screens/homepage/home_tab.dart';
import 'package:monnify_flutter_sdk/monnify_flutter_sdk.dart';
import 'package:mealtrips/fooddel/services/users_service.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';

Future<void> initializeSdk() async {
  try {
    if (await MonnifyFlutterSdk.initialize(
        'MK_PROD_NFNVRYFKKK', '128269925119', ApplicationMode.LIVE)) {
    }
  } on PlatformException catch (e, s) {
    print("Error initializing sdk");
  }
}

Future<void> premiumService(BuildContext context,
    {String userId,
    String email,
    String name,
    double amount,
    int subscriptionPlan}) async {
  TransactionResponse transactionResponse;
  try {
    transactionResponse = await MonnifyFlutterSdk.initializePayment(Transaction(
      amount,
      "NGN",
      name,
      email,
      getRandomString(15),
      "Payment for subscription",
      paymentMethods: [PaymentMethod.CARD],
    ));

    _showToast(transactionResponse.transactionStatus.toString(), context);

    if (transactionResponse.transactionStatus.toString() == "PAID") {
      await subscribeUser(userId, subscriptionPlan);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeTabs()));
    }
  } on PlatformException catch (e, s) {
    print("Error initializing payment");
    _showToast("Failed to init payment!", context);
  }
}

Future<void> subscribeUser(String userId, int subscriptionPlan) async {
  resturantRef
      .doc(userId)
      .update({'premium': true, 'plan': subscriptionPlan, 'subDate': now});
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
