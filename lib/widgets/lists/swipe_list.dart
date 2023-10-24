import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';

import '../../models/job.dart';
import '../../models/query_parameters.dart';
import '../../providers/bookmark_provider.dart';
import '../../providers/job_provider.dart';
import '../../utilities/logger.dart';
import '../details/back_card.dart';
import '../details/front_card.dart';

class SwipeList extends StatefulWidget {
  const SwipeList(
      {super.key,
      required this.flipcardController,
      required this.appinioController});

  final AppinioSwiperController appinioController;
  final FlipCardController flipcardController;

  @override
  State<SwipeList> createState() => _SwipeListState();
}

class _SwipeListState extends State<SwipeList> {
  final JobProvider jobProvider = JobProvider();
  final BookmarkProvider bookmarkProvider = BookmarkProvider();

  final queryParameters = QueryParameters();

  int page = 1;
  List<Job> jobList = [];
  int maxNrOfResults = 0;
  int lastFetchedAt = 0;

  @override
  void initState() {
    super.initState();

    jobProvider.addListener(() {
      // on change update the list of jobs
      setState(() {
        jobList = jobProvider.jobList.values.toList();
      });
    });
  }

  // TODO: implement a better way to get the accent color and change text color accordingly
  MaterialAccentColor getAccentColor(int index) =>
      Colors.accents[index % Colors.accents.length];

  @override
  void dispose() {
    jobProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        child: AppinioSwiper(
            controller: widget.appinioController,
            swipeOptions: const AppinioSwipeOptions.only(
              left: true,
              right: true,
              top: false,
              bottom: false,
            ),
            backgroundCardsCount: 3,
            cardsCount: jobList.length,
            cardsSpacing: 10,
            onSwipe: (index, direction) {
              jobProvider.notify(
                  newIndex: index,
                  removedJob: jobList[index - 1],
                  keywords: jobList[index - 1].foundByKeyword.toList());
              switch (direction) {
                case AppinioSwiperDirection.left:
                  logger.d('Swiped left');
                  break;
                case AppinioSwiperDirection.right:
                  logger.d('Swiped right');
                  bookmarkProvider.addBookmark(jobList[index - 1]);
                  break;
                case AppinioSwiperDirection.top:
                  logger.d('Swiped up');
                  break;
                case AppinioSwiperDirection.bottom:
                  logger.d('Swiped down');
                  break;
                default: // do nothing
              }
            },
            onEnd: () {
              logger.w('End reached');
              //TODO make sure that no more are loading
            },
            cardsBuilder: (context, index) {
              // set the job at the index
              final Job job = jobList[index];

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: FlipCard(
                  controller: widget.flipcardController,
                  direction: FlipDirection.HORIZONTAL,
                  front: FrontCard(job: job, accentColor: getAccentColor(index)),
                  back: BackCard(job: job, accentColor: getAccentColor(index)),
                ),
              );
            }),
      );
}
