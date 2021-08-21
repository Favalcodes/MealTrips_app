import 'package:flutter/material.dart';
import 'package:mealtrips/constants.dart';
import 'package:mealtrips/fooddel/components/default_buttons.dart';
import 'package:mealtrips/fooddel/data/model/premium_plan.dart';
import 'package:mealtrips/fooddel/data/repository/premium_repo.dart';
import 'package:mealtrips/fooddel/screens/widgets/progress_widget.dart';
import 'package:mealtrips/fooddel/utility/colorResources.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';
import 'package:mealtrips/fooddel/utility/style.dart';
import 'package:mealtrips/size_config.dart';

class UpdatePremiumPlan extends StatefulWidget {
  @override
  _UpdatePremiumPlanState createState() => _UpdatePremiumPlanState();
}

class _UpdatePremiumPlanState extends State<UpdatePremiumPlan> {
  TextEditingController planA = TextEditingController();
  TextEditingController planB = TextEditingController();
  TextEditingController planC = TextEditingController();

  PremiumModel premium;
  PremiumRepo premiumRepo = PremiumRepo();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getPackages();
  }

  void getPackages() async {
    setState(() => isLoading = true);
    premium = await premiumRepo.getPremium();
    setState(() {
      planA.text = premium.planA.toString();
      planB.text = premium.planB.toString();
      planC.text = premium.planC.toString();
    });
    setState(() => isLoading = false);
  }

  void updatePlan()async {
    
    await premiumRef.doc("25tqIfGs5H4aXWPBLbd1").set({
      'planA': double.parse(planA.text),
      'planB': double.parse(planB.text),
      'planC': double.parse(planC.text),
    });
    getPackages();
    SnackBar snackBar = SnackBar(content: Text("Premium plan updated"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Hero(
            tag: 7,
            child: Container(
              color: kPrimaryColor2,
              width: MediaQuery.of(context).size.width,
              height: 170.0,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Text("Subscription Plan",
                      style: poppinsBold.copyWith(
                          fontSize: 20, color: ColorResources.COLOR_WHITE)),
                ),
                Expanded(
                  child: isLoading ? circularProgress() :
                  ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      Container(
                          margin: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: ColorResources.COLOR_WHITE,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 20,
                                offset:
                                    Offset(3, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 15),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 15),
                                    // height: SizeConfig.screenHeight * 0.2,
                                    width: double.infinity,
                                    decoration: BoxDecoration(

                                        // boxShadow: [kDefaultShadow]
                                        ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '3 Months Plan',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      SizeConfig.screenWidth *
                                                          0.04,
                                                  color: Theme.of(context)
                                                      .textSelectionColor),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                  text: "N${planA.text}",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 17,
                                                      color: Theme.of(context)
                                                          .textSelectionColor),
                                                  children: [
                                                    TextSpan(
                                                      text: " /3 Months ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.grey,
                                                          fontSize: 10.0),
                                                    ),
                                                  ]),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        planAFormField(context)
                                      ],
                                    ),
                                  )),
                            ],
                          )),
                      Container(
                          margin: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: ColorResources.COLOR_WHITE,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 20,
                                offset:
                                    Offset(3, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 15),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 15),
                                    // height: SizeConfig.screenHeight * 0.2,
                                    width: double.infinity,
                                    decoration: BoxDecoration(

                                        // boxShadow: [kDefaultShadow]
                                        ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '6 Months plan',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      SizeConfig.screenWidth *
                                                          0.04,
                                                  color: Theme.of(context)
                                                      .textSelectionColor),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                  text: "N${planB.text}",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 17,
                                                      color: Theme.of(context)
                                                          .textSelectionColor),
                                                  children: [
                                                    TextSpan(
                                                      text: "/6 Months ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.grey,
                                                          fontSize: 10.0),
                                                    ),
                                                  ]),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        planBFormField(context)
                                      ],
                                    ),
                                  )),
                            ],
                          )),
                      Container(
                          margin: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: ColorResources.COLOR_WHITE,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 20,
                                offset:
                                    Offset(3, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 15),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 15),
                                    // height: SizeConfig.screenHeight * 0.2,
                                    width: double.infinity,
                                    decoration: BoxDecoration(

                                        // boxShadow: [kDefaultShadow]
                                        ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Yearly Plan',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      SizeConfig.screenWidth *
                                                          0.04,
                                                  color: Theme.of(context)
                                                      .textSelectionColor),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                  text: "N${planC.text}",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 17,
                                                      color: Theme.of(context)
                                                          .textSelectionColor),
                                                  children: [
                                                    TextSpan(
                                                      text: " / 1 year ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.grey,
                                                          fontSize: 10.0),
                                                    ),
                                                  ]),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 15.0,
                                        ),
                                        planCFormField(context),
                                      ],
                                    ),
                                  )),
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: DefaultButton(
                          press: () => updatePlan(),
                          text: 'Update plan',
                        ),
                      ),
                      SizedBox(height: 10.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextFormField planAFormField(context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: planA,
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Amount',
        labelText: 'Amount',
        hintStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        labelStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        suffixIcon: Icon(Icons.monetization_on),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.055, vertical: SizeConfig.screenWidth * 0.055),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(getProportionateScreenWidth(30)),
          borderSide: BorderSide(color: Theme.of(context).hintColor),
          gapPadding: 0,
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(getProportionateScreenWidth(30)),
            borderSide: BorderSide(color: Theme.of(context).textSelectionColor),
            gapPadding: 0),
        errorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(getProportionateScreenWidth(30)),
            borderSide: BorderSide(color: Colors.red),
            gapPadding: 0),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(getProportionateScreenWidth(20)),
            borderSide: BorderSide(color: Colors.red),
            gapPadding: 0),
      ),
    );
  }

  TextFormField planBFormField(context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: planB,
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Amount',
        labelText: 'Amount',
        hintStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        labelStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        suffixIcon: Icon(Icons.monetization_on),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.055, vertical: SizeConfig.screenWidth * 0.055),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(getProportionateScreenWidth(30)),
          borderSide: BorderSide(color: Theme.of(context).hintColor),
          gapPadding: 0,
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(getProportionateScreenWidth(30)),
            borderSide: BorderSide(color: Theme.of(context).textSelectionColor),
            gapPadding: 0),
        errorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(getProportionateScreenWidth(30)),
            borderSide: BorderSide(color: Colors.red),
            gapPadding: 0),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(getProportionateScreenWidth(20)),
            borderSide: BorderSide(color: Colors.red),
            gapPadding: 0),
      ),
    );
  }

  TextFormField planCFormField(context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: planC,
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Amount',
        labelText: 'Amount',
        hintStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        labelStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        suffixIcon: Icon(Icons.monetization_on),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.055, vertical: SizeConfig.screenWidth * 0.055),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(getProportionateScreenWidth(30)),
          borderSide: BorderSide(color: Theme.of(context).hintColor),
          gapPadding: 0,
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(getProportionateScreenWidth(30)),
            borderSide: BorderSide(color: Theme.of(context).textSelectionColor),
            gapPadding: 0),
        errorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(getProportionateScreenWidth(30)),
            borderSide: BorderSide(color: Colors.red),
            gapPadding: 0),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(getProportionateScreenWidth(20)),
            borderSide: BorderSide(color: Colors.red),
            gapPadding: 0),
      ),
    );
  }
}
