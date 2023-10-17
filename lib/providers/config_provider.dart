/// singleton class to provide the config
class ConfigProvider {
  static const String baseUrl = 'rest.arbeitsagentur.de';
  static const String jobSearchEndpoint = '/jobboerse/jobsuche-service/pc/v4/jobs';
  static const String jobLogoEndpoint = '/jobboerse/jobsuche-service/ed/v1/arbeitgeberlogo';
  static const String jobDetailsEndpoint = '/jobboerse/jobsuche-service/pc/v2/jobdetails/';
  static const String oAuthEndpoint = '/oauth/gettoken_cc';

  static const String clientId = 'c003a37f-024f-462a-b36d-b001be4cd24a';
  static const String clientSecret = '32a39620-32b3-4307-9aa1-511e3d7f48a8';
  static const String grantType = 'client_credentials';

  static const String bearerToken = 'ea_bearer_token';
  static const String bearerTokenValidUntil = 'ea_token_valid_until';

  //Bookmarks
  static const int bookmarkPageSize = 10;

  static const resultPackages = {
    'internship': {
      'listOfKeywords': ['Praktikum']
    },
    'workingStudent': {
      'listOfKeywords': ['Werkstudent', 'Student', 'Studentische']
    }
  };
}
