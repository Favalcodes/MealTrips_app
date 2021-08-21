import 'package:mealtrips/fooddel/data/model/item_model.dart';
import 'package:mealtrips/fooddel/data/model/notification_model.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';

class NotificationRepo {
  Future<List<NotificationModel>> getNotification(String resId) async {
    List<NotificationModel> noti;
    await notificationRef
        .doc(resId)
        .collection("Items")
        .orderBy('timestamp', descending: true)
        .get()
        .then((value) {
      noti = value.docs
          .map((document) => NotificationModel.fromDocument(document))
          .toList();
      return noti;
    });
    return noti;
  }
}
