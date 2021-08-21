import 'package:flutter/material.dart';
import 'package:mealtrips/constants.dart';
import 'package:mealtrips/fooddel/data/model/premium_plan.dart';
import 'package:mealtrips/fooddel/data/repository/premium_repo.dart';
import 'package:mealtrips/fooddel/screens/homepage/home_tab.dart';
import 'package:mealtrips/fooddel/screens/vendor/vendor_screen.dart';
import 'package:mealtrips/fooddel/screens/widgets/progress_widget.dart';
import 'package:mealtrips/fooddel/services/premium_service.dart';
import 'package:mealtrips/fooddel/services/users_service.dart';
import 'package:mealtrips/fooddel/utility/colorResources.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';
import 'package:mealtrips/fooddel/utility/style.dart';
import 'package:mealtrips/size_config.dart';

class PremiumPackage extends StatefulWidget {
  final String email, name, screen, userId;
  PremiumPackage({this.email, this.name, this.screen, this.userId});
  @override
  _PremiumPackageState createState() => _PremiumPackageState();
}

class _PremiumPackageState extends State<PremiumPackage> {
  PremiumModel premium;
  PremiumRepo premiumRepo = PremiumRepo();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeSdk();
    getPackages();
  }

  void getPackages() async {
    premium = await premiumRepo.getPremium();
    setState(() => premium = premium);
    setState(() => isLoading = false);
  }

  Future<void> subscribeUser(subscriptionPlan) async {
    resturantRef
        .doc(widget.userId)
        .update({'premium': true, 'plan': subscriptionPlan, 'subDate': now});
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => HomeTabs()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? circularProgress()
          : Stack(
              children: [
                Hero(
                  tag: 7,
                  child: Container(
                    color: Colors.red,
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
                                fontSize: 20,
                                color: ColorResources.COLOR_WHITE)),
                      ),
                      Expanded(
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          children: [
                            widget.screen == "newUser"
                                ? GestureDetector(
                                    onTap: () => subscribeUser(0),
                                    child: Container(
                                        margin: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: ColorResources.COLOR_WHITE,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              spreadRadius: 2,
                                              blurRadius: 20,
                                              offset: Offset(3,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15,
                                                    vertical: 15),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 15),
                                                  // height: SizeConfig.screenHeight * 0.2,
                                                  width: double.infinity,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            'Trial Plan',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: SizeConfig
                                                                        .screenWidth *
                                                                    0.04,
                                                                color: Colors.black),
                                                          ),
                                                          RichText(
                                                            text: TextSpan(
                                                                text: "N0.0",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        17,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .textSelectionColor),
                                                                children: [
                                                                  TextSpan(
                                                                    text:
                                                                        " /1 year ",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        color: Colors
                                                                            .grey,
                                                                        fontSize:
                                                                            10.0),
                                                                  ),
                                                                ]),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 3.0,
                                                      ),
                                                      Text(
                                                          "Upload and sell dishes to your customers  free, for a year",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 14.0)),
                                                      SizedBox(
                                                        height: 5.0,
                                                      ),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            color:
                                                                kPrimaryColor2,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4.0)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 4.0,
                                                                  horizontal:
                                                                      8.0),
                                                          child: Text(
                                                            "Start Trial",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                          ],
                                        )),
                                  )
                                :
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () => premiumService(context,
                                      email: widget.email,
                                      name: widget.name,
                                      userId: widget.userId,
                                      amount: premium.planA,
                                      subscriptionPlan: 1),
                                  child: Container(
                                      margin: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: ColorResources.COLOR_WHITE,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            spreadRadius: 2,
                                            blurRadius: 20,
                                            offset: Offset(
                                                3, 3), // changes position of shadow
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
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          '3 Months Plan',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              fontSize: SizeConfig
                                                                      .screenWidth *
                                                                  0.04,
                                                              color: Theme.of(
                                                                      context)
                                                                  .textSelectionColor),
                                                        ),
                                                        RichText(
                                                          text: TextSpan(
                                                              text:
                                                                  "N${premium.planA}",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 17,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .textSelectionColor),
                                                              children: [
                                                                TextSpan(
                                                                  text:
                                                                      " /3 Months ",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          10.0),
                                                                ),
                                                              ]),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 3.0,
                                                    ),
                                                    Text(
                                                        "Upload and sell dishes to your customers  for 3 months",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 14.0)),
                                                    SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          color: kPrimaryColor,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  4.0)),
                                                      child: Padding(
                                                        padding: const EdgeInsets
                                                                .symmetric(
                                                            vertical: 4.0,
                                                            horizontal: 8.0),
                                                        child: Text(
                                                          "Select Plan",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight.w500,
                                                              color: Colors.white,
                                                              fontSize: 14.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ],
                                      )),
                                ),
                                 GestureDetector(
                                onTap: () => premiumService(context,
                                    email: widget.email,
                                    name: widget.email,
                                    userId: widget.userId,
                                    amount: premium.planA,
                                    subscriptionPlan: 0),
                                child: Container(
                                    margin: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: ColorResources.COLOR_WHITE,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 20,
                                          offset: Offset(3,
                                              3), // changes position of shadow
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
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        '6 Months plan',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: SizeConfig
                                                                    .screenWidth *
                                                                0.04,
                                                            color: Theme.of(
                                                                    context)
                                                                .textSelectionColor),
                                                      ),
                                                      RichText(
                                                        text: TextSpan(
                                                            text:
                                                                "N${premium.planB}",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 17,
                                                                color: Theme.of(
                                                                        context)
                                                                    .textSelectionColor),
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    " /6 Months ",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        10.0),
                                                              ),
                                                            ]),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 3.0,
                                                  ),
                                                  Text(
                                                      "Upload and sell dishes to your customers  for 6  Months.",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14.0)),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: kPrimaryColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.0)),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 4.0,
                                                          horizontal: 8.0),
                                                      child: Text(
                                                        "Select plan",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.white,
                                                            fontSize: 14.0),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ],
                                    ))),
                            GestureDetector(
                                onTap: () => premiumService(context,
                                    email: widget.email,
                                    name: widget.name,
                                    userId: widget.userId,
                                    amount: premium.planA,
                                    subscriptionPlan: 3),
                                child: Container(
                                    margin: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: ColorResources.COLOR_WHITE,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 20,
                                          offset: Offset(3,
                                              3), // changes position of shadow
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
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Yearly Plan',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: SizeConfig
                                                                    .screenWidth *
                                                                0.04,
                                                            color: Theme.of(
                                                                    context)
                                                                .textSelectionColor),
                                                      ),
                                                      RichText(
                                                        text: TextSpan(
                                                            text:
                                                                "N${premium.planC}",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 17,
                                                                color: Theme.of(
                                                                        context)
                                                                    .textSelectionColor),
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    " / 1 year ",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        10.0),
                                                              ),
                                                            ]),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 3.0,
                                                  ),
                                                  Text(
                                                      "Upload and sell dishes to your customers  for a year.",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14.0)),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: kPrimaryColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.0)),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 4.0,
                                                          horizontal: 8.0),
                                                      child: Text(
                                                        "Select plan",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.white,
                                                            fontSize: 14.0),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ],
                                    ))),
                              ],
                            ),
                           
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
}
