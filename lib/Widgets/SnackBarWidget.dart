 import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBarWidget(BuildContext context,String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        // behavior: SnackBarBehavior.floating,
        // margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 230, left: 10, right: 10),
        backgroundColor: Theme.of(context).colorScheme.surface,
        content: Container(
          padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
          child: Text(
            message,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }