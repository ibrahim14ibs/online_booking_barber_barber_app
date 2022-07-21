
import 'package:flutter/material.dart';

class CustomAlertDialog  {
 static showLoading(context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('الرجاء الانتظار'),
          content: Container(
            height: 50,
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      });
}
}