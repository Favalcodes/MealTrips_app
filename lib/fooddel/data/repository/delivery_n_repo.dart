import 'package:mealtrips/fooddel/data/model/delivery_notification_model.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';

class DeliveryNRepo {
  Future<List<DeliveryNModel>> getNotification(String id) async {
    List<DeliveryNModel> noti;
    await deliveryNotRef
        .doc(id)
        .collection("Items")
        .orderBy('timestamp', descending: true)
        .get()
        .then((value) {
      noti = value.docs
          .map((document) => DeliveryNModel.fromDocument(document))
          .toList();
      return noti;
    });
    return noti;
  }
}
