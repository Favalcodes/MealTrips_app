import 'package:mealtrips/fooddel/data/model/cart_model.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';

class CartRepo {
  Future<List<CartModel>> getCart(String userId) async {
    List<CartModel> items;
    await cartRef.where("userId", isEqualTo: userId).get().then((value) {
      items = value.docs
          .map((document) => CartModel.fromDocument(document))
          .toList();
      return items;
    });
    return items;
  }
}
