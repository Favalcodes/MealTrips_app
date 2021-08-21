import 'package:flutter/material.dart';
import 'package:mealtrips/fooddel/data/model/vendor_model.dart';
import 'package:mealtrips/size_config.dart';

class SelectDeliveryMerchant extends StatefulWidget {
  final List<VendorModel> delivery;
  SelectDeliveryMerchant(this.delivery);
  @override
  _SelectDeliveryMerchantState createState() => _SelectDeliveryMerchantState();
}

class _SelectDeliveryMerchantState extends State<SelectDeliveryMerchant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Select Delivery Merchant',
            style: TextStyle(
              color: Theme.of(context).textSelectionColor,
              fontWeight: FontWeight.bold,
              fontSize: SizeConfig.screenWidth * 0.04,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Theme.of(context).textSelectionColor),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
              itemCount: widget.delivery.length,
              itemBuilder: (context, i) {
                return GestureDetector(
                  onTap: () => Navigator.pop(context,
                      [widget.delivery[i].id, widget.delivery[i].name]),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.all(0),
                      leading: CircleAvatar(
                          backgroundColor: Colors.red,
                          child: Icon(
                            Icons.pedal_bike,
                            color: Colors.white,
                          )),
                      title: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            border: Border.all(
                                width: 2.0, color: Colors.grey[200])),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6),
                          child: Text(widget.delivery[i].name,
                              style: TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ));
  }
}
