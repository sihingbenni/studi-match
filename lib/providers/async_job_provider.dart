

import 'package:studi_match/models/query_parameters.dart';

class AsyncJobProvider {
  final QueryParameters queryParameters;
  void Function() addToList;




  AsyncJobProvider(this.queryParameters, this.addToList);

  void getJobs() {
    addToList();
  }

}