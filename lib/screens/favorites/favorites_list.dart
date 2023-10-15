import 'package:flutter/material.dart';
import 'package:studi_match/widgets/navigation/bottom_navigation_bar.dart';

class FavoritesListScreen extends StatefulWidget {
  const FavoritesListScreen({super.key});

  @override
  State<FavoritesListScreen> createState() => _FavoritesListScreenState();
}

class _FavoritesListScreenState extends State<FavoritesListScreen> {
  int _currentIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    bottomNavigationBar: CustomNavigationBar(
      currentIndex: _currentIndex,
      onItemTapped: _onItemTapped,
    ),
  );
}
