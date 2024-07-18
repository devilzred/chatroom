
import 'package:chatroom/auth/forgetpass_page.dart';
import 'package:chatroom/auth/login_page.dart';
import 'package:chatroom/auth/signup_page.dart';
import 'package:chatroom/screens/home.dart';
import 'package:chatroom/utils/utils.dart';
import 'package:chatroom/widgets/error_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  
  // Preserve native splash screen
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  
  String initialRoute = '/login';
  String? errorMessage;

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Check if user is logged in
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      initialRoute = '/home';
    }
  } catch (e) {
    print('Error initializing Firebase: $e');
    errorMessage = 'Failed to initialize the app. Please check your connection and try again.';
  } finally {
    // Remove splash screen
    FlutterNativeSplash.remove();
  }

  // Run the app
  runApp(MyApp(initialRoute: initialRoute, errorMessage: errorMessage));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  final String? errorMessage;

  const MyApp({Key? key, required this.initialRoute, this.errorMessage}) : super(key: key);

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
          Theme.of(context).primaryTextTheme,
        ),
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      routes: {
        '/home': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/forgotpass': (context) => ForgetpassPage(),
      },
      builder: (context, child) {
        return ErrorHandler(
          errorMessage: errorMessage,
          child: child!,
        );
      },
    );
  }
  
}

