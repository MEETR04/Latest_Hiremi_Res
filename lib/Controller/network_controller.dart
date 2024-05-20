  //
  // import 'package:connectivity_plus/connectivity_plus.dart';
  // import 'package:flutter/material.dart';
  // import 'package:get/get.dart';
  //
  // class NetworkController extends GetxController {
  //   final Connectivity _connectivity = Connectivity();
  //   late bool _isConnected;
  //
  //   @override
  //   void onInit() {
  //     super.onInit();
  //     _connectivity.onConnectivityChanged.listen((List<ConnectivityResult>? results) {
  //       if (results != null && results.isNotEmpty) {
  //         _isConnected = results.first != ConnectivityResult.none;
  //         _updateConnectionStatus(_isConnected);
  //       }
  //     });
  //   }
  //
  //   void _updateConnectionStatus(ConnectivityResult connectivityResult) {
  //   if(connectivityResult==ConnectivityResult.none){
  //
  //   }
  //   }
  // }
  // import 'package:connectivity_plus/connectivity_plus.dart';
  // import 'package:flutter/material.dart';
  // import 'package:get/get.dart';
  //
  // class NetworkController extends GetxController {
  //   final Connectivity _connectivity = Connectivity();
  //   late bool _isConnected;
  //
  //   @override
  //   void onInit() {
  //     super.onInit();
  //     _connectivity.onConnectivityChanged.listen((List<ConnectivityResult>? results) {
  //       if (results != null && results.isNotEmpty) {
  //         _isConnected = results.first != ConnectivityResult.none;
  //         if (!_isConnected) {
  //           _updateConnectionStatus();
  //         }
  //       }
  //     });
  //   }
  //
  //
  //   void _updateConnectionStatus() {
  //     showDialog(
  //       context: Get.overlayContext!,
  //       barrierDismissible: false,
  //       builder: (context) => AlertDialog(
  //         backgroundColor: Colors.white,
  //         surfaceTintColor: Colors.transparent,
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             SizedBox(height: 30),
  //             Center(
  //               child: Text(
  //                 "Connection Lost",
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(
  //                   fontFamily: "FontMain",
  //                   fontSize: 18,
  //                   color: Color(0xFFBD232B),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(height: 35),
  //             ElevatedButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: const Color(0xFFF13640),
  //                 minimumSize: Size(250, 50),
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(30),
  //                 ),
  //               ),
  //               child: const Text(
  //                 "OK",
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.w700,
  //                   fontSize: 20,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   }
  //
  //
  // }
  //
  // class MyApp extends StatelessWidget {
  //   final NetworkController _networkController = Get.put(NetworkController());
  //
  //   @override
  //   Widget build(BuildContext context) {
  //     return GestureDetector(
  //       onTap: () {
  //         if (!_networkController._isConnected) {
  //           _networkController._updateConnectionStatus();
  //         }
  //       },
  //       child: MaterialApp(
  //         title: 'My App',
  //         home: Scaffold(
  //           appBar: AppBar(
  //             title: Text('My App'),
  //           ),
  //           body: Center(
  //             child: Text('Welcome to My App!'),
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  // }
  //
  // void main() {
  //   runApp(MyApp());
  // }
  // import 'package:connectivity_plus/connectivity_plus.dart';
  // import 'package:flutter/material.dart';
  // import 'package:get/get.dart';
  //
  // class NetworkController extends GetxController{
  //   final Connectivity _connectivity=Connectivity();
  //
  //   @override
  //   void onInit(){
  //     super.onInit();
  //     _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  //   }
  //   void _updateConnectionStatus(ConnectivityResult connectivityResult){
  //     if(connectivityResult== ConnectivityResult.none){
  //       Get.rawSnackbar(
  //         messageText:const Text(
  //           "PLEASE CONNECT TO THE INTERNET",
  //           style: TextStyle(
  //             color: Colors.white,
  //             fontSize: 14,
  //           ),
  //         ),
  //         isDismissible: false,
  //         duration: const Duration(days: 1),
  //           backgroundColor: Colors.redAccent,
  //         icon:const Icon(
  //           Icons.wifi_off,
  //           color: Colors.white,
  //           size: 35,
  //         ),
  //           margin:EdgeInsets.zero,
  //           snackStyle: SnackStyle.GROUNDED,
  //
  //       );
  //     }
  //     else
  //     {
  //       if(Get.isSnackbarOpen){
  //         Get.closeCurrentSnackbar();
  //       }
  //     }
  //   }
  // }
  import 'package:connectivity_plus/connectivity_plus.dart';
  import 'package:flutter/material.dart';
  import 'package:get/get.dart';

  class NetworkController extends GetxController {
    final Connectivity _connectivity = Connectivity();

    @override
    void onInit() {
      super.onInit();
      _connectivity.onConnectivityChanged.listen((List<ConnectivityResult>? results) {
        if (results != null && results.isNotEmpty) {
          _updateConnectionStatus(results.first);
        }
      });
    }

    void _updateConnectionStatus(ConnectivityResult connectivityResult) {
      if (connectivityResult == ConnectivityResult.none) {
        Get.rawSnackbar(
          messageText: const Text(
            "PLEASE CONNECT TO THE INTERNET",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          isDismissible: false,
          duration: const Duration(days: 1),
          backgroundColor: Colors.redAccent,
          icon: const Icon(
            Icons.wifi_off,
            color: Colors.white,
            size: 35,
          ),
          margin: EdgeInsets.zero,
          snackStyle: SnackStyle.GROUNDED,
        );
      } else {
        if (Get.isSnackbarOpen) {
          Get.closeCurrentSnackbar();
        }
      }
    }
  }

