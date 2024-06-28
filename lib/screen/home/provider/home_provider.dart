import 'package:browser_app/utile/share_helper.dart';
import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  double progress = 0;
  List<String>bookMark=[];
  String?link;

  void setBookMarks(String link)
  {
    SharedHelper share = SharedHelper();
    share.setBookMarkData(link);
    getBookMarks();
    notifyListeners();
    print(link);
 }
  Future<void> getBookMarks(  )
  async {
    SharedHelper share = SharedHelper();
    link = await share.getBookMarkData();
    notifyListeners();
    print(link);
  }
  void ProgressIndicator(double p) {
  progress=p;
  notifyListeners();
  }
}