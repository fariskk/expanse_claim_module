import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:camera/camera.dart';
import 'package:expenseclaimmodule/common/common.dart';
import 'package:expenseclaimmodule/common/contstants.dart';
import 'package:expenseclaimmodule/common/size_configure.dart';
import 'package:expenseclaimmodule/features/homePage/provider/expanse_claim_provider.dart';
import 'package:expenseclaimmodule/features/homePage/screens/expense_claim_screen.dart';
import 'package:expenseclaimmodule/utils/dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../common/button_global.dart';

List<Widget> myTabs(BuildContext context, ExpanseClaimProvider provider) {
  return [
    GestureDetector(
      onTap: () async {
        provider.isIndividulal = true;
        provider.rebuild();
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: const EdgeInsets.only(bottom: 5),
        height: 50,
        width: MediaQuery.of(context).size.width / 2,
        decoration: BoxDecoration(
            color: provider.isIndividulal ? kBgColor : kMainColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Align(
            alignment: Alignment.bottomCenter,
            child: myText(
              "Individual",
              fontWeight: FontWeight.w700,
              fontSize: 2,
              color: provider.isIndividulal ? kMainColor : kBgColor,
            )),
      ),
    ),
    GestureDetector(
      onTap: () {
        provider.isIndividulal = false;
        provider.rebuild();
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: const EdgeInsets.only(bottom: 5),
        height: 50,
        width: MediaQuery.of(context).size.width / 2,
        decoration: BoxDecoration(
            color: provider.isIndividulal ? kMainColor : kBgColor,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Align(
            alignment: Alignment.bottomCenter,
            child: myText(
              "On Behalf",
              fontWeight: FontWeight.w700,
              fontSize: 2,
              color: provider.isIndividulal ? kBgColor : kMainColor,
            )),
      ),
    ),
  ];
}

void myAddClaimBottomSheet(BuildContext context, ExpanseClaimProvider provider,
    {bool isToEdit = false, Map? cliamDetails, int? claimIndex}) {
  TextEditingController remarksController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  provider.clearClaimDetails();
  if (isToEdit) {
    provider.claimType = cliamDetails!["claimType"];
    remarksController.text = cliamDetails["remarks"];
    amountController.text = cliamDetails["amount"].toString();
    provider.claimDate = cliamDetails["date"];
    provider.attachment = cliamDetails["attachment"];
  }
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Consumer<ExpanseClaimProvider>(
            builder: (context, provider, child) {
          return InkWell(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              padding: EdgeInsets.all(20),
              width: SizeConfigure.screenWidth,
              height: MediaQuery.of(context).viewInsets.bottom != 0
                  ? SizeConfigure.heightMultiplier * 70
                  : 450,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    myText("Claim Details",
                        fontSize: 2, fontWeight: FontWeight.bold),
                    mySpacer(height: SizeConfigure.heightMultiplier * 2),
                    myTypeHeadDropDown(
                        items: [
                          "Item 1",
                          "Item 2",
                          "Item 3",
                          "Item 4",
                        ],
                        hintText: "-select claim type-",
                        labelText: "select claim type",
                        value: provider.claimType,
                        onSelected: (value) {
                          provider.claimType = value;
                          provider.rebuild();
                        },
                        onCancel: () {
                          provider.claimType = null;
                          provider.rebuild();
                        }),
                    mySpacer(height: SizeConfigure.heightMultiplier * 2),
                    Row(
                      children: [
                        Expanded(
                            child: myTextfield("amount",
                                controller: amountController,
                                keyboardType: TextInputType.number)),
                        mySpacer(width: SizeConfigure.widthMultiplier * 2),
                        InkWell(
                          onTap: () async {
                            var res = await showCalendarDatePicker2Dialog(
                                context: context,
                                config:
                                    CalendarDatePicker2WithActionButtonsConfig(),
                                dialogSize: Size(
                                  SizeConfigure.screenWidth - 40,
                                  SizeConfigure.screenWidth - 40,
                                ));
                            if (res != null) {
                              provider.claimDate = getDate(res[0]!);
                              provider.rebuild();
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(19),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                border: Border.all(
                                    color: kBorderColorTextField, width: 1.2)),
                            child: Row(
                              children: [
                                provider.claimDate != null
                                    ? myText(provider.claimDate!)
                                    : myText("-select date-",
                                        color: Colors.black45),
                                mySpacer(
                                    width: SizeConfigure.widthMultiplier * 2),
                                Visibility(
                                  visible: provider.claimDate != null,
                                  child: Icon(
                                    Icons.cancel,
                                    size: 18,
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    mySpacer(height: SizeConfigure.heightMultiplier * 2),
                    myTextfield("remarks", controller: remarksController),
                    mySpacer(height: SizeConfigure.heightMultiplier * 1.5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        myText("Attachment",
                            fontSize: 2, fontWeight: FontWeight.w600),
                        provider.attachment != null
                            ? Row(
                                children: [
                                  myText(provider.attachment!, maxLength: 18),
                                  IconButton(
                                      onPressed: () {
                                        provider.attachment = null;
                                        provider.rebuild();
                                      },
                                      icon: Icon(
                                        Icons.cancel,
                                        size: 15,
                                      ))
                                ],
                              )
                            : Row(
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        final ImagePicker picker =
                                            ImagePicker();
                                        final XFile? image =
                                            await picker.pickImage(
                                                source: ImageSource.camera);
                                        if (image != null) {
                                          provider.attachment = image.name;
                                          provider.rebuild();
                                        }
                                      },
                                      icon: Icon(Icons.camera)),
                                  IconButton(
                                      onPressed: () async {
                                        final ImagePicker picker =
                                            ImagePicker();
                                        final XFile? image =
                                            await picker.pickImage(
                                                source: ImageSource.gallery);
                                        if (image != null) {
                                          provider.attachment = image.name;
                                          provider.rebuild();
                                        }
                                      },
                                      icon: Icon(Icons.image)),
                                ],
                              ),
                      ],
                    ),
                    mySpacer(height: SizeConfigure.heightMultiplier * 1.5),
                    ButtonGlobal(
                      buttontext: isToEdit ? "Update" : "Submit",
                      onPressed: () {
                        if (provider.claimType == null) {
                          mySnackBar("please select claim type", context);
                        } else if (amountController.text.isEmpty) {
                          mySnackBar("please enter amount", context);
                        } else if (double.tryParse(amountController.text) ==
                            null) {
                          mySnackBar("please enter a valied amount", context);
                        } else if (provider.claimDate == null) {
                          mySnackBar("please select date", context);
                        } else if (provider.attachment == null) {
                          mySnackBar("please select attachmet", context);
                        } else {
                          Map newClaim = {
                            "claimType": provider.claimType,
                            "date": provider.claimDate!,
                            "amount": double.parse(amountController.text),
                            "remarks": remarksController.text,
                            "attachment": provider.attachment!,
                          };
                          if (isToEdit) {
                            claims[claimIndex!] = newClaim;
                          } else {
                            claims.add(newClaim);
                          }
                          Navigator.pop(context);
                          provider.rebuild();
                        }
                      },
                      buttonDecoration: BoxDecoration(
                          color: kMainColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      });
}
