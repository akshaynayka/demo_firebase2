import '../screens/add_update_group_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/home_screen.dart';
import '../screens/auth_screen.dart';
import '../screens/profile_screen.dart';
import '../values/app_routes.dart';
import '../values/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: appColorPrimarySwatch,
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, authSnapshot) {
            if (authSnapshot.connectionState == ConnectionState.waiting) {
              return const Text('LOading...');
            } else if (authSnapshot.hasData) {
              return const HomeScreen();
            }
            return const AuthScreen();
          }),
      routes: {
        appRouteHomeScreen: (context) => const HomeScreen(),
        appRouteChatScreen: (context) => const ChatScreen(),
        appRouteProfileScreen: (context) => const ProfileScreen(),
        appRouteAddUpdateGroupScreen: (context) => const AddUpdateGroupScreen(),
      },
    );
  }
}
