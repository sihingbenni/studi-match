import 'package:flutter/material.dart';
import 'package:studi_match/screens/employment_agency/jobs_list.dart';

class JobPreferencesDialog extends StatelessWidget {
  const JobPreferencesDialog({super.key});

  @override
  Widget build(BuildContext context) => Dialog(
      insetPadding: const EdgeInsets.symmetric(vertical: 50),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              'Wonach suchst du?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Worin möchtest du arbeiten? (Berufsfeld)',
                  icon: Icon(Icons.work_rounded),
                ),
                maxLines: 1),
            const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Wo suchst du? Bitte gib hier eine Postleitzahl ein.',
                  icon: Icon(Icons.home_rounded),
                ),
                maxLines: 1),
            const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Wie möchstest du arbeiten?',
                  icon: Icon(Icons.add_home_work_sharp),
                ),
                maxLines: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent),
                  child: const Text(
                    'Close',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                    // Navigate to the job list screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EAJobsListScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent),
                  child: const Text(
                    'Navigate to Jobs List',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            )
          ],
        ),
      )


  );
}