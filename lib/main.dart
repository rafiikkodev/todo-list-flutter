import 'package:flutter/material.dart';
import 'package:template_project_flutter/pages/home_page.dart';
import 'package:template_project_flutter/pages/todo_page.dart';
import 'package:template_project_flutter/shared/theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: lightBackgoundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: lightBackgoundColor,
          surfaceTintColor: lightBackgoundColor,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: blackPrimaryColor),
          titleTextStyle: blackPrimaryTextStyle.copyWith(
            fontSize: 20,
            fontWeight: semiBold,
          ),
        ),
      ),
      routes: {
        "/": (context) => const HomePage(),
        "/todo": (context) => const TodoPage(),
      },
    );
  }
}
