import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateDialog extends StatelessWidget {
  final bool isOptional;
  final String title;
  final String content;
  final String button;
  final String url;
  const UpdateDialog({
    super.key,
    required this.isOptional,
    required this.content,
    required this.title,
    required this.button,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: _goToLink,
          child: Text(button),
        ),
        TextButton(
          onPressed: () => _exit(context),
          child: const Text('İptal'),
        ),
      ],
    );
  }

  void _goToLink() {
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  void _exit(BuildContext context) {
    isOptional ? Navigator.pop(context) : exit(0);
  }
}
