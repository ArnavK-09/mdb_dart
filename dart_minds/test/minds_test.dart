
import 'package:dart_minds/dart_minds.dart' as minds;
import 'package:dart_minds/src/exceptions.dart';
import 'package:test/test.dart';

const apiKey =
    "";
final client = minds.Client(apiKey);
const mindName = "demo";
final tempDatasource = minds.DatabaseConfig(
  name: 'another_example_ds',
  description: minds.demoDatasourceConfigForTesting.description,
  engine: minds.demoDatasourceConfigForTesting.engine,
  connectionData: minds.demoDatasourceConfigForTesting.connectionData,
);

void main() {
  group('🧠 Minds Module Testing:-', () {
    setUp(() async =>
        await client.datasources.create(tempDatasource, replace: true));

    test('Creating mind', () async {
      final res = await client.minds.create(
          name: mindName, modelName: "openai", datasources: [tempDatasource]);
      expect(res, isA<minds.Mind>());
    });

    test('Avoiding repetion of mind naming', () async {
      expect(() async => await client.minds.create(name: mindName),
          throwsA(isA<ObjectAlreadyExists>()));
    });

    test('Listing minds', () async {
      final res = await client.minds.list();
      expect(res, isList);
    });

    test('Fetching information about mind', () async {
      final res = await client.minds.get(mindName);
      expect(res, isA<minds.Mind>());
    });

    test('Dropping mind', () async {
      expect(() async => await client.minds.drop(mindName), returnsNormally);
    });

    test('Handles wrong datasource information', () async {
      expect(() async => await client.minds.get("wrongmindname"),
          throwsA(isA<ObjectNotFound>()));
    });
  });
}
