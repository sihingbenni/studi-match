import 'package:flutter_test/flutter_test.dart';
import 'package:studi_match/models/job_details.dart';
import 'package:studi_match/models/job_search_response.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Arbeitsagentur v6 / v4 parsing tests', () {
    test('JobSearchResponse parses v6 response correctly', () {
      final v6Json = {
        'ergebnisliste': [
          {
            'stellenangebotsart': 'PRAKTIKUM_TRAINEE',
            'stellenangebotsTitel': 'Werkstudent*in (m/w/d) - Personalwesen',
            'arbeitszeitSchichtNachtWochenende': false,
            'arbeitszeitTeilzeitVormittag': true,
            'eintrittszeitraum': {'von': '2026-08-27'},
            'stellenlokationen': [
              {
                'adresse': {
                  'strasse': 'Hamburger Chaussee',
                  'hausnummer': '219',
                  'plz': '24113',
                  'ort': 'Kiel',
                  'region': 'SCHLESWIG_HOLSTEIN',
                  'land': 'DEUTSCHLAND'
                },
                'breite': 54.295551,
                'laenge': 10.103886
              }
            ],
            'datumErsteVeroeffentlichung': '2026-08-26',
            'aenderungsdatum': '2026-08-27T11:01:14.552',
            'hauptberuf': 'Bürogehilf(e/in)',
            'firma': 'Stiftung Drachensee OHK',
            'arbeitgeberKundennummerHash': 'H3JkR3GLtcblaBJe7D8UV',
            'referenznummer': '10001-1003602469-S',
            'entfernung': 2,
            'alleBerufe': ['Bürogehilf(e/in)']
          }
        ],
        'maxErgebnisse': 36,
        'page': 1,
        'size': 1,
        'woOutput': {
          'bereinigterOrt': '24113',
          'suchmodus': 'UMKREISSUCHE',
          'koordinaten': [
            {'lat': 54.28620915, 'lon': 10.0828312}
          ]
        },
        'facetten': {
          'arbeitsort': {
            'counts': {'Kiel': 27},
            'maxCount': 36
          }
        }
      };

      final response = JobSearchResponse.fromEAJson(v6Json);
      expect(response.maxNrOfResults, 36);
      expect(response.page, 1);
      expect(response.size, 1);
      expect(response.jobListings.length, 1);

      final job = response.jobListings.first;
      expect(job.title, 'Werkstudent*in (m/w/d) - Personalwesen');
      expect(job.profession, 'Bürogehilf(e/in)');
      expect(job.employer, 'Stiftung Drachensee OHK');
      expect(job.referenceNr, '10001-1003602469-S');
      expect(job.hashId, '10001-1003602469-S');
      expect(job.logoHashId, 'H3JkR3GLtcblaBJe7D8UV');
      expect(job.entryDate, DateTime(2026, 8, 27));
      expect(job.currentPublicationDate, DateTime(2026, 8, 26));

      expect(job.address, isNotNull);
      expect(job.address!.zipCode, '24113');
      expect(job.address!.city, 'Kiel');
      expect(job.address!.street, 'Hamburger Chaussee 219');
      expect(job.address!.distance, 2.0);
      expect(job.address!.coordinates?.lat, 54.295551);
      expect(job.address!.coordinates?.lon, 10.103886);
    });

    test('JobDetails parses v4 response correctly', () {
      final v4DetailsJson = {
        'stellenangebotsart': 'PRAKTIKUM_TRAINEE',
        'stellenangebotsTitel': 'Werkstudent*in (m/w/d) - Personalwesen',
        'stellenangebotsBeschreibung': 'Spannende Aufgaben im Personalwesen',
        'eintrittszeitraum': {'von': '2026-08-27'},
        'datumErsteVeroeffentlichung': '2026-08-26',
        'aenderungsdatum': '2026-08-27T11:01:14.552',
        'hauptberuf': 'Bürogehilf(e/in)',
        'firma': 'Stiftung Drachensee OHK',
        'arbeitgeberKundennummerHash': 'H3JkR3GLtcblaBJe7D8UV',
        'referenznummer': '10001-1003602469-S',
        'stellenlokationen': [
          {
            'adresse': {
              'strasse': 'Hamburger Chaussee',
              'hausnummer': '219',
              'plz': '24113',
              'ort': 'Kiel',
              'region': 'SCHLESWIG_HOLSTEIN',
              'land': 'DEUTSCHLAND'
            },
            'breite': 54.295551,
            'laenge': 10.103886
          }
        ]
      };

      final details = JobDetails.fromEAJson(v4DetailsJson);
      expect(details.title, 'Werkstudent*in (m/w/d) - Personalwesen');
      expect(details.profession, 'Bürogehilf(e/in)');
      expect(details.jobDescription, 'Spannende Aufgaben im Personalwesen');
      expect(details.employer, 'Stiftung Drachensee OHK');
      expect(details.referenceNr, '10001-1003602469-S');
      expect(details.employerLogoHashId, 'H3JkR3GLtcblaBJe7D8UV');
      expect(details.workplaces.length, 1);
      expect(details.workplaces.first.city, 'Kiel');
      expect(details.workplaces.first.street, 'Hamburger Chaussee 219');
    });
  });
}
