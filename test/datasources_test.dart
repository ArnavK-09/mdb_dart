import '../lib/mdb_dart.dart' as minds;
import '../lib/src/exceptions.dart';
import 'package:test/test.dart';
import 'package:dartenv/dartenv.dart';

// Required Variables to succeed tests
final apiKey = env("API_KEY");
final client = minds.Client(apiKey);
final demoConfig = minds.demoDatasourceConfigForTesting;

// Whole Testing Stuff Here
void main() {
  group('💿 Datasource Module Testing:-', () {
    test('Creating datasource', () async {
      final res = await client.datasources.create(demoConfig, replace: true);
      expect(res, isA<minds.Datasource>());
    });

    test('Avoiding repetion of datasource naming', () async {
      // await client.datasources.create(demoConfig, replace: true);
      // await client.datasources.create(demoConfig);
      expect(() async => await client.datasources.create(demoConfig),
          throwsA(isA<ObjectAlreadyExists>()));
    });

    test('Listing datasources', () async {
      final res = await client.datasources.list();
      expect(res, isList);
    });

    test('Fetching information about datasource', () async {
      final res = await client.datasources.get(demoConfig.name);
      expect(res, isA<minds.Datasource>());
    });

    test('Dropping datasource', () async {
      expect(() async => await client.datasources.drop(demoConfig.name),
          returnsNormally);
    });

    test('Handles wrong datasource information', () async {
      expect(() async => await client.datasources.get("demoConfigname"),
          throwsA(isA<ObjectNotFound>()));
    });
  });
}
