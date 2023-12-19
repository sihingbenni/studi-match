import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:studi_match/widgets/appbar/custom_appbar.dart';
import 'package:studi_match/widgets/bottom/swipe_bar.dart';
import 'package:studi_match/widgets/lists/swipe_list.dart';

class EAJobsListScreen extends StatefulWidget {
  const EAJobsListScreen({super.key});

  @override
  State<EAJobsListScreen> createState() => _EAJobsListScreenState();
}

class _EAJobsListScreenState extends State<EAJobsListScreen> {
  final appinioController = AppinioSwiperController();

  final flipCardController = FlipCardController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const CustomAppbar(backButton: false,
            actionAccountIcon: false,
            userIsAnonymous: false,
            userIsNotAnonymous: false,
            actionBookmark: true),
        body: Builder(
          builder: (context) {
            try {
              return SwipeList(
                  appinioController: appinioController,
                  flipcardController: flipCardController);
            } on Exception catch (e) {
              return Center(
                child: Text(e.toString()),
              );
            }
          }
        ),
        bottomNavigationBar: SwipeBar(
            appinioController: appinioController,
            flipcardController: flipCardController),
      );
}
