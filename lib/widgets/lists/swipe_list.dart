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
  const SwipeList({super.key, required this.flipcardController, required this.appinioController});

  final AppinioSwiperController appinioController;
  final FlipCardController flipcardController;

  @override
  State<SwipeList> createState() => _SwipeListState();
}

class _SwipeListState extends State<SwipeList> with SingleTickerProviderStateMixin {
  final JobProvider jobProvider = JobProvider();
  final BookmarkProvider bookmarkProvider = BookmarkProvider();

  late final AnimationController _animationController;
  late final Animation<double> _animation;

  final queryParameters = QueryParameters();
  final _opacityTween = Tween<double>(begin: 1.0, end: 0.0);

  bool _bookmarkAddRunning = false;
  bool _bookmarkDelRunning = false;

  int page = 1;
  List<Job> jobList = [];
  int maxNrOfResults = 0;
  int lastFetchedAt = 0;

  int _swiperIndex = 0;

  void _addBookmark(int index) {
    bookmarkProvider.addBookmark(jobList[index - 1]);
    _bookmarkDelRunning = false;
    _bookmarkAddRunning = true;
    _animationController.reset();
    _animationController.forward();
  }

  void _removeBookmark() {
    // decrement the index and try to undo the bookmark
    if (bookmarkProvider.undoBookmark(jobList[--_swiperIndex])) {
      // the undo was successful, start the animation
      _bookmarkAddRunning = false;
      _bookmarkDelRunning = true;
      _animationController.reset();
      _animationController.forward();
    }
  }

  Icon? _getBookmarkStateIcon() {
    if (_bookmarkAddRunning) {
      return const Icon(Icons.bookmark_add, color: Colors.green, size: 64);
    } else if (_bookmarkDelRunning) {
      return const Icon(Icons.bookmark_remove, color: Colors.red, size: 64);
    }
    return null;
  }

  @override
  void initState() {
    super.initState();

    // Animation stuff
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((state) {
        if (state == AnimationStatus.forward) {
        }
        if (state == AnimationStatus.completed) {
          logger.i('Animation completed');
          _bookmarkAddRunning = false;
          _bookmarkDelRunning = false;
          _animationController.reset();
        } else if (state == AnimationStatus.dismissed) {
          logger.i('Animation dismissed');
        }
      });

    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeOut);

    // add a listener to the job provider
    jobProvider.addListener(() {
      // on change update the list of jobs
      setState(() {
        jobList = jobProvider.jobList.values.toList();
      });
    });
  }

  // TODO: implement a better way to get the accent color and change text color accordingly
  MaterialAccentColor getAccentColor(int index) => Colors.accents[index % Colors.accents.length];

  @override
  void dispose() {
    jobProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(children: [
        const Padding(padding: EdgeInsets.all(16.0)),
        SizedBox(
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
              unlimitedUnswipe: true,
              unswipe: (wasUnswiped) {
                if (wasUnswiped) {
                  _removeBookmark();
                }
              },
              onSwipe: (index, direction) {
                // If the card is flipped backwards, flip it back to front
                widget.flipcardController.state!.isFront
                    ? null
                    : widget.flipcardController.toggleCardWithoutAnimation();
                _swiperIndex = index;
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
                    _addBookmark(index);
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

                return FlipCard(
                  controller: widget.flipcardController,
                  direction: FlipDirection.HORIZONTAL,
                  front: FrontCard(job: job, accentColor: getAccentColor(index)),
                  back: BackCard(job: job, accentColor: getAccentColor(index)),
                );
              }),
        ),
        Positioned(
          bottom: 0,
          right: 28,
          child: Opacity(
            opacity:
                _bookmarkAddRunning || _bookmarkDelRunning ? _opacityTween.evaluate(_animation) : 0,
            child: _getBookmarkStateIcon(),
          ),
        ),
      ]);
}
