import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';

import '../../models/job.dart';
import '../../models/query_parameters.dart';
import '../../providers/bookmark_provider.dart';
import '../../providers/job_provider.dart';
import '../../utilities/logger.dart';

class SwipeList extends StatefulWidget {
  const SwipeList({super.key});

  @override
  State<SwipeList> createState() => _SwipeListState();
}

class _SwipeListState extends State<SwipeList> {
  final JobProvider jobProvider = JobProvider();
  final BookmarkProvider bookmarkProvider = BookmarkProvider();

  final queryParameters = QueryParameters();

  final controller = AppinioSwiperController();

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
  Widget build(BuildContext context) =>
      SizedBox(
        child: AppinioSwiper(
            controller: controller,
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

              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: getAccentColor(index),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [job.logo],
                        ),
                        const SizedBox(height: 8),
                        Text(job.title ?? 'no title',
                            style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                        Text(job.employer ?? 'no-employer',
                            style: const TextStyle(color: Colors.black87)),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            const Text(
                              'Wann?',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Flexible(
                              child: Text(
                                  '${job.entryDate?.day}.${job.entryDate!.month}.${job.entryDate!.year}',
                                  maxLines: 2,
                                  style: const TextStyle(
                                      color: Colors.black87, fontSize: 16)),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            const Text(
                              'Wo?',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Flexible(
                              child: Text(
                                '${job.address?.city ?? 'no-city'}, ${job.address?.country ?? 'no-country'}',
                                maxLines: 2,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            const Text(
                              'Was?',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Flexible(
                              child: Text(
                                job.profession ?? 'no-profession',
                                maxLines: 2,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            const Text(
                              'Referenznummer:',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Flexible(
                              child: Text(
                                job.referenceNr ?? 'no-referenceNr',
                                maxLines: 2,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            const Text(
                              'Aktuelle Veröffentlichung:',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Flexible(
                              child: Text(
                                  '${job.currentPublicationDate?.day}.${job.currentPublicationDate!.month}.${job.currentPublicationDate!.year}',
                                  maxLines: 2,
                                  style: const TextStyle(
                                      color: Colors.black87, fontSize: 16)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
      );
}

