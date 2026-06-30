import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpInput extends StatefulWidget {
  final int length;
  final Function(String) onCompleted;

  const OtpInput({
    super.key,
    this.length = 6,
    required this.onCompleted,
  });

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

  @override
  void initState() {
    super.initState();
    controllers =
        List.generate(widget.length, (index) => TextEditingController());
    focusNodes = List.generate(widget.length, (index) => FocusNode());
  }

  void onChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < widget.length - 1) {
        focusNodes[index + 1].requestFocus();
      } else {
        String code =
        controllers.map((e) => e.text).join();
        widget.onCompleted(code);
      }
    } else {
      if (index > 0) {
        focusNodes[index - 1].requestFocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (index) {
        return Container(
          width: 50,
          height: 50,
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF4C2D19)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: controllers[index],
            focusNode: focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            onChanged: (value) => onChanged(value, index),
          ),
        );
      }),
    );
  }
}