import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final String text;

  const TitleText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }
}
