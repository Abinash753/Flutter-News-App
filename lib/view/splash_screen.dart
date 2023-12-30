import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_news_app/resources/components/textStyle.dart';
import 'package:flutter_news_app/view/home_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //timer for splash screen
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 4),
        () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return const HomeScreen();
            })));
  }

  @override
  Widget build(BuildContext context) {
    //defining the sizde of the screen
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/splash_pic.jpg",
              fit: BoxFit.cover,
              width: width * 1,
              height: height * .5,
            ),
            SizedBox(
              height: height * 0.04,
            ),
            //text
            Text(
              "Top Headlines ",
              style: FontStyles.textStyle,
            ),
            SizedBox(
              height: height * 0.04,
            ),
            //spinkit animation
            const SpinKitCubeGrid(
              color: Colors.green,
              size: 50,
            ),
          ],
        ),
      ),
    );
  }
}
