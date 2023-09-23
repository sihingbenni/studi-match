import 'package:studi_match/models/facets.dart';
import 'package:studi_match/models/where_output.dart';

import '../job.dart';

class JobSearchResponse {
  late final List<Job> jobListings;
  late final int maxNrOfResults;
  late final int page;
  late final int size;
  late final WhereOutput? whereOutput;
  late final Facets facets;

  JobSearchResponse.fromEAJson(Map json) {
    // check if there are Results
    maxNrOfResults = json['maxErgebnisse'];
    page = json['page'];
    size = json['size'];

    // check if there are any results
    jobListings = json['stellenangebote'] != null
        ? json['stellenangebote']
            ?.map((e) => Job.fromEAJson(e.cast<String, dynamic>()))
            .cast<Job>()
            .toList()
        : [];
    whereOutput = json['woOutput'] != null ? WhereOutput.fromEAJson(json['woOutput']) : null;
    facets = Facets.fromEAJson(json['facetten']);
  }
}
