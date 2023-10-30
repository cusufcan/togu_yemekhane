import 'package:flutter/material.dart';

import '../util/app_helper.dart';

class HastaneWidget extends StatefulWidget {
  final List<List<String>> data;

  const HastaneWidget({
    super.key,
    required this.data,
  });

  @override
  State<HastaneWidget> createState() => _HastaneWidgetState();
}

class _HastaneWidgetState extends State<HastaneWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return const Center(child: Text('N/A'));
    }
    final int weekDay = _getWeekDay();
    return ListView.builder(
      physics: const BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.fast),
      itemCount: widget.data.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.fromLTRB(8, index == 0 || index == 4 ? 16 : 8, 8, index == 0 || index == 4 ? 16 : 8),
          child: Row(
            children: [
              RotatedBox(
                quarterTurns: -1,
                child: Text(
                  getDayName(index),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(),
                ),
              ),
              Expanded(
                child: Card(
                  elevation: 3,
                  color: weekDay != 0 && weekDay - 1 == index ? const Color.fromARGB(255, 184, 255, 184) : null,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      topLeft: Radius.circular(30),
                      bottomRight: Radius.circular(300),
                      topRight: Radius.circular(300),
                    ),
                  ),
                  child: Column(
                    children: widget.data
                        .elementAt(index)
                        .map(
                          (e) => ListTile(
                            title: Text(
                              e.toString(),
                              style: TextStyle(
                                fontWeight:
                                    widget.data.elementAt(index).elementAt(widget.data.elementAt(index).length - 1) == e
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  int _getWeekDay() {
    final DateTime now = DateTime.now();
    final int weekDay = now.weekday;
    return weekDay == 6 || weekDay == 7 ? 0 : weekDay;
  }
}
