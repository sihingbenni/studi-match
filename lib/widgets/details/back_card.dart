import 'package:flutter/cupertino.dart';
import 'package:flutter/src/material/colors.dart';
import 'package:studi_match/models/job.dart';

class BackCard extends StatelessWidget {
  const BackCard({super.key, required this.job, required this.accentColor});

  final Job job;
  final MaterialAccentColor accentColor;

  @override
  Widget build(BuildContext context) => const SingleChildScrollView(
    child: Stack(
      children: [
        Column(
        children: [
          Text('I show you the details of the job'),
        ],
      ),]
    ),
  );
}
