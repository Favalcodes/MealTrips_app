import 'package:mealtrips/fooddel/data/model/item_model.dart';
import 'package:mealtrips/fooddel/data/model/vendor_notification_model.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';

class VendorNRepo {
  Future<List<VendorNModel>> getNotification(String resId) async {
    List<VendorNModel> noti;
    await vendorNotRef
        .doc(resId)
        .collection("Items")
        .orderBy('timestamp', descending: true)
        .get()
        .then((value) {
      noti = value.docs
          .map((document) => VendorNModel.fromDocument(document))
          .toList();
      return noti;
    });
    return noti;
  }
}
