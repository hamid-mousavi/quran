import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';
import 'package:quran_app/blocs/bloc/quran_bloc.dart';
import 'package:quran_app/blocs/cubit/quiz_settings_cubit.dart';
import 'package:quran_app/pages/home_page.dart';
import 'package:quran_app/pages/quize_page.dart';
import 'package:quran_app/repositories/database_helper.dart';
import 'package:quran_app/repositories/quran_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:quran_app/pages/quiz_settins_page.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          fontFamily: 'osmantaha',
          textTheme: TextTheme(),
          textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                  textStyle: WidgetStatePropertyAll(TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontFamily: 'osmantaha',
          )))),
          elevatedButtonTheme: const ElevatedButtonThemeData(
              style: ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll<Color>(
                      Colors.white), // تنظیم رنگ متن دکمه
                  backgroundColor:
                      WidgetStatePropertyAll<Color>(Color(0xFF004643)))),
          buttonTheme: const ButtonThemeData(
            buttonColor: Colors.blue, // رنگ پس زمینه دکمه‌ها
          ),
          scaffoldBackgroundColor: const Color(0xFFEFF0F3),
          appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFEFF0F3))),
      debugShowCheckedModeBanner: false,
      home: Directionality(textDirection: TextDirection.rtl, child: HomePage()),
    );
  }
}



// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   if (Platform.isWindows || Platform.isLinux) {
//     sqfliteFfiInit();
//     databaseFactory = databaseFactoryFfi;
//   }
//   final databaseHelper = DatabaseHelper();
//   final quranRepository = QuranRepository(databaseHelper);
//   runApp(MyApp(quranRepository: quranRepository));
// }

// class MyApp extends StatelessWidget {
//   final QuranRepository quranRepository;

//   const MyApp({Key? key, required this.quranRepository}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: MaterialApp(
//         title: 'Quran Quiz App',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//         ),
//         home: BlocProvider(
//           create: (_) => QuranBloc(quranRepository),
//           child: QuizPage(),
//         ),
//       ),
//     );
//   }
// }


