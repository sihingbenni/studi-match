import 'package:flutter/material.dart';

class UserPreferencesWidget extends StatefulWidget {
  const UserPreferencesWidget({super.key});

  @override
  _UserPreferencesWidgetState createState() => _UserPreferencesWidgetState();
}

class _UserPreferencesWidgetState extends State<UserPreferencesWidget> {
  String profession = "";
  String employmentType = "";
  String preferredCity = "";
  DateTime? preferredStartDate;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            _buildQuestion('In welchem Feld möchtest du arbeiten?'),
            const SizedBox(width: 20),
            _buildDropdown(
                profession, ['Profession 1', 'Profession 2', 'Profession 3'],
                (value) {
              setState(() {
                profession = value!;
              });
            }),
          const SizedBox(width: 20),
          const Divider(),
          const SizedBox(width: 20),
          _buildQuestion('Nach welche Anstellungsart suchst du?'),
          const SizedBox(width: 20),
          _buildDropdown(employmentType, [
            'Full-time',
            'Part-time',
            'Internship',
            'Working Student'
          ], (value) {
            setState(() {
              employmentType = value!;
            });
          }),
          const SizedBox(width: 20),
          const Divider(),
          const SizedBox(width: 20),
          _buildQuestion("Wo möchtest du arbeiten?"),
          const SizedBox(width: 20),
          _buildTextField(preferredCity, "Enter city name", (value) {
            setState(() {
              preferredCity = value;
            });
          }),
          const SizedBox(width: 20),
          const Divider(),
          const SizedBox(width: 20),
          _buildQuestion("Wann kannst du anfangen?"),
          const SizedBox(width: 20),
          _buildDatePicker(preferredStartDate, (date) {
            setState(() {
              preferredStartDate = date;
            });
          }),
        ],
      );

  Widget _buildQuestion(String question) => Text(
        question,
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      );

  Widget _buildDropdown(
      String? value, List<String> items, void Function(String?) onChanged) {
    // Check if the value is present in the list
    if (!items.contains(value)) {
      value = items.first; // Set a default value (e.g., the first item)
    }

    return DropdownButton<String>(
      value: value,
      onChanged: onChanged,
      items: items
          .map<DropdownMenuItem<String>>(
              (String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  ))
          .toList(),
    );
  }

  Widget _buildTextField(
          String value, String hintText, Function(String) onChanged) =>
      TextField(
        decoration: InputDecoration(
          hintText: hintText,
        ),
        onChanged: onChanged,
        controller: TextEditingController(text: value),
      );

  Widget _buildDatePicker(DateTime? date, Function(DateTime?) onDateSelected) =>
      ElevatedButton(
        onPressed: () async {
          final selectedDate = await showDatePicker(
            context: context,
            initialDate: date ?? DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2030),
          );

          if (selectedDate != null) {
            onDateSelected(selectedDate);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.greenAccent,
        ),
        child: Text(
          date == null
              ? 'Select Date'
              : 'Selected Date: ${date.toLocal()}'.split(' ')[0],
          style: const TextStyle(color: Colors.white),
        ),
      );
}
