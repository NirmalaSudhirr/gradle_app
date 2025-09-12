import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grading_app/views/home_screen.dart';
import 'package:grading_app/widgets/utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'QR Report',
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.bgGray,
            textTheme: GoogleFonts.interTextTheme(),
            primaryColor: AppColors.darkGreen,
            appBarTheme: const AppBarTheme(backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0.5),
          ),
          home: HomeScreen(),
        );
      },
    );
  }
}
