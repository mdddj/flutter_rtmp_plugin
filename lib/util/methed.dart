

import 'dart:io';

import 'package:flutter/cupertino.dart';

void exec({required VoidCallback androidCall,required VoidCallback iosCall}){
  if(Platform.isAndroid){
    androidCall.call();
  }else if(Platform.isIOS){
    iosCall.call();
  }
}