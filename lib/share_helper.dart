import 'package:shared_preferences/shared_preferences.dart';

class SharedHelper
{
  void setBookMarkData(String link)async {
    SharedPreferences shr = await SharedPreferences.getInstance();
    shr.setString("link", link);
  }
    getBookMarkData()
    async {
    SharedPreferences shr = await SharedPreferences.getInstance();
    String? link=shr.getString("link");
    return link;
  }
}