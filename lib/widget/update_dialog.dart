import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constant/app_constant.dart';

class UpdateDialog extends StatelessWidget {
  final bool isOptional;
  const UpdateDialog({
    super.key,
    required this.isOptional,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppConstants.update),
      actions: [
        TextButton(onPressed: goToGooglePlay, child: const Text('Güncelle')),
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
