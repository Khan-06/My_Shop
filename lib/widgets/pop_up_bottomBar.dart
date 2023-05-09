import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
//
// class PopUpBar extends StatelessWidget {
//
//   PopUpBar({required this.title,this.icon,required this.message,this.button});
//
//   final String title;
//   final String message;
//    Widget? button;
//    Icon? icon;
//   @override
//   Widget build(BuildContext context) {
//     return Flushbar(
//       title: title,
//       icon: icon,
//       message: message,
//       borderRadius: BorderRadius.circular(20),
//       mainButton: button,
//       duration: const Duration(seconds: 2),
//       margin: const EdgeInsets.all(5),
//     );
//   }
// }

Future PopUpBar ({required String title,required String message, Icon? icon, Widget? button,required BuildContext ctx}){
  return Flushbar(
    title: title,
    icon: icon,
    message: message,
    borderRadius: BorderRadius.circular(20),
    mainButton: button,
    duration: const Duration(seconds: 2),
    margin: const EdgeInsets.all(5),
  ).show(ctx);
}
