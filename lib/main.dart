import 'dart:io';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.light(
        
        colors: FlexSchemeColor(
          primary: Colors.teal.shade700, // سبز یشمی (رنگ اصلی)
          secondary: Colors.amber.shade700, // طلایی (رنگ مکمل)
          tertiary: Colors.brown.shade600, // قهوه‌ای (حاشیه و جداکننده‌ها)
          appBarColor: Colors.teal.shade900, // سبز تیره برای هدر
        ),
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 10,
        appBarStyle: FlexAppBarStyle.primary,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 10,
          useTextTheme: true,
          // appBarElevated: true,
          defaultRadius: 10.0,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
        // fontFamily: 'osmantaha', // فونت فارسی
        fontFamily: GoogleFonts.vazirmatn().fontFamily, // فونت فارسی
      ),
      darkTheme: FlexThemeData.dark(
        colors: FlexSchemeColor(
          primary: Colors.teal.shade300,
          secondary: Colors.amber.shade300,
          tertiary: Colors.brown.shade300,
          appBarColor: Colors.teal.shade800,
        ),
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 10,
        appBarStyle: FlexAppBarStyle.primary,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 10,
          useTextTheme: true,
          // appBarElevated: true,
          defaultRadius: 10.0,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
        fontFamily: GoogleFonts.vazirmatn().fontFamily,
        // fontFamily: 'osmantaha',
      ),
      themeMode: ThemeMode.system, // تغییر خودکار بین حالت روشن و تاریک

      home: Directionality(textDirection: TextDirection.rtl, child: HomePage()),
    );
  }
}


