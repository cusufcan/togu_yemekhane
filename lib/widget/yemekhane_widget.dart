import 'package:flutter/material.dart';

class YemekhaneWidget extends StatelessWidget {
  final List<List<String>> data;

  const YemekhaneWidget({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('N/A'));
    }
    return SliverList.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Row(
            children: [
              RotatedBox(
                quarterTurns: -1,
                child: Text(
                  _getDayName(index),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(),
                ),
              ),
              Expanded(
                child: Card(
                  elevation: 3,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      topLeft: Radius.circular(30),
                      bottomRight: Radius.circular(300),
                      topRight: Radius.circular(300),
                    ),
                  ),
                  child: Column(
                    children: data.elementAt(index).map((e) => ListTile(title: Text(e.toString()))).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getDayName(int index) {
    switch (index) {
      case 0:
        return 'Pazartesi';
      case 1:
        return 'Salı';
      case 2:
        return 'Çarşamba';
      case 3:
        return 'Perşembe';
      case 4:
        return 'Cuma';
      default:
        return 'N/A';
    }
  }
}
