import 'package:flutter/material.dart';

class AlertField4 extends StatefulWidget {
  final String title;
  final String content;
  final String textButton;
  final bool forNumber;
  final Function()? onChange;
  const AlertField4({
    required this.title,
    this.forNumber = false,
    required this.textButton,
    required this.content,
    this.onChange,
    super.key,
  });

  @override
  State<AlertField4> createState() => _AlertField4State();
}

@override
class _AlertField4State extends State<AlertField4> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: const StadiumBorder(),
          ),
          onPressed: () {
            widget.onChange!();
          },
          child: Center(
            child: Text(
              widget.textButton,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'helvetica_neue_light',
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
      content: Text(
        widget.content.toString(),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// return AlertDialog(
//   title: Text(widget.title),
//   actions: [
//     ElevatedButton(
//       style: ElevatedButton.styleFrom(
//          backgroundColor: Colors.green, shape: const StadiumBorder()),
//       onPressed: widget.onTap,
//       child: Center(
//         child: Text(
//           widget.textButton,
//           style: const TextStyle(
//             color: Colors.white,
//             fontFamily: 'helvetica_neue_light',
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ),
//     ),
//   ],
//   content: TextField(
//     autofocus: true,
//     controller: widget.controller,
//     keyboardType:
//         (widget.forNumber) ? TextInputType.number : TextInputType.name,
//     decoration: InputDecoration(
//       hintText: widget.textFieldcontent,
//       labelText: widget.textFieldtitle,
//       labelStyle: const TextStyle(
//         color: Colors.black,
//       ),
//       hintStyle: const TextStyle(
//         color: Colors.black,
//       ),
//     ),
//   ),
// );
