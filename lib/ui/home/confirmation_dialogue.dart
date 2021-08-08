import 'package:flutter/material.dart';

class ConfirmationDialogue extends StatelessWidget {
  final int count;
  final void Function() onConfirm;

  ConfirmationDialogue(this.count, this.onConfirm);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(
          "Are you sure, you want to subscribe to $count channels in your target account?"),
      title: Text("Are you sure?"),
      actions: [
        ElevatedButton(
          onPressed: onConfirm,
          child: Text("Yes"),
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Theme.of(context).primaryColor),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("No"),
        ),
      ],
    );
  }
}
