
import 'dart:convert';

import 'package:studi_match/models/job_details.dart';
import 'package:studi_match/services/employment_agency/base_service.dart';
import 'package:studi_match/utilities/logger.dart';

class EAJobDetailsService extends EABaseService {

  Future<JobDetails> callJobsApi(String jobHashID) async {

    // convert the hashId to the id that the api expects (base64 encoded)
    final convertedHashId = _convertHashIdToJobDetailsId(jobHashID);

    // create uri
    final uri = Uri.https(baseUrl, jobDetailsEndpoint + convertedHashId);


    try {
      final responseString = await sendRequest(uri);
      return JobDetails.fromEAJson(jsonDecode(responseString));
    } catch (e) {
      logger.e(e.toString());
      logger.e('Failed to fetch the Employment Agency Job Details!\nused JobHashID: $jobHashID');
      //TODO handle the error
      throw Exception();
    }

  }

  String _convertHashIdToJobDetailsId(String jobHashID) => base64Encode(utf8.encode(jobHashID));

}
