import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studi_match/providers/config_provider.dart';
import 'package:studi_match/providers/job_preferences_provider.dart';
import 'package:studi_match/utilities/logger.dart';

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
  int distance = 25;
  bool loading = true;
  final preferencesProvider = JobPreferencesProvider();

  final int maxDistance = 100;
  final int minDistance = 1;

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
  Widget build(BuildContext context) => Column(
    children: [
      Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SizedBox(
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
          width: 80,
          child: TextField(
            maxLength: 5,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            keyboardType: TextInputType.number,
            onChanged: (value) {
              location = value;
              logger.i(value);
            },

            onSubmitted: (value) {
              location = value;
              preferencesProvider.updateLocation(widget.uuid, location);
            },
            controller: TextEditingController(text: location),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'PLZ',
            ),
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 80,
            child: TextField(
              maxLength: 3,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (value.isEmpty) {
                  return;
                }
                int parsedInstance = int.parse(value);
                if (parsedInstance > maxDistance) {
                  parsedInstance = maxDistance;
                } else if (parsedInstance < minDistance) {
                  parsedInstance = minDistance;
                }
                distance = parsedInstance;
              },
              onSubmitted: (value) {
                preferencesProvider.updateDistance(widget.uuid, _getDistance(value));
              },
              controller: TextEditingController(text: distance.toString()),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Umkreis',
              ),
            ),
          ),
          Slider(
            value: _getDistance(distance).toDouble(),
            min: minDistance.toDouble(),
            max: maxDistance.toDouble(),
            divisions: 20,
            onChanged: (value) {
              setState(() {
                distance = value.toInt();
              });
            },
            onChangeEnd: (value) {
              preferencesProvider.updateDistance(widget.uuid, distance);
            },
            label: '$distance km',
          ),
        ],
      ),
    ],
  );

  int _getDistance(value) {
    int parsedInstance = distance;
    if (parsedInstance > maxDistance) {
      parsedInstance = maxDistance;
    } else if (parsedInstance < minDistance) {
      parsedInstance = minDistance;
    }
    setState(() {
      distance = parsedInstance;
    });
    return distance;
  }
}
