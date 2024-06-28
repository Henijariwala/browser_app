import 'package:browser_app/screen/home/model/data_model.dart';
import 'package:browser_app/utile/share_helper.dart';
import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  double progress = 0;
  List<String>? bookMark=[];
  String isCheck="Google";
  String sSearch="https://www.google.co.in";
  String eSearch="https://www.google.com/search?q=";

  void changeSearch(String s1, String s2)
  {
    sSearch=s1;
    eSearch=s2;
    notifyListeners();
  }

  void Check(check)
  {
    isCheck=check;
    notifyListeners();
  }
  void setBookMarks(String url)
  {


    getBookMarks();
    bookMark!.add(url);
    SharedHelper share = SharedHelper();
    share.setBookMarkData(bookMark!);
    getBookMarks();
    notifyListeners();
 }
  Future<void> getBookMarks(  )
  async {
    SharedHelper share = SharedHelper();
    var l1 = await share.getBookMarkData();
    if(l1!=null)
      {
        bookMark =l1;
      }
    notifyListeners();
  }
  void ProgressIndicator(double p) {
  progress=p;
  notifyListeners();
  }
}