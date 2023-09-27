import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:studi_match/models/isolate_communication/isolated_stream_response.dart';
import 'package:studi_match/models/isolate_communication/register_isolate.dart';
import 'package:studi_match/models/job_list_item.dart';
import 'package:studi_match/models/job_search_response.dart';
import 'package:studi_match/models/query_parameters.dart';
import 'package:studi_match/services/employment_agency/job_search_service.dart';
import 'package:studi_match/utilities/logger.dart';

class IsolatedJobProvider {
  final QueryParameters _queryParameters;
  final String _id;
  final _service = EAJobSearchService();

  IsolatedJobProvider(this._id, this._queryParameters, SendPort sendPort) {
    // generate a token for the root isolate
    final rootToken = RootIsolateToken.instance!;

    // spawn the isolate with _IsolateData
    Isolate.spawn<_IsolateData>(
      _registerIsolate,
      _IsolateData(
        token: rootToken,
        sendPort: sendPort,
      ),
    );
  }

  void _registerIsolate(_IsolateData isolateData) {
    // ensure that the isolate is initialized
    BackgroundIsolateBinaryMessenger.ensureInitialized(isolateData.token);
    // create a new receivePort, so that the main isolate can send messages to this isolate
    final receivePort = ReceivePort();

    // register the isolate by sending the id and the sendPort to the main isolate
    isolateData.sendPort.send(
        IsolatedStreamResponse<RegisteredIsolate>(_id, RegisteredIsolate(receivePort.sendPort)));

    // listen for messages from the main isolate
    receivePort.listen((message) {
      logger.w(_queryParameters);
    });

    // fetch the jobs and send them to the main isolate
    getJobs().then((jobSearchResponse) {
      jobSearchResponse.jobListings
          .map((item) => JobListItem.fromJobListItem(item, _id))
          .cast<JobListItem>()
          .toList();
      isolateData.sendPort.send(IsolatedStreamResponse<JobSearchResponse>(_id, jobSearchResponse));
    });
  }

  Future<JobSearchResponse> getJobs() async => await _service.callJobsApi(_queryParameters);
}

/// Data that is passed to the isolate
class _IsolateData {
  /// The token of the root isolate is needed to ensure initialization of the isolate
  final RootIsolateToken token;

  /// the sendPort of the isolate is the port that is used to send messages to the main isolate
  final SendPort sendPort;

  _IsolateData({required this.token, required this.sendPort});
}
