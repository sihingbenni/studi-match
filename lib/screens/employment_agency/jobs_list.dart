import 'package:appinio_swiper/controllers.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:studi_match/widgets/appbar/default_appbar.dart';
import 'package:studi_match/widgets/bottom/swipe_bar.dart';
import 'package:studi_match/widgets/lists/swipe_list.dart';

import '../../widgets/router/nav_router.dart';

class EAJobsListScreen extends StatefulWidget {
  const EAJobsListScreen({Key? key}) : super(key: key);

  @override
  State<EAJobsListScreen> createState() => _EAJobsListScreenState();
}

class _EAJobsListScreenState extends State<EAJobsListScreen> {
  final appinioController = AppinioSwiperController();

  final flipCardController = FlipCardController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const DefaultAppbar(),
        body: SwipeList(
            appinioController: appinioController,
            flipcardController: flipCardController),
        bottomNavigationBar: SwipeBar(
            appinioController: appinioController,
            flipcardController: flipCardController),
      );
}
