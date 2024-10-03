import 'package:flutter/material.dart';

class ExpanseClaimProvider extends ChangeNotifier {
  bool isIndividulal = true;
  String? selectedCurrency = "INR";
  String? requestType;
  String? onBehalfEmployee;
  String? reimbursementType;
  String? paymentType;
  String? attachment;
  String? claimDate;
  String? claimType;

  void clearClaimDetails() {
    claimType = null;
    claimDate = null;
    attachment = null;
  }

  void rebuild() {
    notifyListeners();
  }
}
