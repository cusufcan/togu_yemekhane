import 'package:flutter/material.dart';

class MenuAppbar extends StatelessWidget implements PreferredSizeWidget {
  final void Function() onPressed;
  final PreferredSizeWidget? bottom;

  const MenuAppbar({
    super.key,
    required this.onPressed,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          icon: const Icon(Icons.add_card_outlined),
          tooltip: 'Bakiye Yükleme',
          onPressed: onPressed,
        ),
      ],
      title: const Text('TOGÜ Yemekhane'),
      leading: Container(
        margin: const EdgeInsets.only(left: 12),
        width: 75,
        height: 75,
        child: Image.asset(
          'assets/logo.png',
          fit: BoxFit.scaleDown,
        ),
      ),
      centerTitle: true,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight * 2);
}
