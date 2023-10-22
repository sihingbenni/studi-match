import 'package:flutter/material.dart';
import 'package:studi_match/widgets/appbar/default_appbar.dart';
import 'package:studi_match/widgets/lists/swipe_list.dart';

import '../../widgets/router/nav_router.dart';

class EAJobsListScreen extends StatelessWidget {
  const EAJobsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const DefaultAppbar(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                NavRouter(
                  builder: (context) => const EAJobsListScreen(),
                ));
          },
          child: const Icon(Icons.refresh),
        ),
        body: const SwipeList(),
      );
}
