import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:hiremi/CongratulationScreen.dart';
import 'package:hiremi/CorporateTraining.dart';
import 'package:flutter_app_update/flutter_app_update.dart';
import 'package:hiremi/ForgetUrPass.dart';
import 'package:hiremi/JobDescription.dart';
import 'package:hiremi/PaymentSuccesful.dart';
import 'package:hiremi/Settings.dart';
import 'package:hiremi/chatGptrz2.dart';
import 'package:hiremi/dependenct_injection.dart';
import 'package:hiremi/fupazhan.dart';
import 'package:hiremi/internship.dart';
import 'package:hiremi/pageview_screen.dart';
import 'package:hiremi/seceondCongratulationScreen.dart';
import 'package:hiremi/firstCongratulationScreen.dart';
import 'package:hiremi/threeCongratulationScreen.dart';
import 'package:hiremi/widgets/bottomnav.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:hiremi/FresherJob.dart';
import 'package:hiremi/HomePage.dart';
import 'package:hiremi/Mentorship.dart';
import 'package:hiremi/PhonePePayment.dart';
import 'package:hiremi/RazorPayGateway.dart';
import 'package:hiremi/chatGptrz.dart';
import 'package:hiremi/signin.dart';
import 'package:hiremi/user_verification_screen.dart';
//import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'RZ.dart';
void main() {

  runApp(const MyApp());
  DependencyInjection.init();
}


Future<void> _checkForUpdate() async {
  try {
    AppUpdateInfo? updateInfo = await InAppUpdate.checkForUpdate();
    if (updateInfo != null) {
      await InAppUpdate.performImmediateUpdate();
    }
  } catch (e) {
    print('Error checking for update: $e');
  }
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _checkForUpdate();
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor:Colors.white),
        useMaterial3: true,
      ),
      home: const CongratulationScreen()
      // routes: {
      //   '/signin': (context) => SignIn(),
      // },

    );
  }
}

//cnikhiltrc-1@okhdfcbank
