import 'package:flutter/material.dart';
import 'package:studi_match/models/result_package.dart';
import 'package:studi_match/screens/employment_agency/jobs_list.dart';

import '../router/nav_router.dart';

// Todo: make a page

class OnboardingDialog extends StatefulWidget {
  const OnboardingDialog({super.key});

  @override
  State<OnboardingDialog> createState() => _OnboardingDialogState();
}

class _OnboardingDialogState extends State<OnboardingDialog> {
  final Set<ResultPackage> filterEmploymentType = ResultPackage.values.toSet();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Dialog(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    ),
                  ],
                ),
                const Text(
                  'Wonach suchst du?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Column(
                  children: [
                    const Text(
                      'Wähle min. eine Beschäftigungsart:',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      child: Wrap(
                        spacing: 8,
                        children: ResultPackage.values
                            .map((ResultPackage package) => FilterChip(
                                label: Text(
                                    ResultPackageHelper().getValue(package)),
                                selected:
                                    filterEmploymentType.contains(package),
                                onSelected: (bool selected) => setState(() {
                                      if (selected) {
                                        filterEmploymentType.add(package);
                                      } else {
                                        filterEmploymentType.remove(package);
                                      }
                                    })))
                            .toList(),
                      ),
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        ElevatedButton(
                            onPressed: filterEmploymentType.isNotEmpty
                                ? () => {
                                      Navigator.of(context).pop(),
                                      Navigator.of(context).push(
                                        NavRouter(
                                          builder: (context) =>
                                              const EAJobsListScreen(),
                                        ),
                                      )
                                    }
                                : null,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.greenAccent),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Jetzt loslegen',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Icon(
                                  Icons.search,
                                  color: Colors.white,
                                ),
                              ],
                            ))
                      ]),
                    ]),
                  ],
                ),
              ],
            ),
            // Container(
            //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            //   decoration: BoxDecoration(
            //     color: Colors.grey[200],
            //   ),
            //   child: const Column(
            //     children: [
            //       Text('Wähle dein Beschäftigungsfeld:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
            //       FilterChipWidget(),
            //     ],
            //   ),
            // ),
            // Container(
            //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            //   decoration: BoxDecoration(
            //     color: Colors.grey[200],
            //   ),
            //   child: const Column(
            //     children: [
            //       Text('Wähle dein Berufsfeld:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
            //       FilterChipWidget(),
            //     ],
            //   ),
            // ),
          ),
        ),
      );

//void showFilterDialog(BuildContext context) =>
}
