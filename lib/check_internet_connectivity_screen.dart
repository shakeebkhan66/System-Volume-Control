import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';

class CheckInternetConnectivity extends StatefulWidget {
  const CheckInternetConnectivity({Key key}) : super(key: key);

  @override
  State<CheckInternetConnectivity> createState() =>
      _CheckInternetConnectivityState();
}

class _CheckInternetConnectivityState extends State<CheckInternetConnectivity> {
  String status = "Waiting for Connection...";
  Connectivity _connectivity = Connectivity();
  StreamSubscription _streamSubscription;

  // TODO Initializing an Instance of NetworkInfo
  final info = NetworkInfo();

  // TODO Check Internet Connectivity Via Button
  void checkConnectivity() async {
    var connectionResult = await _connectivity.checkConnectivity();
    if (connectionResult == ConnectivityResult.wifi) {
      status = "Wifi";
    } else if (connectionResult == ConnectivityResult.mobile) {
      status = "Mobile";
    } else {
      status = "Not Connected";
    }
    setState(() {});
  }

  // TODO Get Wifi Ip Address
  void getWifiIPAddress() async{
    var wifi = await info.getWifiIP();
    var wifiName = await info.getWifiName();
    print("Wifi Name is $wifiName");
    print("Wifi Ip Address is $wifi");
    if(wifi == "192.168.100.156"){
      print("Silent My Phone, Reached Office");
    }else{
      print("Don't silent my phone");
    }
  }

  // TODO Check Internet Connection RealTime
  void checkInternetConnectionRealTime() async{
    _streamSubscription = _connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.wifi) {
        status = "Wifi";
      } else if (event == ConnectivityResult.mobile) {
        status = "Mobile";
      } else {
        status = "Not Connected";
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    // checkConnectivity();
    checkInternetConnectionRealTime();
    getWifiIPAddress();
  }

  @override
  void dispose(){
    super.dispose();
    _streamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        title: const Text(
          "Check Internet Connection",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                status,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
