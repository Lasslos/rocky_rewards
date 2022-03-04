import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:rocky_rewards/widgets/home_page.dart';

const Color primary = Color(0xFFCC0A2D);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: ThemeData.from(
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: primary,
      ),
    ),
    localizationsDelegates: const [
      MonthYearPickerLocalizations.delegate,
    ],
    darkTheme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: primary,
    ),
    home: const HomePage(),
  );
}
