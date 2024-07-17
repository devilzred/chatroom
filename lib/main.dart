import 'package:chatroom/auth/loginpage.dart';
import 'package:chatroom/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding=WidgetsFlutterBinding.ensureInitialized();  //initializing Widgets
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);  //preserving splash screen
  //iniltiazing Firebase 
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
FlutterNativeSplash.remove();  //removing splah screen
runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    debugShowCheckedModeBanner: false,
      title: 'ChatRoom',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        primaryColorDark: AppColors.primaryDark,
        hintColor: AppColors.accent,
        scaffoldBackgroundColor: AppColors.background,
        textTheme: GoogleFonts.ralewayTextTheme(Theme.of(context).textTheme),
        primaryTextTheme: GoogleFonts.ralewayTextTheme(
          Theme.of(context).primaryTextTheme,),

        useMaterial3: true,
      ),
      home: LoginScreen(),
    );
  }
}
