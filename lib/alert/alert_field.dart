import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AlertField extends StatefulWidget {
  final String title;
  final String textFieldtitle;
  final String textFieldcontent;
  final String textButton;
  final int limit;
  final bool forNumber;
  final TextEditingController controller;
  final Function()? onTap;
  final Function()? onChange;
  const AlertField({
    required this.title,
    this.forNumber = false,
    required this.textButton,
    required this.textFieldtitle,
    required this.textFieldcontent,
    required this.onTap,
    required this.controller,
    required this.limit,
    this.onChange,
    super.key,
  });

  @override
  State<AlertField> createState() => _AlertFieldState();
}

@override
class _AlertFieldState extends State<AlertField> {
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
          onPressed: widget.onTap,
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
      content: TextField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(widget.limit),
        ],
        autofocus: true,
        controller: widget.controller,
        keyboardType:
            (widget.forNumber) ? TextInputType.number : TextInputType.name,
        decoration: InputDecoration(
          hintText: widget.textFieldcontent,
          labelText: widget.textFieldtitle,
          labelStyle: const TextStyle(
            color: Colors.black,
          ),
          hintStyle: const TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

// return AlertDialog(
//   title: Text(widget.title),
//   actions: [
//     ElevatedButton(
//       style: ElevatedButton.styleFrom(
//           primary: Colors.green, shape: const StadiumBorder()),
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
