import 'package:country_currency_pickers/country.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
