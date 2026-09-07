import 'package:studi_match/models/facets.dart';
import 'package:studi_match/models/where_output.dart';

import 'job.dart';

class JobSearchResponse {
  late final List<Job> jobListings;
  late final int maxNrOfResults;
  late final int page;
  late final int size;
  late final WhereOutput? whereOutput;
  late final Facets facets;

  /// the keyword from which isolate the job was fetched
  late final String packageKeyword;

  JobSearchResponse.fromEAJson(Map json) {
    // check if there are Results
    maxNrOfResults = (json['maxErgebnisse'] is num)
        ? (json['maxErgebnisse'] as num).toInt()
        : (int.tryParse(json['maxErgebnisse']?.toString() ?? '0') ?? 0);
    page = (json['page'] is num)
        ? (json['page'] as num).toInt()
        : (int.tryParse(json['page']?.toString() ?? '1') ?? 1);
    size = (json['size'] is num)
        ? (json['size'] as num).toInt()
        : (int.tryParse(json['size']?.toString() ?? '20') ?? 20);

    // check if there are any results in v6 'ergebnisliste' or legacy 'stellenangebote'
    final jobsJson = json['ergebnisliste'] ?? json['stellenangebote'];
    jobListings = jobsJson != null
        ? (jobsJson as List)
            .map((e) => Job.fromEAJson((e as Map).cast<String, dynamic>()))
            .toList()
        : [];
    whereOutput = json['woOutput'] != null
        ? WhereOutput.fromEAJson((json['woOutput'] as Map).cast<String, dynamic>())
        : null;
    facets = Facets.fromEAJson(json['facetten']);
  }
}
