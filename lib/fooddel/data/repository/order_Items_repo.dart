import 'package:mealtrips/fooddel/data/model/cart_model.dart';
import 'package:mealtrips/fooddel/data/model/order_items.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';

class OrderItemsRepo {
  Future<List<CartModel>> getOrderItems(String orderId) async {
    List<CartModel> orderList;
    await orderItemsRef.doc(orderId).collection("Items").get().then((value) {
      orderList = value.docs
          .map((document) => CartModel.fromDocument(document))
          .toList();
      return orderList;
    });
    return orderList;
  }
}
