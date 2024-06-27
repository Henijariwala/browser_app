import 'package:browser_app/share_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeProvider with ChangeNotifier {
  double progress = 0;
  List<String>bookMark=[];

  void setBookMarks(String link)
  {
    SharedHelper share = SharedHelper();
    share.setBookMarkData(link);
    getBookMarks();
    notifyListeners();
 }
  Future<void> getBookMarks(  )
  async {
    SharedHelper share = SharedHelper();
    var link = await share.getBookMarkData();
    notifyListeners();
  }
  void addbookmark(url)
  {
    bookMark.add(url);
    notifyListeners();
  }
  void ProgressIndicator(double p) {
  progress=p;
  notifyListeners();
  }
}