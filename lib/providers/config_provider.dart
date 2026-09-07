/// singleton class to provide the config
class ConfigProvider {
  static const String baseUrl = 'rest.arbeitsagentur.de';
  static const String jobSearchEndpoint =
      '/jobboerse/jobsuche-service/pc/v6/jobs';
  static const String jobLogoEndpoint =
      '/vermittlung/ag-darstellung-service/ct/v1/arbeitgeberlogo/';
  static const String jobDetailsEndpoint =
      '/jobboerse/jobsuche-service/pc/v4/jobdetails/';
  static const String apiKeyHeader = 'X-API-Key';
  static const String apiKey = 'jobboerse-jobsuche';

  static const String bearerToken = 'ea_bearer_token';
  static const String bearerTokenValidUntil = 'ea_token_valid_until';

  static const int preferencesMaxDistance = 200;
  static const int preferencesMinDistance = 0;
  static const int preferencesDistanceDivisions = 40;

  //Bookmarks load two more than the page size, so that the user can scroll
  static const int bookmarkPageSize = 12;

  static const resultPackages = {
    'Praktika': {
      'listOfKeywords': ['Praktikum']
    },
    'Werkstudenten Jobs': {
      'listOfKeywords': ['Werkstudent', 'Student', 'Studentische']
    }
  };
}
