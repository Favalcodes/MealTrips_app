import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mealtrips/constants.dart';
import 'package:mealtrips/fooddel/data/model/item_model.dart';
import 'package:mealtrips/fooddel/data/model/order_model.dart';
import 'package:mealtrips/fooddel/data/model/order_transaction_model.dart';
import 'package:mealtrips/fooddel/data/model/user_model.dart';
import 'package:mealtrips/fooddel/data/model/vendor_model.dart';
import 'package:mealtrips/fooddel/data/repository/order_transaction_repo.dart';
import 'package:mealtrips/fooddel/data/repository/user_repo.dart';
import 'package:mealtrips/fooddel/screens/admin/vendor_info.dart';
import 'package:mealtrips/fooddel/screens/widgets/progress_widget.dart';
import 'package:mealtrips/fooddel/utility/colorResources.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';
import 'package:mealtrips/size_config.dart';

class TotalUsers extends StatefulWidget {
  final String userCategory;
  TotalUsers(this.userCategory);
  @override
  _TotalUsersState createState() => _TotalUsersState();
}

class _TotalUsersState extends State<TotalUsers> {
  List<OrderTransactionModel> transactions = [];
  OrderTransactionRepo transactionRepo = OrderTransactionRepo();
  bool isLoading = true;
  UserRepo userRepo = UserRepo();
  List<VendorModel> vendor = [];
  List<UserModel> users = [];

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  void getUsers() async {
    setState(() => isLoading = true);
    if (widget.userCategory == "Users") {
      users = await userRepo.getUsers();
    } else if (widget.userCategory == "Vendors") {
      vendor = await userRepo.getVendors();
    } else if (widget.userCategory == "Delivery") {
      vendor = await userRepo.getAllDeliveryMerchant();
    }
    setState(() => vendor = vendor);
    setState(() => users = users);
    setState(() => isLoading = false);
  }

  void deleteUser(String userId) {
    if (widget.userCategory == "Users") {
      usersReference.doc(userId).delete();
    } else if (widget.userCategory == "Vendors") {
      resturantRef.doc(userId).delete();
      usersReference.doc(userId).delete();
      handleVendorHistroy(userId);
    } else if (widget.userCategory == "Delivery") {
      deliveryRef.doc(userId).delete();
      usersReference.doc(userId).delete();
    }
    SnackBar snackBar = SnackBar(content: Text("Account Deleted"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void handleVendorHistroy(String userId) {
    List<ItemModel> items;
    List<ItemModel> wishes;
    List<OrderModel> orders;
    List<OrderModel> cartItems;

    itemsRef.where("resId", isEqualTo: userId).get().then((value) {
      items = value.docs
          .map((document) => ItemModel.fromDocument(document))
          .toList();

      items.forEach((element) {
        orderRef.where("itemId", isEqualTo: element.id).get().then((value) {
          //Delete order made from this retaurant
          // orders = value.docs
          //     .map((document) => OrderModel.fromDocument(document))
          //     .toList();

          // orders.forEach((element) {
          //   orderRef.doc(element.id).delete();
          // });

          //Delete  this retaurant items added to cart
          cartRef.where("itemId", isEqualTo: element.id).get().then((value) {
            cartItems = value.docs
                .map((document) => OrderModel.fromDocument(document))
                .toList();

            cartItems.forEach((element) {
              cartRef.doc(element.id).delete();
            });

            // //Delete  this retaurant items from wishlist
            // wishRef.where("itemId", isEqualTo: element.id).get().then((value) {
            //   wishes = value.docs
            //       .map((document) => ItemModel.fromDocument(document))
            //       .toList();

            //   wishes.forEach((element) {
            //     wishRef.doc(element.id).delete();
            //   });
            // });
          });
        });
      });

      items.forEach((element) {
        itemsRef.doc(element.id).delete();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: ColorResources.COLOR_WHITE,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 20,
                    offset: Offset(3, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 30.0,
                  ),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        // height: SizeConfig.screenHeight * 0.2,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            boxShadow: [kDefaultShadow]),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: SizeConfig.screenWidth * 0.04,
                                      color:
                                          Theme.of(context).textSelectionColor),
                                ),
                                Text(
                                  widget.userCategory == "Users"
                                      ? users.length.toString()
                                      : vendor.length.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color:
                                          Theme.of(context).textSelectionColor),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(10),
                            ),
                          ],
                        ),
                      ))
                ],
              )),
          Container(
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: ColorResources.COLOR_WHITE,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 20,
                    offset: Offset(3, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(height: 20.0),
                  Text(
                      widget.userCategory == "Users"
                          ? "Users"
                          : "${widget.userCategory}",
                      textAlign: TextAlign.left),
                  isLoading
                      ? circularProgress()
                      : ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: widget.userCategory == "Users"
                              ? users.length
                              : vendor.length,
                          itemBuilder: (context, i) {
                            return GestureDetector(
                              onTap: () {
                                if (widget.userCategory == "Vendors") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => VendoInfo(
                                                vendor[i],
                                              )));
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.all(0),
                                  trailing: IconButton(
                                    onPressed: () => controllDelete(
                                        context,
                                        widget.userCategory == "Users"
                                            ? users[i].id
                                            : vendor[i].id),
                                    icon: Icon(Icons.delete),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.red,
                                    backgroundImage: CachedNetworkImageProvider(
                                        widget.userCategory == "Users"
                                            ? users[i].image
                                            : vendor[i].image),
                                  ),
                                  title: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 6),
                                    child: Text(
                                        widget.userCategory == "Users"
                                            ? users[i].name
                                            : vendor[i].name,
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                  subtitle: Divider(),
                                ),
                              ),
                            );
                          }),
                ],
              )),
        ],
      ),
    );
  }

  dynamic controllDelete(mContext, userId) {
    showDialog(
        context: mContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Are sure you want to delete?",
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w500)),
            children: <Widget>[
              SimpleDialogOption(
                child: Text("Delete", style: TextStyle(color: Colors.black)),
                onPressed: () {
                  Navigator.pop(context);
                  deleteUser(userId);
                },
              ),
              SimpleDialogOption(
                child: Text("Cancel", style: TextStyle(color: Colors.black)),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }
}
