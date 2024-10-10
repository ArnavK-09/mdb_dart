import 'package:mdb_dart/mdb_dart.dart' as minds;
import 'package:mdb_dart/src/exceptions.dart';
import 'package:test/test.dart';
import 'package:dartenv/dartenv.dart';

// Required Variables to succeed tests
final apiKey = env("API_KEY");

// Whole Testing Stuff Here
void main() {
  group('🤖 Client initialization keys check:-', () {
    test('Wrong API key does not works', () async {
      final client = minds.Client("wrong api key");
      expect(() async => await client.datasources.get('example_db'),
          throwsA(isA<Unauthorized>()));
    });

    test('Correct API key works find', () async {
      final client = minds.Client(apiKey);
      expect(
          () async => await client.datasources
              .get("random_datasource_that_does_not_exist"),
          throwsA(isA<ObjectNotFound>()));
    });
  });
}
