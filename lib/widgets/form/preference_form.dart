import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:studi_match/providers/job_preferences_provider.dart';
import 'package:studi_match/utilities/logger.dart';

class PreferenceForm extends StatefulWidget {
  final String uuid;
  const PreferenceForm({super.key, required this.uuid});

  @override
  State<PreferenceForm> createState() => _PreferenceFormState();
}

class _PreferenceFormState extends State<PreferenceForm> {

  // form fields
  bool _plzHasError = false;

  final _formKey = GlobalKey<FormBuilderState>();



  List<String> packages = [];
  List<FilterChip> packageChips = [];
  String location = '';
  int distance = 25;
  bool loading = true;
  final preferencesProvider = JobPreferencesProvider();

  final int maxDistance = 100;
  final int minDistance = 1;

  void _onChanged(dynamic val) => debugPrint(val.toString());

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
        logger.f('$location, $packages, $distance');
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => FormBuilder(
    child: Column(
      children: <Widget>[
        const SizedBox(height: 15),
        FormBuilderFilterChip<String>(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: const InputDecoration(labelText: 'My Preferences'),
          name: 'package_filter',
          selectedColor: Colors.red,
          options: const [
            FormBuilderChipOption(
              value: 'Dart',
              avatar: CircleAvatar(child: Text('D')),
            ),
            FormBuilderChipOption(
              value: 'Kotlin',
              avatar: CircleAvatar(child: Text('K')),
            ),
            FormBuilderChipOption(
              value: 'Java',
              avatar: CircleAvatar(child: Text('J')),
            ),
            FormBuilderChipOption(
              value: 'Swift',
              avatar: CircleAvatar(child: Text('S')),
            ),
            FormBuilderChipOption(
              value: 'Objective-C',
              avatar: CircleAvatar(child: Text('O')),
            ),
          ],
          onChanged: _onChanged,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.minLength(1),
            FormBuilderValidators.maxLength(3),
          ]),
        ),
        FormBuilderSlider(
          name: 'distance_slider',
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.min(minDistance),
            FormBuilderValidators.max(maxDistance)
          ]),
          onChanged: _onChanged,
          min: minDistance.toDouble(),
          max: maxDistance.toDouble(),
          initialValue: distance.toDouble(),
          divisions: 25,
          activeColor: Colors.red,
          inactiveColor: Colors.pink[100],
          decoration: const InputDecoration(
            labelText: 'Radius around your location:',
          ),
        ),
        FormBuilderTextField(
          autovalidateMode: AutovalidateMode.always,
          name: 'age',
          decoration: InputDecoration(
            labelText: 'Age',
            suffixIcon: _plzHasError
                ? const Icon(Icons.error, color: Colors.red)
                : const Icon(Icons.check, color: Colors.green),
          ),
          onChanged: (val) {
            setState(() {
              _plzHasError =
              !(_formKey.currentState?.fields['age']?.validate() ??
                  false);
            });
          },
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.saveAndValidate() ?? false) {
                    debugPrint(_formKey.currentState?.value.toString());
                  } else {
                    debugPrint(_formKey.currentState?.value.toString());
                    debugPrint('validation failed');
                  }
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  _formKey.currentState?.reset();
                },
                // color: Theme.of(context).colorScheme.secondary,
                child: Text(
                  'Reset',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
