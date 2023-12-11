import 'package:flutter/material.dart';

class NavRouter extends MaterialPageRoute {
  NavRouter({required super.builder});

  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);
}