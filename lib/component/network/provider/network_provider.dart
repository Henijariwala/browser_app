import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

class NetworkProvider with ChangeNotifier
{
  Connectivity connectivity = Connectivity();
  bool isInternet = true;
  Future<void> checkConnection()
  async{
    Connectivity().onConnectivityChanged.listen((event) {
      if(event.contains(ConnectivityResult.none))
      {
        isInternet =false;
      }
      else
      {
        isInternet=true;
      }
      notifyListeners();
    });
  }
}