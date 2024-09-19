import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:koi_detection_flutter_app/authentication/login.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
 @override
  void initState() {
    super.initState();
    _checkInternetConnection();
  }

  // Function to check internet connectivity
  void _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    
    if (connectivityResult.contains(ConnectivityResult.none)) {
      // No internet connection, show error dialog or navigate to no connection screen
      _showNoInternetDialog();
    }
  }



  // Function to show no internet connection dialog
  void _showNoInternetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("No Internet Connection"),
        content: const Text("Please check your internet connection and try again."),
        actions: [
          TextButton(
            child: const Text("Retry"),
            onPressed: () {
              Navigator.of(context).pop();
              _checkInternetConnection(); // Retry checking internet connection
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AnimatedSplashScreen(
        splash: Column(
          children: [
            Center(
              child: LottieBuilder.asset(
                  "lib/asset/images/others/koi_animation.json",height: 300,width:300,),
            )
          ],
        ),
        nextScreen: const LoginScreen(),
        splashIconSize: 400,
        backgroundColor: Colors.white,
      ),
    );
  }
}
