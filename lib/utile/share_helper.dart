import 'package:shared_preferences/shared_preferences.dart';

class SharedHelper
{
  void setBookMarkData(List<String> link)async {
    SharedPreferences shr = await SharedPreferences.getInstance();
    shr.setStringList("link", link);
  }
    Future<List<String>?> getBookMarkData()
    async {
    SharedPreferences shr = await SharedPreferences.getInstance();
    List<String>? link=shr.getStringList("link") ;
    return link;
  }
}