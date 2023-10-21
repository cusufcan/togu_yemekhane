import 'package:flutter/material.dart';

class SubtitleText extends StatelessWidget {
  final String text;

  const SubtitleText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      ' $text',
      style: Theme.of(context).textTheme.titleMedium,
    );
  }
}
