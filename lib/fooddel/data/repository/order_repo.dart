import 'package:mealtrips/fooddel/data/model/order_model.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';

class OrderRepo{
  Future<List<OrderModel>> getOrder()async{
     List<OrderModel> orderList;
      await orderRef.orderBy("timestamp", descending:true).get().then((value){
          orderList = value.docs.map((document)=>OrderModel.fromDocument(document)).toList();
          return orderList;
      });
    return orderList;
  }

    Future<List<OrderModel>> todayOrder()async{
     List<OrderModel> orderList;
      await orderRef.where('date', isEqualTo:date).get().then((value){
          orderList = value.docs.map((document)=>OrderModel.fromDocument(document)).toList();
          return orderList;
      });
    return orderList;
  }
}
