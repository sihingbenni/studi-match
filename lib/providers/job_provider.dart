import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:studi_match/models/isolate_communication/isolated_stream_response.dart';
import 'package:studi_match/models/isolate_communication/register_isolate.dart';
import 'package:studi_match/models/job_list_item.dart';
import 'package:studi_match/models/job_search_response.dart';
import 'package:studi_match/providers/config_provider.dart';
import 'package:studi_match/providers/isolated_job_provider.dart';
import 'package:studi_match/providers/query_parameter_provider.dart';
import 'package:studi_match/utilities/logger.dart';

class JobProvider extends ChangeNotifier {
  bool isLoading = false;

  final List<JobListItem> _jobList = [];
  final Map<String, SendPort> _isolates = {};

  final _receivePort = ReceivePort();

  List<JobListItem> get jobList => _jobList;

  /// constructor
  JobProvider() {
    // The JobProvider has been created,
    // now lets create one isolate for each query that needs to be done.
    final listOfKeywords = ConfigProvider.resultPackages['workingStudent']!['listOfKeywords'];

    _receivePort.listen((message) {
      switch (message) {
        case IsolatedStreamResponse<RegisteredIsolate>():
          logger.d('Isolated JobProvider with keyword: "${message.fromIsolateId}" registered!');
          // save the sendPort of the isolate, so that we can later send messages to the isolate
          _isolates[message.fromIsolateId] = message.data.sendPort;
        case IsolatedStreamResponse<JobSearchResponse>():
          logger.i(message.data.maxNrOfResults);
          jobList.addAll(message.data.jobListings);
          notifyListeners();
        default:
          logger.e('Unknown Message received: $message');
      }
    });

    for (String keyword in listOfKeywords!) {
      final queryParameters = QueryParameterProvider().getWithKeyword(keyword);
      IsolatedJobProvider(keyword, queryParameters, _receivePort.sendPort);
    }
  }

  void refresh() {
    JobProvider();
  }

  void notify({required int nowAt, required JobListItem removedJobListItem}) {
    logger.t('Nr of Jobs in List: ${jobList.length} - Index: $nowAt');
    logger.t('JobListItem: ${removedJobListItem.keyword}');
    // TODO notify the right isolate that the index has changed
  }
}
