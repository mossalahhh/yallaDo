import 'package:flutter/material.dart';

class ChildAvatar extends StatelessWidget {
  final String name;
  final String percent;
  final String image;
  final bool selected;

  const ChildAvatar({
    required this.name,
    required this.percent,
    required this.image,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: selected ? Colors.green : Colors.transparent,
              width: 2,
            ),
          ),
          child: CircleAvatar(
            backgroundColor: Color(0xfffdf0c0),
            radius: 30,
            backgroundImage: AssetImage(image),
          ),
        ),
        SizedBox(height: 6),
        Text(name),
        Text(
          percent,
          style: TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class BarsChart extends StatelessWidget {
  final List<Map<String, dynamic>>? bars;

  const BarsChart({super.key, this.bars});

  List<Map<String, dynamic>> get _defaultBars => [
    {'label': 'Sat', 'value': 0.70},
    {'label': 'Sun', 'value': 0.78},
    {'label': 'Mon', 'value': 0.90},
    {'label': 'Tue', 'value': 0.50},
    {'label': 'Wed', 'value': 1.00},
    {'label': 'Thu', 'value': 0.50},
    {'label': 'Fri', 'value': 0.20},
  ];

  @override
  Widget build(BuildContext context) {
    final data = bars ?? _defaultBars;

    return SizedBox(
      height: 150,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: data.map((bar) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '${(bar['value'] * 100).toInt()}%',
                style: const TextStyle(fontSize: 9),
              ),
              const SizedBox(height: 4),
              Container(
                width: 20,
                height: 90 * (bar['value'] as double),
                decoration: BoxDecoration(
                  color: Colors.green.shade400,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                bar['label'],
                style: const TextStyle(fontSize: 9),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class CategoryProgress extends StatelessWidget {
  final String title;
  final double percent;

  const CategoryProgress({
    required this.title,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text('${(percent * 100).toInt()}% completed'),
            ],
          ),
          SizedBox(height: 8),
          LinearProgressIndicator(
            value: percent,
            minHeight: 6,
            color: Colors.green,
            backgroundColor: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      ),
    );
  }
}

BoxDecoration cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 8,
        offset: Offset(0, 4),
      )
    ],
  );
}