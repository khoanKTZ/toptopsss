import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tiktok_app_poly/provider/LoginFacebook_provider.dart';
import 'package:tiktok_app_poly/provider/comment_model.dart';
import 'package:tiktok_app_poly/provider/gender_model.dart';
import 'package:tiktok_app_poly/provider/loading_model.dart';
import 'package:tiktok_app_poly/provider/login_phone.dart';
import 'package:tiktok_app_poly/provider/save_model.dart';
import 'package:tiktok_app_poly/provider/search_model.dart';
import 'package:tiktok_app_poly/views/pages/auth/auth_screen.dart';
import 'package:tiktok_app_poly/views/pages/auth/login_phone_screen.dart';
import 'package:tiktok_app_poly/views/pages/home/shearch/shearch_video_screen.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GenderModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cmodel(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoadingModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SaveModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoginPhoneProvider(),
          child: LoginWithPhoneNumber(),
        ),
        ChangeNotifierProvider(
          create: (context) => VideoProvider(),
          child: ShearchVideo(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoginFacebookProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App',
      theme: ThemeData(
        textTheme: GoogleFonts.varelaRoundTextTheme().copyWith(
            bodySmall: const TextStyle(fontFamily: "Tiktok_Sans"),
            bodyMedium: const TextStyle(fontFamily: "Tiktok_Sans"),
            bodyLarge: const TextStyle(fontFamily: "Tiktok_Sans")),
      ),
      home: LoginAll(),
      // home: const ShearchVideo(),
      // home: TestAnimation(),
    );
  }
}
