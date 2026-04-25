



import 'package:flutter/material.dart';

class DialogeUtils {
  static void showLoading({
    required BuildContext context,
    required String text,
  }) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).dividerColor,
          content: Row(
            spacing: 30,
            children: [
              CircularProgressIndicator(
                color: Colors.white,
              ),
              Text(text, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        );
      },
    );
  }

  static void hideLoading({required BuildContext context}) {
    return Navigator.pop(context);
  }

  static showMassage({
    required BuildContext context,
    required String masseage,
    String? title ,
    String? posActionName,
    VoidCallback? posFun,
    String? negActionName,
    VoidCallback? negFun,
  }) {
    List<Widget> actoinsList = [];
    if (posActionName != null) {
      actoinsList.add(TextButton(onPressed: () {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, 'HomeScreen.RoutName');
      }, child: Text(posActionName ,style: Theme.of(context).textTheme.bodyMedium,)));

    }
    if(negActionName != null){
      actoinsList.add(TextButton(onPressed: () {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context,' HomeScreen.RoutName');
      }, child: Text(negActionName ,style: Theme.of(context).textTheme.bodyMedium,)));

    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            masseage,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          title: Text(title!, style: Theme.of(context).textTheme.bodyMedium),
          actions: actoinsList,
        );
      },
    );
  }
}
