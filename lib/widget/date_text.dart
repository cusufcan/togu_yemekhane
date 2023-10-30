import 'package:flutter/material.dart';

class DateText extends StatelessWidget {
  final String text;

  const DateText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}
