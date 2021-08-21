import 'package:mealtrips/fooddel/data/model/order_transaction_model.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';

class OrderTransactionRepo {
  Future<List<OrderTransactionModel>> getTransactions(String resId) async {
    List<OrderTransactionModel> items;
    await vendorTransactionRef
        .doc(resId)
        .collection("Items")
        .orderBy("timestamp", descending: true)
        .get()
        .then((value) {
      items = value.docs
          .map((document) => OrderTransactionModel.fromDocument(document))
          .toList();
      return items;
    });
    return items;
  }
}
