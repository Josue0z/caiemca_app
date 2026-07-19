

import 'package:flutter/material.dart';

Future<void> showLoader(BuildContext context, String message) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return SizedBox(
        width: 100,
        height: 100,
        child:  AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Expanded(child: Text(message)),
          ],
        ),
      ),
      );
    },
  );
}