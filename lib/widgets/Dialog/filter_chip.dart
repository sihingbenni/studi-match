import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// add the job professions provider
import 'package:studi_match/providers/job_professions_provider.dart';

enum EmploymentTypes {Werkstudent, Praktikum}
enum EmploymentFieldTypes {Informationstechnologie, Wirtschaft}


  class FilterChipWidget extends StatefulWidget{
  @override
  State<FilterChipWidget> createState() => _FilterChipState();
  }

  class _FilterChipState extends State<FilterChipWidget> {
    Set<EmploymentTypes> employmentFilters = <EmploymentTypes>{};
    Set<EmploymentFieldTypes> employmentFieldFilters = <EmploymentFieldTypes>{};

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
    child: Column(
      children: [
        const Text('Wähle eine Beschäftigungsart:'),
        Wrap(
          spacing: 5.0,
          children: EmploymentTypes.values.map((EmploymentTypes type) =>
          FilterChip(
            label: Text(type.name),
            selected: employmentFilters.contains(type),
            onSelected: (bool selected) {
              setState(() {
              if (selected) {
              employmentFilters.add(type);
              } else {
              employmentFilters.remove(type);
              }
            });
            },)
          ).toList(), // Convert the iterable to a list
        ),
        const Text('Wähle dein Beschäftigungsfeld:'),
        Wrap(
          spacing: 5.0,
          children: EmploymentFieldTypes.values.map((EmploymentFieldTypes type) =>
            FilterChip(label: Text(type.name),
                selected: employmentFieldFilters.contains(type),
                onSelected: (bool selected) {
                  setState(() {
                    if (selected) {
                      employmentFieldFilters.add(type);
                    } else {
                      employmentFieldFilters.remove(type);
                    }
                  });
            })
          ).toList(),
        ),
        // add the professions list
        const Text('Hier eine Liste mit allen möglichen Berufsfeldern:'),
        SizedBox(
          height: 400,
          child:
          SingleChildScrollView(
            clipBehavior: Clip.hardEdge,
            scrollDirection: Axis.vertical,
            child: employmentFieldTypesStringList.isNotEmpty ? Wrap(
              spacing: 5.0,
              children:
              employmentFieldTypesStringList.map((String type) =>
                  FilterChip(label: Text(type),
                      selected: employmentFieldFiltersStringList.contains(type),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            employmentFieldFiltersStringList.add(type);
                          } else {
                            employmentFieldFiltersStringList.remove(type);
                          }
                        });
                      })
              ).toList(),
            ) : const CircularProgressIndicator()
          ),
        ),
      ],
    ),
  );
  }