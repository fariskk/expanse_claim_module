import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:expenseclaimmodule/common/common.dart';
import 'package:expenseclaimmodule/common/contstants.dart';
import 'package:expenseclaimmodule/common/size_configure.dart';
import 'package:expenseclaimmodule/features/homePage/provider/expanse_claim_provider.dart';
import 'package:expenseclaimmodule/utils/dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
        duration: const Duration(milliseconds: 200),
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
        duration: const Duration(milliseconds: 200),
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
              padding: const EdgeInsets.all(20),
              width: SizeConfigure.screenWidth,
              height: MediaQuery.of(context).viewInsets.bottom != 0
                  ? SizeConfigure.heightMultiplier * 70
                  : 450,
              decoration: const BoxDecoration(
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
                            padding: const EdgeInsets.all(19),
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
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
                                  child: const Icon(
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
                                      icon: const Icon(
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
                                      icon: const Icon(Icons.camera)),
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
                                      icon: const Icon(Icons.image)),
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
                      buttonDecoration: const BoxDecoration(
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

SizedBox myCostAllocationWidget(String title, String value) {
  return SizedBox(
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

Slidable myClaimDetailsWidget(int index, ExpanseClaimProvider provider,
    Map<dynamic, dynamic> claimDetails, BuildContext context) {
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
                          child: const Text("Cancel")),
                      TextButton(
                          onPressed: () {
                            claims.removeAt(index);
                            Navigator.pop(context);
                            provider.rebuild();
                          },
                          child: const Text("Ok"))
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
                cliamDetails: claimDetails, isToEdit: true, claimIndex: index);
          },
        ),
      ],
    ),
    child: Container(
      width: SizeConfigure.screenWidth,
      margin: const EdgeInsets.all(1),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            height: SizeConfigure.widthMultiplier * 13,
            width: SizeConfigure.widthMultiplier * 13,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Center(
              child: Icon(getIcon(claimDetails["claimType"])),
            ),
          ),
          mySpacer(width: SizeConfigure.widthMultiplier * 3),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: SizeConfigure.widthMultiplier * 40,
                      child: myText(
                        claimDetails["claimType"],
                        fontWeight: FontWeight.bold,
                        fontSize: 2,
                      ),
                    ),
                    myText("₹${claimDetails["amount"]}",
                        fontWeight: FontWeight.bold,
                        maxLength: 10,
                        color: kMainColor)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    myText(toDDMMMYYY(claimDetails["date"]),
                        fontSize: 1.5,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w700),
                    myViewAllocationWidget(context)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}

InkWell myViewAllocationWidget(BuildContext context) {
  return InkWell(
    onTap: () {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: myText("Cost Center Allocation",
                  fontWeight: FontWeight.bold, fontSize: 2),
              content: SizedBox(
                height: SizeConfigure.widthMultiplier * 90,
                width: SizeConfigure.widthMultiplier * 90,
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      children: [
                        myCostAllocationWidget("Refered Employee",
                            "Muhammed faris kk gg gyfycf fuf "),
                        const Divider(),
                        myCostAllocationWidget("T1", "Muhammed faris kk"),
                        const Divider(),
                        myCostAllocationWidget("T2", "Not Applicable"),
                        const Divider(),
                        myCostAllocationWidget("T3", "Functional expenses "),
                        const Divider(),
                        myCostAllocationWidget("T4", "Finance"),
                        const Divider(),
                        myCostAllocationWidget("Cost Center (%)", "100%"),
                        const Divider(),
                        myCostAllocationWidget("percentage", "100%"),
                        const Divider(),
                        myCostAllocationWidget("Cost Center Amount", "2000"),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Ok")),
              ],
            );
          });
    },
    child: myText("View Allocation",
        fontSize: 1.3, color: const Color.fromARGB(255, 122, 203, 240)),
  );
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
