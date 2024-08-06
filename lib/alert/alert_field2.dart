import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AlertField2 extends StatefulWidget {
  final String title;
  final String content;
  final String textButton;
  final bool forNumber;
  final Function()? onChange;
  const AlertField2({
    required this.title,
    this.forNumber = false,
    required this.textButton,
    required this.content,
    this.onChange,
    super.key,
  });

  @override
  State<AlertField2> createState() => _AlertField2State();
}

@override
class _AlertField2State extends State<AlertField2> {
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
            Navigator.pop(context);
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
      content: InkWell(
        child: Text(
          widget.content.toString(),
          textAlign: TextAlign.center,
        ),
        onTap: () async {
          await Clipboard.setData(ClipboardData(
            text: widget.content.toString(),
          ));
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Testo Copiato negli Appunti!'),
            action: SnackBarAction(
              label: 'Chiudi',
              onPressed: () {},
            ),
          ));
        },
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
