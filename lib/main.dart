import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tiktok_app_poly/database/services/notifi_service.dart';
import 'package:tiktok_app_poly/provider/LoginFacebook_provider.dart';
import 'package:tiktok_app_poly/provider/comment_model.dart';
import 'package:tiktok_app_poly/provider/gender_model.dart';
import 'package:tiktok_app_poly/provider/loading_model.dart';
import 'package:tiktok_app_poly/provider/login_phone.dart';
import 'package:tiktok_app_poly/provider/notifi_model_check.dart';
import 'package:tiktok_app_poly/provider/save_model.dart';
import 'package:tiktok_app_poly/provider/search_model.dart';
import 'package:tiktok_app_poly/views/pages/auth/auth_screen.dart';
import 'package:tiktok_app_poly/views/pages/auth/login_phone_screen.dart';
import 'package:tiktok_app_poly/views/pages/home/home_screen.dart';
import 'package:tiktok_app_poly/views/pages/home/shearch/shearch_video_screen.dart';

import 'firebase_options.dart';


Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  const storage = FlutterSecureStorage();
  String? UID = await storage.read(key: 'uID');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GenderModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => NotifiCheck(),
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
      child: MyApp(uID : UID),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({Key? key,required this.uID}) : super(key: key);
  String? uID;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final notification = NotificationsService();
  @override
  void initState() {
    super.initState();
    notification.firebaseNotification(context);
  }
  @override
  Widget build(BuildContext context) {
    print(widget.uID.toString());
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App',
      theme: ThemeData(
        textTheme: GoogleFonts.varelaRoundTextTheme().copyWith(
            bodySmall: const TextStyle(fontFamily: "Tiktok_Sans"),
            bodyMedium: const TextStyle(fontFamily: "Tiktok_Sans"),
            bodyLarge: const TextStyle(fontFamily: "Tiktok_Sans")),
      ),
      home: widget.uID != null ? HomeScreen() : const LoginAll(),
    );
  }
}
