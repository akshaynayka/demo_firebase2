import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

String removeSpaceFromString(String value) {
  final string = value.replaceAll(RegExp(r"\s+"), "");
  return string;
}

displaySnackbar({required BuildContext context, required String msg}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 3),
    ),
  );
}

Future<void> showExitDialogBox(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Do you realy want to Logout'),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              child: const Text(
                'No',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
            ElevatedButton(
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                Navigator.of(ctx).pop();
                await FirebaseAuth.instance.signOut();

                final GoogleSignIn googleSignIn =
                    GoogleSignIn(scopes: <String>["email"]);
                await googleSignIn.signOut();
              },
            ),
          ],
        ),
      ],
    ),
  );
}

Future<void> showErrorDialog(String message, BuildContext context) async {
  await showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Error Occurred'),
      content: Text(message),
      actions: [
        TextButton(
          child: Text(
            'Okay',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          onPressed: () {
            Navigator.of(ctx).pop();
          },
        )
      ],
    ),
  );
}
