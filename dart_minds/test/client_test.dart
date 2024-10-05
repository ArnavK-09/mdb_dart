import 'package:dart_minds/dart_minds.dart' as minds;
import 'package:dart_minds/src/exceptions.dart';
import 'package:test/test.dart';

const apiKey =
    "";
void main() {
  group('🤖 Client initialization keys check:-', () {
    test('Wrong API key does not works', () async {
      final client = minds.Client("wrong api key");
      expect(() async => await client.datasources.get('example_db'),
          throwsA(isA<Forbidden>()));
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
