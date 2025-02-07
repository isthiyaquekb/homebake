import 'package:flutter/cupertino.dart';

class DashboardViewmodel extends ChangeNotifier{
  var selectedIndex=0;

  void setCurrentIndex(int index){
    selectedIndex=index;
    notifyListeners();
  }
}