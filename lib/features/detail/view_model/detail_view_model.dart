import 'package:flutter/cupertino.dart';

class DetailViewModel extends ChangeNotifier{
  var selectedSizeIndex=0;
  var count=0;


  void setSize(int index){
    selectedSizeIndex=index;
    notifyListeners();
  }

  List<String> sizeList=[
   "S","M","L"
  ];

  void incrementCount(){
    count++;
    notifyListeners();
  }
  void decrementCount(){
    if(count>0){
      count--;
    }
    notifyListeners();
  }
}