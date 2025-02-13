import 'package:flutter/cupertino.dart';

class DetailViewModel extends ChangeNotifier{
  var selectedSizeIndex=0;
  int _count=1;
  int get count => _count;


  void setSize(int index){
    selectedSizeIndex=index;
    notifyListeners();
  }

  void incrementCount(){
    _count++;
    notifyListeners();
  }
  void decrementCount(){
    if(count>1){
      _count--;
    }
    notifyListeners();
  }
}