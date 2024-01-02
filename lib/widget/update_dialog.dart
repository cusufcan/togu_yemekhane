import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constant/app_constant.dart';

class UpdateDialog extends StatelessWidget {
  final bool isOptional;
  final String title;
  final String content;
  final String button;
  const UpdateDialog({
    super.key,
    required this.isOptional,
    required this.content,
    required this.title,
    required this.button,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(onPressed: goToGooglePlay, child: Text(button)),
        TextButton(onPressed: () => exitApplication(context), child: const Text('İptal')),
      ],
    );
  }

  void goToGooglePlay() {
    final appUrl = Uri.parse(AppConstants.appUrl);
    launchUrl(appUrl, mode: LaunchMode.externalApplication);
  }

  void exitApplication(BuildContext context) {
    isOptional ? Navigator.pop(context) : exit(0);
  }
}
