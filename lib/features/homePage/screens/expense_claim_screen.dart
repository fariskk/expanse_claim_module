import 'package:expenseclaimmodule/common/button_global.dart';
import 'package:expenseclaimmodule/common/common.dart';
import 'package:expenseclaimmodule/common/contstants.dart';
import 'package:expenseclaimmodule/common/size_configure.dart';
import 'package:expenseclaimmodule/features/homePage/provider/expanse_claim_provider.dart';
import 'package:expenseclaimmodule/features/homePage/widgets/expense_claim_screen_widgets.dart';
import 'package:expenseclaimmodule/utils/dummy_data.dart';
import 'package:flutter/material.dart';
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
        for (var e in claims) {
          total = total + e["amount"];
        }
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
                padding: const EdgeInsets.all(20),
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
                            child: const Icon(
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
                              return myClaimDetailsWidget(
                                  index, provider, claimDetails, context);
                            })),
                    mySpacer(height: SizeConfigure.heightMultiplier * 1.5),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(5),
                          height: SizeConfigure.heightMultiplier * 6,
                          width: SizeConfigure.widthMultiplier * 30,
                          decoration: const BoxDecoration(
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
                              buttonDecoration: const BoxDecoration(
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
}
