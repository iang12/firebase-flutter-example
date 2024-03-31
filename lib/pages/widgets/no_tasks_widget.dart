import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NoTasksWidget extends StatelessWidget {
  const NoTasksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/no_data.svg',
            height: 250,
            alignment: Alignment.center,
          ),
          const SizedBox(height: 20),
          const Text(
            'Your Tasks List is Empty!',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Text(
            'You don\'t have any active tasks right\nnow. Try to add some!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          )
        ],
      ),
    );
  }
}
