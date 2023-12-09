import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studi_match/providers/config_provider.dart';
import 'package:studi_match/providers/job_preferences_provider.dart';

class PreferencePicker extends StatefulWidget {
  final String uuid;
  const PreferencePicker({super.key, required this.uuid});

  @override
  State<PreferencePicker> createState() => _PreferencePickerState();
}

class _PreferencePickerState extends State<PreferencePicker> {

  List<String> packages = [];
  List<FilterChip> packageChips = [];
  String location = '';
  bool loading = true;
  final preferencesProvider = JobPreferencesProvider();

  @override
  void initState() {

    preferencesProvider.getPreferences(widget.uuid);

    preferencesProvider.addListener(() {
      // on change update the list of jobs
      setState(() {
        packages = preferencesProvider.packages;
        location = preferencesProvider.location;
        loading = preferencesProvider.loading;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SizedBox(
                  height: 100,
                  child: Builder(
                    builder: (context) {
                      if (loading) {
                        return const CircularProgressIndicator();
                      }
                      return Wrap(
                          spacing: 15.0,
                          direction: Axis.horizontal,
                          // create chips for each package key
                          children: ConfigProvider.resultPackages.keys
                              .map((String label) => FilterChip(
                                  label: Text(label),
                                  selected: packages.contains(label),
                                  onSelected: (bool selected) {
                                    setState(() {
                                      if (selected) {
                                        packages.add(label);
                                      } else {
                                        packages.remove(label);
                                      }
                                      preferencesProvider.updatePackages(widget.uuid, packages);
                                    });
                                  }))
                              .toList());
                    }
                  )),
            ),
          ),
      const Text('Dein Standort:'),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SizedBox(
          height: 100,
          child: TextField(
            maxLength: 5,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            onChanged: (value) {
              location = value;
            },
            onTapOutside: (value) {
              preferencesProvider.updateLocation(widget.uuid, location);
            },
            onSubmitted: (value) {
              location = value;
              preferencesProvider.updateLocation(widget.uuid, location);
            },
            controller: TextEditingController(text: location),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Postleitzahl',
            ),
          ),
        ),
      ),
    ],
  );
}
