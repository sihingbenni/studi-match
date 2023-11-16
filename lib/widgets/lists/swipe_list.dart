import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:studi_match/utilities/pastel_color_generator.dart';

import '../../models/job.dart';
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

class _SwipeListState extends State<SwipeList> with TickerProviderStateMixin {
  // providers
  final JobProvider jobProvider = JobProvider();
  final BookmarkProvider bookmarkProvider = BookmarkProvider();

  // animation
  final _opacityTween = Tween<double>(begin: 1.0, end: 0.0);

  // bookmark animation
  late final AnimationController _bookmarkAnimationController;
  late final Animation<double> _bookmarkAnimation;
  AnimationState _bookmarkAnimationState = AnimationState.none;

  // dismiss animation
  late final AnimationController _dismissedAnimationController;
  late final Animation<double> _dismissedAnimation;
  AnimationState _dismissedAnimationState = AnimationState.none;

  int page = 1;
  List<Job> jobList = [];
  int maxNrOfResults = 0;
  int lastFetchedAt = 0;
  int _swiperIndex = 0;

  void restartAnimation(AnimationController animationController) {
    // todo think about resetting both controllers at the same time so that only one animation is running at a time
    animationController.reset();
    animationController.forward();
  }

  void _addBookmark(int index) {
    bookmarkProvider.addBookmark(jobList[index - 1]);
    _bookmarkAnimationState = AnimationState.add;
    restartAnimation(_bookmarkAnimationController);
  }

  void _undoCardSwipe() {
    // decrement the index and try to undo the bookmark
    if (bookmarkProvider.undoBookmark(jobList[--_swiperIndex])) {
      // the undo was successful, start the animation
      _bookmarkAnimationState = AnimationState.remove;
      restartAnimation(_bookmarkAnimationController);
    } else {
      // the card was not in the bookmarks, so it was dismissed
      _dismissedAnimationState = AnimationState.add;
      restartAnimation(_dismissedAnimationController);
    }
  }

  void _dismissCard() {
    _dismissedAnimationState = AnimationState.remove;
    restartAnimation(_dismissedAnimationController);
  }

  Icon? _getBookmarkStateIcon() {
    if (_bookmarkAnimationState == AnimationState.add) {
      return const Icon(Icons.bookmark_add, color: Colors.green, size: 64);
    } else if (_bookmarkAnimationState == AnimationState.remove) {
      return const Icon(Icons.bookmark_remove, color: Colors.red, size: 64);
    }
    return null;
  }

  Icon? _getDismissedStateIcon() {
    if (_dismissedAnimationState == AnimationState.add) {
      return const Icon(Icons.restore_from_trash, color: Colors.green, size: 64);
    } else if (_dismissedAnimationState == AnimationState.remove) {
      return const Icon(Icons.delete_sweep, color: Colors.red, size: 64);
    }
    return null;
  }

  @override
  void initState() {
    super.initState();

    // init Animations
    _bookmarkAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          _bookmarkAnimationState = AnimationState.none;
          _bookmarkAnimationController.reset();
        }
      });

    _dismissedAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          _dismissedAnimationState = AnimationState.none;
          _dismissedAnimationController.reset();
        }
      });

    _bookmarkAnimation =
        CurvedAnimation(parent: _bookmarkAnimationController, curve: Curves.easeOut);
    _dismissedAnimation =
        CurvedAnimation(parent: _dismissedAnimationController, curve: Curves.easeOut);

    // add a listener to the job provider
    jobProvider.addListener(() {
      // on change update the list of jobs
      setState(() {
        jobList = jobProvider.jobList.values.toList();
      });
    });
  }

  // Color generator
  PastelColorGenerator pastelColorGenerator = PastelColorGenerator();

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
                // check if a card was actually unswiped
                if (wasUnswiped) {
                  _undoCardSwipe();
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
                    _dismissCard();
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
                  direction: FlipDirection.VERTICAL,
                  front: FrontCard(job: job, accentColor: pastelColorGenerator.generatePastelColor(index)),
                  back: BackCard(job: job, accentColor: pastelColorGenerator.generatePastelColor(index)),
                );
              }),
        ),
        Positioned(
          bottom: 0,
          right: 28,
          child: Opacity(
            opacity: _bookmarkAnimationState != AnimationState.none
                ? _opacityTween.evaluate(_bookmarkAnimation)
                : 0,
            child: _getBookmarkStateIcon(),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 28,
          child: Opacity(
            opacity: _dismissedAnimationState != AnimationState.none
                ? _opacityTween.evaluate(_dismissedAnimation)
                : 0,
            child: _getDismissedStateIcon(),
          ),
        ),
      ]);
}

enum AnimationState {
  // create different states for the animation
  none, // no animation
  add, // add animation
  remove, // remove animation
}
