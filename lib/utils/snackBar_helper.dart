import 'dart:ui';

import 'package:flutter/material.dart';

void showFailureMessage(BuildContext context,{required String msg}){
  final snackBar = SnackBar(content: Text(msg,style: TextStyle(color: Colors.red,),));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
void showSuccessMessage(BuildContext context,{required String msg}){
  final snackBar = SnackBar(content: Text(msg,style: TextStyle(color: Colors.teal),));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}