import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AlertField5 extends StatefulWidget {
  final String content;
  final String textButton;
  final String textButton2;
  final String title;
  final bool forNumber;
  final Function()? onTap;
  final Function()? onTap2;
  final Function()? onChange;
  const AlertField5({
    this.forNumber = false,
    required this.textButton,
    required this.title,
    required this.textButton2,
    required this.onTap,
    required this.onTap2,
    required this.content,
    this.onChange,
    super.key,
  });

  @override
  State<AlertField5> createState() => _AlertField5State();
}

@override
class _AlertField5State extends State<AlertField5> {
  Future<int> sendCart(cart) async {
    final response = await http.post(
      Uri.parse('https://bohagent.cloud/api/b2b/set_provvisiero_cart/PROV1234'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'cd_ar': cart.cd_ar.toString(),
        'id_ditta': '7',
        'cd_cf': cart.cd_cf.toString(),
        //'cd_cfsede': cart.cd_cfsede.toString(),
        'cd_cfdest': (cart.cd_cfdest.toString() != 'null')
            ? cart.cd_cfdest.toString()
            : '',
        //'cd_agente_1': cart.cd_agente_1.toString(),
        'qta': '${cart.qta}',
        'xcolli': '0',
        'xbancali': '0',
        'prezzo_unitario': cart.prezzo_unitario.toString(),
        'cd_aliquota': '4',
        'aliquota': '4',
        //'totale': '0',
        //'imposta': '0',
        //'da_inviare': '0',
        'note': cart.note.toString(),
        'scontoriga': '0',
        'xconfezione': cart.confezione.toString(),
        'datadoc': cart.datadoc.toString(),
        'linkcart': cart.linkcart.toString(),
        'send_mail': cart.send_mail.toString(),
        'note_agg': cart.note_agg.toString(),
        'note_dotes': cart.note_dotes.toString(),
      }),
    );
    //print(response.body);
    //print(response.statusCode);
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return response.statusCode;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return response.statusCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
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
