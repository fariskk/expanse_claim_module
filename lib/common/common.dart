import 'package:expenseclaimmodule/common/contstants.dart';
import 'package:expenseclaimmodule/common/size_configure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

Text myText(String text,
    {double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    int? maxLength,
    TextOverflow textOverflow = TextOverflow.ellipsis}) {
  if (maxLength != null && text.length > maxLength) {
    if (maxLength < 9) {
      throw "maxLengh Must Be Grater Than 8";
    }
    List listedText = text.split("");
    String shortedString =
        "${listedText.getRange(0, maxLength - 8).join()}...${listedText.getRange(text.length - 5, text.length).join()}";
    text = shortedString;
  }
  return Text(
    text,
    overflow: textOverflow,
    style: GoogleFonts.manrope(
        color: color,
        fontSize: fontSize != null
            ? SizeConfigure.textMultiplier * fontSize
            : SizeConfigure.textMultiplier * 1.6,
        fontWeight: fontWeight),
  );
}

Widget mySpacer({double? height, double? width}) {
  return SizedBox(
    height: height,
    width: width,
  );
}

void mySnackBar(
  String text,
  BuildContext context,
) {
  Fluttertoast.showToast(
      msg: text, backgroundColor: const Color.fromARGB(255, 52, 52, 52));
}

TypeAheadField myTypeHeadDropDown(
    {required List<String> items,
    required String hintText,
    required String labelText,
    required String? value,
    required Function onSelected,
    required Function onCancel,
    InputBorder? inputBorder = const OutlineInputBorder(
        borderSide: BorderSide(color: kBorderColorTextField, width: 1.2))}) {
  return TypeAheadField(
    constraints: const BoxConstraints(
      maxHeight: 200,
    ),
    suggestionsCallback: (search) {
      return items
          .where(
              (element) => element.toUpperCase().contains(search.toUpperCase()))
          .toList();
    },
    builder: (context, controller, focusNode) {
      controller.text = value ?? "";
      controller.addListener(
        () {
          if (items.contains(controller.text)) {
            FocusScope.of(context).requestFocus(FocusNode());
          }
        },
      );
      return FocusScope(
        child: Focus(
          onFocusChange: (value) {
            if (!value) {
              if (!items.contains(controller.text)) {
                onCancel();
              }
            }
          },
          child: TextField(
              onChanged: (value) {
                if (items.contains(value)) {
                  onSelected(value);
                }
              },
              keyboardType: TextInputType.visiblePassword,
              readOnly: items.contains(controller.text),
              style: TextStyle(fontSize: SizeConfigure.textMultiplier * 1.8),
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                suffixIcon: Visibility(
                    visible: controller.text.isNotEmpty,
                    child: IconButton(
                        onPressed: () {
                          onCancel();
                        },
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.grey[600],
                        ))),
                border: inputBorder,
                focusedBorder: inputBorder,
                enabledBorder: inputBorder,
                hintStyle: const TextStyle(
                    fontWeight: FontWeight.normal, color: Colors.black45),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: labelText,
                labelStyle: TextStyle(
                    fontSize: SizeConfigure.textMultiplier * 1.6,
                    color: Colors.black45),
                hintText: hintText,
              )),
        ),
      );
    },
    itemBuilder: (context, sugession) {
      return Container(
        padding: const EdgeInsets.all(10.0),
        color: Colors.white,
        child:
            myText(sugession, textOverflow: TextOverflow.visible, fontSize: 2),
      );
    },
    onSelected: (workGroup) {
      onSelected(workGroup);
    },
  );
}

TextField myTextfield(String hintText,
    {int? minLines,
    int maxLines = 1,
    TextEditingController? controller,
    TextInputType? keyboardType}) {
  return TextField(
    style: TextStyle(fontSize: SizeConfigure.textMultiplier * 1.8),
    controller: controller,
    minLines: minLines,
    maxLines: maxLines,
    keyboardType: keyboardType,
    decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
        hintText: hintText,
        labelStyle: const TextStyle(
            fontWeight: FontWeight.normal, color: Colors.black45),
        hintStyle: const TextStyle(
            fontWeight: FontWeight.normal, color: Colors.black45),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        label: myText(
          hintText,
        ),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: kBorderColorTextField, width: 1.2)),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: kBorderColorTextField, width: 1.2)),
        border: const OutlineInputBorder(
            borderSide: BorderSide(color: kBorderColorTextField, width: 1.2))),
  );
}

class AutoNumberingTextField extends StatefulWidget {
  AutoNumberingTextField(
      {super.key,
      required this.hintText,
      required this.controller,
      this.minLines = 1,
      this.maxLines = 1});
  String hintText;
  int minLines;
  int maxLines;
  TextEditingController controller;
  @override
  State<AutoNumberingTextField> createState() => _TestState();
}

class _TestState extends State<AutoNumberingTextField> {
  String previusText = "";

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateNumbering);
  }

  void _updateNumbering() {
    String text = widget.controller.text;
    int j = text.split("\n").length;
    if (text == "1.") {
      text = "1. ";
    }
    if ((text.length < previusText.length) && text.length > 2) {
      if (text[text.length - 1] == "." && text[text.length - 3] == "\n") {
        text = text.substring(0, text.length - 3);
      }
    } else {
      if (text.isNotEmpty && text[text.length - 1] == "\n" && text.length > 2) {
        if (text[text.length - 3] == ".") {
          text = text.substring(0, text.length - 1);
        } else {
          text = "$text$j. ";
        }
      }
    }

    String updatedText = text;
    previusText = updatedText;
    widget.controller.value = TextEditingValue(
      text: updatedText,
      selection: TextSelection.collapsed(offset: updatedText.length),
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateNumbering);
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Focus(
        onFocusChange: (focus) {
          if (!focus) {
            if (widget.controller.text == "1. ") {
              widget.controller.removeListener(_updateNumbering);
              widget.controller.text = "";
            }
            List lines = widget.controller.text.split("\n");
            if (lines.last.length == 3) {
              lines.removeAt(lines.length - 1);
              widget.controller.text = lines.join("\n");
            }
          }
          if (focus) {
            widget.controller.addListener(_updateNumbering);
            if (widget.controller.text == "") {
              widget.controller.value = const TextEditingValue(
                text: "1. ",
                selection: TextSelection.collapsed(offset: 3),
              );
            }
          }
        },
        child: TextField(
          style: TextStyle(fontSize: SizeConfigure.textMultiplier * 1.8),
          controller: widget.controller,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: widget.hintText,
              hintStyle: const TextStyle(fontWeight: FontWeight.normal),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              label: myText(widget.hintText)),
        ),
      ),
    );
  }
}

String toDDMMMYYY(String date) {
  List dateParts = date.split("/");
  return "${dateParts[0]}-${getMountString(dateParts[1])}-${dateParts[2]}"
      .toUpperCase();
}

String getDate(DateTime date) {
  return "${date.day}/${date.month}/${date.year}";
}

String getMountString(String mount) {
  switch (mount) {
    case "1":
      return "Jan";
    case "2":
      return "Feb";
    case "3":
      return "Mar";
    case "4":
      return "Apr";
    case "5":
      return "May";
    case "6":
      return "Jun";
    case "7":
      return "Jul";
    case "8":
      return "Aug";
    case "9":
      return "Sep";
    case "10":
      return "Oct";
    case "11":
      return "Nov";
    case "12":
      return "Des";
    default:
      return "error";
  }
}
