import 'package:flutter/material.dart';

class LeaderboardTile extends StatelessWidget {
  final String rank;
  final String name;

  const LeaderboardTile(this.rank, this.name, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.deepPurple.withOpacity(0.15),
                child: Text(rank),
              ),
               SizedBox(width: 12),
              Expanded(
                child: Text(
                  name,
                  style:  TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
             Image.asset("images/star2.png",height: 50,)
            ],
          ),
           SizedBox(height: 10),
          Container(
            height: 2,
            color: Colors.deepOrange,
          ),
        ],
      ),
    );
  }
}
