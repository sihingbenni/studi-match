import 'package:flutter/material.dart';

class NavRouter extends MaterialPageRoute {
  NavRouter({builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);
}