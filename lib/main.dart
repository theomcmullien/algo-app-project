import 'dart:async';
import 'dart:io';
import 'package:algo_app_proj/send_location.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;

var name = prefs.getString('name');
var userId = prefs.getString('userId');

//main method used for initial startup of app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map _source = {ConnectivityResult.none: false};
  //MyConnectivity object used for checking the connectivity of the device
  final MyConnectivity _connectivity = MyConnectivity.instance;

  //initState used for setting the initial state of the connectivity status
  @override
  void initState() {
    super.initState();
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });
  }

  @override
  Widget build(BuildContext context) {
    String line;
    //switch statement checking if mobile data or wifi is turned on
    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.mobile:
        line = 'Mobile: Online';
        break;
      case ConnectivityResult.wifi:
        line = 'WiFi: Online';
        break;
      case ConnectivityResult.none:
      default:
        line = 'Offline';
    }

    //returns the main scaffold of the entire app
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.green[900],
        ),
        body: Center(
            //ternary operator used to either display the SendLocation page or to
            //inform the user to connect to a network
            //depending on the devices connection to a network
            child: line == "Offline"
                ? Text(
                    "Please connect to a network",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  )
                : SendLocation()),
      ),
    );
  }

  //used for disposing of the _connectivity variable
  @override
  void dispose() {
    _connectivity.disposeStream();
    super.dispose();
  }
}

class MyConnectivity {
  MyConnectivity._();

  static final _instance = MyConnectivity._();
  static MyConnectivity get instance => _instance;
  final _connectivity = Connectivity();
  final _controller = StreamController.broadcast();
  Stream get myStream => _controller.stream;

  //method used for checking the connectivity of a MyConnectivity object
  void initialise() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    _checkStatus(result);
    _connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  //method used for checking the connectivity of a MyConnectivity object
  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }
    _controller.sink.add({result: isOnline});
  }

  //method used for disposing of the controller
  void disposeStream() => _controller.close();
}
