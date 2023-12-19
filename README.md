# StudiMatch

StudiMatch is a Flutter application that simplifies the process for students to find their next
student job or internship using a Tinder-style swiping interface. To provide a curated list of
job opportunities, the app seamlessly integrates the Bundesagentur für Arbeit API. StudiMatch's
goal is to empower students to find relevant job opportunities in a familiar and engaging way.

## Getting Started

To contribute to the development of StudiMatch, follow these steps:

1. **Clone the repository:**
   ```bash
   git clone git@github.com:sihingbenni/studi-match.git
   ```

2. **Add dependencies:**
   Run the following command to fetch the project dependencies using `pub get`:
   ```bash
   flutter pub get
   ```

3. **Request Authentication:**
   Send an email to the repository owner requesting authentication for your computer. Once
   authenticated, you will have the necessary permissions to start contributing to the project.

4. **Start Developing:**
   You are now ready to start developing within our team. Feel free to explore the codebase, make
   changes, and contribute to the project.

## Dependencies

StudiMatch relies on the following Flutter packages:

```yaml
dependencies:
  sign_button: ^2.0.6
  flutter_svg: ^2.0.7
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  logger: ^2.0.2
  shared_preferences: ^2.2.1
  appinio_swiper: ^2.0.3
  cached_network_image: ^3.3.0
  provider: ^6.0.5
  firebase_auth: ^4.10.1
  firebase_core: ^2.24.2
  google_sign_in: ^6.1.5
  cloud_firestore: ^4.9.3
  flip_card: ^0.7.0
  email_validator: ^2.1.17
  http: ^1.1.0
  maps_launcher: ^2.2.0
  flutter_form_builder: ^9.1.1
  form_builder_validators: ^9.1.0
  geolocator: ^10.1.0
  geocoding: ^2.1.1
  url_launcher: ^6.2.2
```

## Bundesagentur für Arbeit API

The app integrates the Bundesagentur für Arbeit API, publicly available under the
Netzzugangsgesetz law in Germany. Obtain client credentials
from [jobsuche.api.bund.dev](https://jobsuche.api.bund.dev/) to access the API and to explore the
various endpoints of the API.

### Authentication via OAuth

To obtain a valid token for authentication, send a POST-request
to [https://rest.arbeitsagentur.de/oauth/gettoken_cc](https://rest.arbeitsagentur.de/oauth/gettoken_cc).
Refer to [GitHub - BundesAPI/jobsuche-api](https://github.com/bundesAPI/jobsuche-api) for more
information.

Feel free to contribute and make StudiMatch an even better platform for students seeking exciting
work opportunities!
