import 'package:chatroom/screens/activesession_page.dart';
import 'package:chatroom/screens/blocked_users.dart';
import 'package:chatroom/screens/forgetpass_page.dart';
import 'package:chatroom/auth/login_page.dart';
import 'package:chatroom/auth/signup_page.dart';
import 'package:chatroom/screens/home.dart';
import 'package:chatroom/screens/profile_page.dart';
import 'package:chatroom/utils/utils.dart';
import 'package:chatroom/components/error_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';

void main() async {

  // lock device orentation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  //load env file
  await dotenv.load(fileName: "lib/.env");
  
  //initialzed stripe key
  Stripe.publishableKey = dotenv.env['publishKey']!;

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
    errorMessage =
        'Failed to initialize the app. Please check your connection and try again.';
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

  const MyApp({Key? key, required this.initialRoute, this.errorMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChatRoom',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        primaryColorDark: AppColors.primaryDark,
        hintColor: Colors.blueGrey,
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
        '/profile': (context) => ProfilePage(),
        '/blocked': (context) => BlockedUserList(),
        '/active': (context) => ActivesessionPage(),
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
