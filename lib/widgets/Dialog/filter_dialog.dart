import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studi_match/widgets/Dialog/filter_chip.dart';

class FilterDialog extends StatelessWidget{
  @override
  Widget build(BuildContext context) => ElevatedButton(onPressed: () => showFilterDialog(context), style: ElevatedButton.styleFrom(
      backgroundColor: Colors.greenAccent,
      padding: const EdgeInsets.symmetric(
          horizontal: 40, vertical: 10)), child: const Text(
    'Jetzt starten!',
    style: TextStyle(fontSize: 24, color: Colors.white),
  ));

  void showFilterDialog(BuildContext context) => showDialog(
      context: context, builder: (BuildContext context) => AlertDialog(
      title: const Text('Wonach suchst du?'),
      content: Column(
        children: [
          FilterChipWidget(),
        ],
      ),
  ));
  
  
}