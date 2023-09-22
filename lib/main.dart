import 'package:flutter/material.dart';
import 'package:studi_match/screens/employment_agency/jobs_list.dart';

void main() {
  // runApp(const MyDemoApp());
  runApp(const StudiMatchApp());
}


class StudiMatchApp extends StatelessWidget {
  const StudiMatchApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'StudiMatch',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const EAJobsListScreen(),
      );
}