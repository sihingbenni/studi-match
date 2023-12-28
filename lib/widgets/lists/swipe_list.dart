import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:studi_match/exceptions/package_missing_exception.dart';
import 'package:studi_match/exceptions/preferences_not_set_exception.dart';
import 'package:studi_match/exceptions/user_does_not_exists_exception.dart';
import 'package:studi_match/providers/job_details_provider.dart';
import 'package:studi_match/providers/pastel_color_provider.dart';
import 'package:studi_match/screens/account/onboarding_screen.dart';
import 'package:studi_match/widgets/router/end_of_list_router.dart';
import 'package:studi_match/widgets/router/nav_router.dart';

import '../../models/job.dart';
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

class _SwipeListState extends State<SwipeList> with TickerProviderStateMixin {
  // providers
  final JobProvider jobProvider = JobProvider();
  final BookmarkProvider bookmarkProvider = BookmarkProvider();
  final JobDetailsProvider jobDetailsProvider = JobDetailsProvider();

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
  bool endReached = false;

  void _restartAnimation(AnimationController animationController) {
    animationController.reset();
    animationController.forward();
  }

  void _addBookmark(int index) {
    bookmarkProvider.addBookmark(jobList[index]);
    _bookmarkAnimationState = AnimationState.add;
    _restartAnimation(_bookmarkAnimationController);
  }

  void _undoCardSwipe(int index) {
    // decrement the index and try to undo the bookmark
    if (bookmarkProvider.undoBookmark(jobList[index])) {
      // the undo was successful, start the animation
      _bookmarkAnimationState = AnimationState.remove;
      _restartAnimation(_bookmarkAnimationController);
    } else {
      // the card was not in the bookmarks, so it was dismissed
      _dismissedAnimationState = AnimationState.add;
      _restartAnimation(_dismissedAnimationController);
    }
  }

  void _dismissCard() {
    _dismissedAnimationState = AnimationState.remove;
    _restartAnimation(_dismissedAnimationController);
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
      return const Icon(Icons.restore_from_trash,
          color: Colors.green, size: 64);
    } else if (_dismissedAnimationState == AnimationState.remove) {
      return const Icon(Icons.delete_sweep, color: Colors.red, size: 64);
    }
    return null;
  }

  @override
  void initState() {
    super.initState();

    jobProvider.init().then((Exception? exception) {
      switch (exception.runtimeType) {
        case const (UserDoesNotExistsException):
        case const (PackageMissingException):
        case const (PreferencesNotSetException):
          Navigator.of(context).pop();
          Navigator.of(context).push(
            NavRouter(
              builder: (context) => const OnBoardingScreen(),
            ),
          );
          return;
        default:
          break;
      }
      if (exception != null) {
        logger.e(exception);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Es ist ein Fehler aufgetreten. Bitte versuche es später erneut.'),
          ),
        );
      }
    });

    // ---- start Animations ----
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

    _bookmarkAnimation = CurvedAnimation(
        parent: _bookmarkAnimationController, curve: Curves.easeOut);
    _dismissedAnimation = CurvedAnimation(
        parent: _dismissedAnimationController, curve: Curves.easeOut);

    // ----- end animations ----

    // add a listener to the job provider
    jobProvider.addListener(() {
      // on change update the list of jobs
      setState(() {
        jobList = jobProvider.jobList.values.toList();
      });
    });

    jobDetailsProvider.addListener(() {
      // the job list has been updated set the State to notify the listeners
      setState(() {});
    });
  }

  // Color generator
  PastelColorProvider pastelColorProvider = PastelColorProvider();

  @override
  void dispose() {
    jobProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(children: [
        Builder(builder: (context) {
          if (endReached) {
            return const EndOfListRouter();
          } else {
            return const SizedBox.shrink();
          }
        }),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Builder(builder: (context) {
            if (jobList.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return SizedBox(
              child: AppinioSwiper(
                controller: widget.appinioController,
                swipeOptions: const SwipeOptions.only(
                  left: true,
                  right: true,
                  up: false,
                  down: false,
                ),
                backgroundCardCount: 1,
                cardCount: jobList.length,
                backgroundCardOffset: const Offset(0, 0),
                onSwipeEnd: (int previousIndex, int targetIndex,
                    SwiperActivity activity) {
                  if (activity is Unswipe) {
                    _undoCardSwipe(targetIndex);
                    return;
                  }
                  if (activity is CancelSwipe) {
                    logger.d('Swipe cancelled');
                    return;
                  }
                  // If the card is flipped backwards, flip it back to front
                  widget.flipcardController.state!.isFront
                      ? null
                      : widget.flipcardController.toggleCardWithoutAnimation();
                  jobProvider.notify(
                      newIndex: targetIndex,
                      removedJob: jobList[previousIndex],
                      keywords: jobList[previousIndex].foundByKeyword.toList());
                  switch (activity.direction) {
                    case AxisDirection.left:
                      logger.d('Swiped left');
                      _dismissCard();
                      break;
                    case AxisDirection.right:
                      logger.d('Swiped right');
                      _addBookmark(previousIndex);
                      break;
                    case AxisDirection.up:
                      logger.d('Swiped up');
                      break;
                    case AxisDirection.down:
                      logger.d('Swiped down');
                      break;
                    default: // do nothing
                  }
                },
                onEnd: () {
                  logger.w('End reached');
                  setState(() {
                    endReached = true;
                  });
                },
                cardBuilder: (context, index) {
                  // set the job at the index
                  final Job job = jobList[index];
                  return FlipCard(
                      controller: widget.flipcardController,
                      direction: FlipDirection.VERTICAL,
                      front: FrontCard(
                          job: job,
                          accentColor:
                              pastelColorProvider.generatePastelColor(index)),
                      back: BackCard(
                          job: job,
                          accentColor:
                              pastelColorProvider.generatePastelColor(index)),
                      onFlip: () {
                        // if the card is first time flipped to the back, fetch the job details
                        if (job.jobDetails == null) {
                          jobDetailsProvider.getDetails(job);
                        }
                      });
                },
              ),
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
