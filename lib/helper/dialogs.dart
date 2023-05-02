import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class Dialogs {
  static void showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("$msg"),
      backgroundColor: Colors.blue.withOpacity(.8),
      behavior: SnackBarBehavior.floating,
    ));
  }

  static Widget showImage(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, url) =>
          Image(image: AssetImage("images/picture.png")),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  static void showProgressBar(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent user from dismissing the dialog
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async =>
              false, // Prevent user from closing the dialog with back button
          child: AbsorbPointer(
            absorbing: true, // Prevent user interaction
            child: Dialog(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Please wait..",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<void> showInputDialog({
    required BuildContext context,
    required String title,
    required String hint,
    required Function() onOk,
    required VoidCallback onCancel,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(hint),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                onCancel();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                onOk();
              },
            ),
          ],
        );
      },
    );
  }

  static callNumber(String number) async {
    //set the number here
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
  }
}
