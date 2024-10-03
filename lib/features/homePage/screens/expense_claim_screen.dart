import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_picker_dialog.dart';
import 'package:country_currency_pickers/currency_picker_dialog.dart';
import 'package:country_currency_pickers/utils/utils.dart';
import 'package:expenseclaimmodule/common/button_global.dart';
import 'package:expenseclaimmodule/common/common.dart';
import 'package:expenseclaimmodule/common/contstants.dart';
import 'package:expenseclaimmodule/common/size_configure.dart';
import 'package:expenseclaimmodule/features/homePage/provider/expanse_claim_provider.dart';
import 'package:expenseclaimmodule/features/homePage/widgets/expense_claim_screen_widgets.dart';
import 'package:expenseclaimmodule/utils/dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class ExpenseClaimScreen extends StatelessWidget {
  ExpenseClaimScreen({super.key});
  double total = 0;
  double pettrBal = 0;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child:
          Consumer<ExpanseClaimProvider>(builder: (context, provider, child) {
        total = 0;
        claims.forEach((e) {
          total = total + e["amount"];
        });
        return Scaffold(
          backgroundColor: kMainColor,
          appBar: AppBar(
            backgroundColor: kMainColor,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
            title: myText("Expanse Claim Request",
                fontSize: 2, color: Colors.white),
            bottom: TabBar(
                dividerHeight: 8,
                labelPadding: EdgeInsets.zero,
                dividerColor: kBgColor,
                indicatorColor: Colors.transparent,
                tabs: myTabs(context, provider)),
          ),
          body: InkWell(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                width: SizeConfigure.screenWidth,
                height: SizeConfigure.screenHeight - 130,
                decoration: const BoxDecoration(
                  color: kBgColor,
                ),
                child: Column(
                  children: [
                    mySpacer(height: SizeConfigure.heightMultiplier * 1),
                    Visibility(
                      visible: !provider.isIndividulal,
                      child: Column(
                        children: [
                          myTypeHeadDropDown(
                              items: [
                                "Item 1",
                                "Item 2",
                                "Item 3",
                                "Item 4",
                              ],
                              hintText: "-select employee-",
                              labelText: "select employee",
                              value: provider.onBehalfEmployee,
                              onSelected: (value) {
                                provider.onBehalfEmployee = value;
                                provider.rebuild();
                              },
                              onCancel: () {
                                provider.onBehalfEmployee = null;
                                provider.rebuild();
                              }),
                          mySpacer(
                              height: SizeConfigure.heightMultiplier * 2.8),
                        ],
                      ),
                    ),
                    myTypeHeadDropDown(
                        items: [
                          "Item 1",
                          "Item 2",
                          "Item 3",
                          "Item 4",
                        ],
                        hintText: "-select request type-",
                        labelText: "select request type",
                        value: provider.requestType,
                        onSelected: (value) {
                          provider.requestType = value;
                          provider.rebuild();
                        },
                        onCancel: () {
                          provider.requestType = null;
                          provider.rebuild();
                        }),
                    mySpacer(height: SizeConfigure.heightMultiplier * 2.8),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: myTypeHeadDropDown(
                              items: [
                                "Item 1",
                                "Item 2",
                                "Item 3",
                                "Item 4",
                              ],
                              hintText: "-currency-",
                              labelText: "currency",
                              value: provider.selectedCurrency,
                              onSelected: (value) {
                                provider.selectedCurrency = value;
                                provider.rebuild();
                              },
                              onCancel: () {
                                provider.selectedCurrency = null;
                                provider.rebuild();
                              }),
                        ),
                        mySpacer(width: SizeConfigure.widthMultiplier * 2.8),
                        Expanded(
                          flex: 2,
                          child: myTypeHeadDropDown(
                              items: [
                                "Item 1",
                                "Item 2",
                                "Item 3",
                                "Item 4",
                              ],
                              hintText: "-select payment type-",
                              labelText: "select payment type",
                              value: provider.paymentType,
                              onSelected: (value) {
                                provider.paymentType = value;
                                provider.rebuild();
                              },
                              onCancel: () {
                                provider.paymentType = null;
                                provider.rebuild();
                              }),
                        ),
                      ],
                    ),
                    mySpacer(height: SizeConfigure.heightMultiplier * 2.8),
                    myTypeHeadDropDown(
                        items: [
                          "Item 1",
                          "Item 2",
                          "Item 3",
                          "Item 4",
                        ],
                        hintText: "-select reimbursement type-",
                        labelText: "select reimbursement type",
                        value: provider.reimbursementType,
                        onSelected: (value) {
                          provider.reimbursementType = value;
                          provider.rebuild();
                        },
                        onCancel: () {
                          provider.reimbursementType = null;
                          provider.rebuild();
                        }),
                    mySpacer(height: SizeConfigure.heightMultiplier * 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        myText("Claim Details",
                            fontSize: 2, fontWeight: FontWeight.bold),
                        InkWell(
                            onTap: () {
                              myAddClaimBottomSheet(context, provider);
                            },
                            child: Icon(
                              Icons.add_box,
                              size: 30,
                            ))
                      ],
                    ),
                    mySpacer(height: SizeConfigure.heightMultiplier * 1.5),
                    Expanded(
                        child: ListView.builder(
                            itemCount: claims.length,
                            itemBuilder: (context, index) {
                              Map claimDetails = claims[index];
                              return Slidable(
                                endActionPane: ActionPane(
                                  extentRatio: .55,
                                  motion: const DrawerMotion(),
                                  children: [
                                    SlidableAction(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      icon: Icons.delete,
                                      label: 'Delete',
                                      onPressed: (BuildContext context) {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: myText("Delete item?"),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("Cancel")),
                                                  TextButton(
                                                      onPressed: () {
                                                        claims.removeAt(index);
                                                        Navigator.pop(context);
                                                        provider.rebuild();
                                                      },
                                                      child: Text("Ok"))
                                                ],
                                              );
                                            });
                                      },
                                    ),
                                    SlidableAction(
                                      backgroundColor: Colors.white,
                                      key: UniqueKey(),
                                      foregroundColor: Colors.black,
                                      icon: Icons.edit,
                                      label: 'Edit',
                                      onPressed: (BuildContext context) {
                                        myAddClaimBottomSheet(context, provider,
                                            cliamDetails: claimDetails,
                                            isToEdit: true,
                                            claimIndex: index);
                                      },
                                    ),
                                  ],
                                ),
                                child: Container(
                                  width: SizeConfigure.screenWidth,
                                  margin: EdgeInsets.all(1),
                                  child: Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(5),
                                        height:
                                            SizeConfigure.widthMultiplier * 13,
                                        width:
                                            SizeConfigure.widthMultiplier * 13,
                                        decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Center(
                                          child: Icon(getIcon(
                                              claimDetails["claimType"])),
                                        ),
                                      ),
                                      mySpacer(
                                          width: SizeConfigure.widthMultiplier *
                                              3),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: SizeConfigure
                                                          .widthMultiplier *
                                                      40,
                                                  child: myText(
                                                    claimDetails["claimType"],
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 2,
                                                  ),
                                                ),
                                                myText(
                                                    "₹${claimDetails["amount"]}",
                                                    fontWeight: FontWeight.bold,
                                                    maxLength: 10,
                                                    color: kMainColor)
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                myText(
                                                    toDDMMMYYY(
                                                        claimDetails["date"]),
                                                    fontSize: 1.5,
                                                    color: Colors.grey[600],
                                                    fontWeight:
                                                        FontWeight.w700),
                                                InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: myText(
                                                                "Cost Center Allocation",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 2),
                                                            content: SizedBox(
                                                              height: SizeConfigure
                                                                      .widthMultiplier *
                                                                  90,
                                                              width: SizeConfigure
                                                                      .widthMultiplier *
                                                                  90,
                                                              child:
                                                                  SingleChildScrollView(
                                                                child:
                                                                    Container(
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                              .grey[
                                                                          200],
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(10))),
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              5),
                                                                  margin: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              5),
                                                                  child: Column(
                                                                    children: [
                                                                      myCostAllocationWidget(
                                                                          "Refered Employee",
                                                                          "Muhammed faris kk gg gyfycf fuf "),
                                                                      Divider(),
                                                                      myCostAllocationWidget(
                                                                          "T1",
                                                                          "Muhammed faris kk"),
                                                                      Divider(),
                                                                      myCostAllocationWidget(
                                                                          "T2",
                                                                          "Not Applicable"),
                                                                      Divider(),
                                                                      myCostAllocationWidget(
                                                                          "T3",
                                                                          "Functional expenses "),
                                                                      Divider(),
                                                                      myCostAllocationWidget(
                                                                          "T4",
                                                                          "Finance"),
                                                                      Divider(),
                                                                      myCostAllocationWidget(
                                                                          "Cost Center (%)",
                                                                          "100%"),
                                                                      Divider(),
                                                                      myCostAllocationWidget(
                                                                          "percentage",
                                                                          "100%"),
                                                                      Divider(),
                                                                      myCostAllocationWidget(
                                                                          "Cost Center Amount",
                                                                          "2000"),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                      "Cancel")),
                                                              TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                      "Ok")),
                                                            ],
                                                          );
                                                        });
                                                  },
                                                  child: myText(
                                                      "View Allocation",
                                                      fontSize: 1.3,
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              122,
                                                              203,
                                                              240)),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            })),
                    mySpacer(height: SizeConfigure.heightMultiplier * 1.5),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.all(5),
                          height: SizeConfigure.heightMultiplier * 6,
                          width: SizeConfigure.widthMultiplier * 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              myText("Total :₹$total",
                                  fontWeight: FontWeight.bold),
                              myText("Petty Bal :₹1000",
                                  fontSize: 1, fontWeight: FontWeight.w600)
                            ],
                          ),
                        ),
                        Expanded(
                          child: ButtonGlobal(
                              buttontext: "submit",
                              buttonDecoration: BoxDecoration(
                                  color: kMainColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              onPressed: () {}),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Container myCostAllocationWidget(String title, String value) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: myText(title, fontSize: 1.2),
              ),
              mySpacer(width: SizeConfigure.widthMultiplier * 2),
              Expanded(child: myText(value, fontSize: 1.2))
            ],
          )
        ],
      ),
    );
  }
}

IconData getIcon(String text) {
  switch (text) {
    case "food":
      return Icons.lunch_dining;
    case "travel":
      return Icons.two_wheeler;
    case "accommodation":
      return Icons.cabin;

    default:
      return Icons.token;
  }
}
