import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum EmploymentTypes {Werkstudent, Praktikum}
enum EmploymentFieldTypes {Informationstechnologie, Wirtschaft}


  class FilterChipWidget extends StatefulWidget{
  @override
  State<FilterChipWidget> createState() => _FilterChipState();
  }

  class _FilterChipState extends State<FilterChipWidget> {
    Set<EmploymentTypes> employmentFilters = <EmploymentTypes>{};
    Set<EmploymentFieldTypes> employmentFieldFilters = <EmploymentFieldTypes>{};

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
        )
      ],
    ),
  );
  }