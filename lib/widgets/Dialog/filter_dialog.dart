import 'package:flutter/material.dart';
import 'package:studi_match/screens/employment_agency/jobs_list.dart';
import 'package:studi_match/widgets/Dialog/filter_chip_widget.dart';

class FilterDialog extends StatelessWidget {
  const FilterDialog({super.key});

  @override
  Widget build(BuildContext context) => ElevatedButton(
      onPressed: () => showFilterDialog(context),
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.greenAccent,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10)),
      child: const Text(
        'Jetzt starten!',
        style: TextStyle(fontSize: 24, color: Colors.white),
      ));

  void showFilterDialog(BuildContext context) => showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Column(
                      children: [
                        const Text(
                          'Wähle eine Beschäftigungsart:',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const FilterChipWidget(),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.greenAccent),
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.navigate_before,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 4,
                                          )
                                        ],
                                      ))
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                ElevatedButton(
                                    onPressed: () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const EAJobsListScreen(),
                                          ),
                                        ),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.greenAccent),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Jetzt suchen',
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
          ));
}
