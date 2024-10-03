import 'package:expenseclaimmodule/common/size_configure.dart';
import 'package:expenseclaimmodule/features/homePage/provider/expanse_claim_provider.dart';
import 'package:expenseclaimmodule/features/homePage/screens/expense_claim_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ExpanseClaimProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            fontFamily: GoogleFonts.manrope().fontFamily),
        home: LayoutBuilder(builder: (context, boxConstraints) {
          SizeConfigure().init(boxConstraints, Orientation.portrait);
          return ExpenseClaimScreen();
        }),
      ),
    );
  }
}
