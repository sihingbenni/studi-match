import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:studi_match/providers/config_provider.dart';
import 'package:studi_match/providers/job_preferences_provider.dart';
import 'package:studi_match/screens/employment_agency/jobs_list_screen.dart';
import 'package:studi_match/utilities/logger.dart';
import 'package:studi_match/widgets/router/nav_router.dart';

class PreferenceForm extends StatefulWidget {
  final String uuid;

  const PreferenceForm({super.key, required this.uuid});

  @override
  State<PreferenceForm> createState() => _PreferenceFormState();
}

class _PreferenceFormState extends State<PreferenceForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  List<String> packages = [];
  List<FilterChip> packageChips = [];
  String location = '';
  int distance = 25;
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
        distance = preferencesProvider.distance;
        _formKey.currentState?.fields['plz']?.setValue(location);
        _formKey.currentState?.fields['package_filter']?.setValue(packages);
        _formKey.currentState?.fields['distance_slider']?.setValue(distance.toDouble());
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Builder(builder: (context) {
        if (loading) {
          return const Center(child: CircularProgressIndicator());
        }
        return FormBuilder(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 15),
              FormBuilderFilterChip<String>(
                initialValue: packages,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(labelText: 'Wonach suchst du?'),
                direction: Axis.horizontal,
                spacing: 10,
                name: 'package_filter',
                options: ConfigProvider.resultPackages.keys
                    .map((package) => FormBuilderChipOption(
                          value: package,
                          avatar: Builder(builder: (context) {
                            if (packages.contains(package)) {
                              return const Icon(Icons.check);
                            } else {
                              return const CircleAvatar();
                            }
                          }),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    packages = value ?? [];
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Wähle mindestens eine Präferenz aus';
                  }
                  return null;
                },
                showCheckmark: false,
              ),
              FormBuilderTextField(
                initialValue: location,
                keyboardType: TextInputType.number,
                name: 'plz',
                maxLength: 5,
                decoration: InputDecoration(
                  hintText: 'PLZ',
                  labelText: 'Wo suchst du?',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.my_location),
                    onPressed: () {
                      //TODO get location from device
                    },
                  ),
                ),
                onChanged: (val) {
                  setState(() {
                    location = val ?? '';
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte gib deine Postleitzahl ein';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Bitte gib eine gültige Postleitzahl ein';
                  }
                  if (value.length != 5) {
                    return 'Bitte gib eine gültige Postleitzahl ein';
                  }
                  return null;
                },
              ),
              FormBuilderSlider(
                name: 'distance_slider',
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.min(ConfigProvider.preferencesMinDistance),
                  FormBuilderValidators.max(ConfigProvider.preferencesMaxDistance)
                ]),
                // onChanged: _onChanged,
                min: ConfigProvider.preferencesMinDistance.toDouble(),
                max: ConfigProvider.preferencesMaxDistance.toDouble(),
                initialValue: distance.toDouble(),
                divisions: ConfigProvider.preferencesDistanceDivisions,
                activeColor: Colors.red,
                inactiveColor: Colors.pink[100],
                onChangeEnd: (val) {
                  setState(() {
                    distance = val.toInt();
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Radius um deine Postleitzahl herum (in km):',
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          logger.i('preference form: validation successful');
                          // save the preferences
                          preferencesProvider.savePreferences(
                            widget.uuid,
                            packages,
                            location,
                            distance,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.green,
                              content: Text('Deine Einstellungen wurden gespeichert'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          // navigate to jobs list
                          Navigator.of(context).popUntil((route) => false);
                          Navigator.of(context).push(
                            NavRouter(
                              builder: (context) => const EAJobsListScreen(),
                            ),
                          );
                        } else {
                          // show error message in snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Bitte passe deine Eingaben an'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          logger.w('preference form: validation failed');
                        }
                      },
                      child: const Text(
                        'Speichern',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      });
}
