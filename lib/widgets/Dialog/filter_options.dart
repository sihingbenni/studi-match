import 'package:flutter/material.dart';

// add the job professions provider
import 'package:studi_match/providers/job_professions_provider.dart';

class FilterChipWidget extends StatefulWidget {
  const FilterChipWidget({super.key});

  @override
  State<FilterChipWidget> createState() => _FilterChipState();
}

class _FilterChipState extends State<FilterChipWidget> {

  List<String> employmentFieldTypesStringList = [];
  List<String> employmentFieldFiltersStringList = [];

  @override
  void initState() {
    final professionsProvider = JobProfessionsProvider();

    professionsProvider.addListener(() {
      // on change update the list of jobs
      setState(() {
        employmentFieldTypesStringList = professionsProvider.fieldOfWorks;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: SizedBox(
            height: 400,
            child: SingleChildScrollView(
                clipBehavior: Clip.hardEdge,
                scrollDirection: Axis.vertical,
                child: employmentFieldTypesStringList.isNotEmpty
                    ? Wrap(
                        spacing: 5.0,
                        children: employmentFieldTypesStringList
                            .map((String type) => FilterChip(
                                label: Text(type),
                                selected: employmentFieldFiltersStringList
                                    .contains(type),
                                onSelected: (bool selected) {
                                  setState(() {
                                    if (selected) {
                                      employmentFieldFiltersStringList.add(type);
                                    } else {
                                      employmentFieldFiltersStringList
                                          .remove(type);
                                    }
                                  });
                                }))
                            .toList(),
                      )
                    : const CircularProgressIndicator()),
          ),
        ),
      );
}
