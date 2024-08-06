import 'package:flutter/material.dart';

class AlertField3 extends StatefulWidget {
  final String content;
  final String textButton;
  final String textButton2;
  final bool forNumber;
  final Function()? onTap;
  final Function()? onTap2;
  final Function()? onChange;
  const AlertField3({
    this.forNumber = false,
    required this.textButton,
    required this.textButton2,
    required this.onTap,
    required this.onTap2,
    required this.content,
    this.onChange,
    super.key,
  });

  @override
  State<AlertField3> createState() => _AlertField3State();
}

@override
class _AlertField3State extends State<AlertField3> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        Row(
          children: [
            Expanded(
              flex: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: const StadiumBorder(),
                ),
                onPressed: widget.onTap,
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
            Expanded(
              flex: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: const StadiumBorder(),
                ),
                onPressed: widget.onTap2,
                child: Text(
                  widget.textButton2,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'helvetica_neue_light',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        )
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
