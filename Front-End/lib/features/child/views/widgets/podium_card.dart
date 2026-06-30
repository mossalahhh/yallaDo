import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget podiumCard({
  required String number,
  required double height,
}) {
  return Container(
    width: 90,
    height: height,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xff9BC16C),
          Color(0xffC8E6A0),
        ],
      ),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.15),
          blurRadius: 6,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    alignment: Alignment.topCenter,
    child: Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Text(
        number,
        style: const TextStyle(
          fontSize: 45,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  );
}
