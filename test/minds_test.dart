import 'package:mdb_dart/mdb_dart.dart' as minds;
import 'package:mdb_dart/src/exceptions.dart';
import 'package:test/test.dart';
import 'package:dartenv/dartenv.dart';
// import 'dart:copy';

// Required Variables to succeed tests
final apiKey = env("API_KEY");
final client = minds.Client(apiKey);
const mindName = "demo";
const mindName2 = "demo2";
final tempDatasource = minds.DatabaseConfig(
  name: 'another_example_ds',
  description: minds.demoDatasourceConfigForTesting.description,
  engine: minds.demoDatasourceConfigForTesting.engine,
  connectionData: minds.demoDatasourceConfigForTesting.connectionData,
);

// Utility function to get the client
minds.Client getClient() {
  return client;
}

// Whole Testing Stuff Here
void main() {
  group('🧠 Minds Module Testing:-', () {
    setUp(() async {
      await client.datasources.create(tempDatasource, replace: true);
    });

    test('Creating mind', () async {
      final res = await client.minds
          .create(name: mindName, datasources: [tempDatasource], replace: true);
      expect(res, isA<minds.Mind>());
    });

    test('Avoiding repetition of mind naming', () async {
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

    test('Creating and managing multiple minds', () async {
      final mind1 = await client.minds
          .create(name: mindName, datasources: [tempDatasource], replace: true);

      final mind2 = await client.minds.create(
          name: mindName2, datasources: [tempDatasource], replace: true);

      expect(mind1.name, mindName);
      expect(mind2.name, mindName2);

      var fetchedMind1 = await client.minds.get(mindName);

      expect(() async {
        var x = await fetchedMind1.update(
          name: mindName2,
          datasources: [tempDatasource],
        );
        print("rrrr ${x.name}");
      }, throwsA(isA<ObjectAlreadyExists>()));
    });

    test('Updating data', () async {
      var fetchedMind1 = await client.minds.get(mindName);
      expect(() async {
        await client.minds.drop(mindName2);
      }, returnsNormally);

      final updatedMind = await fetchedMind1.update(
        name: mindName2,
        datasources: [tempDatasource],
      );

      expect(updatedMind.name, equals(mindName2));
      expect(fetchedMind1.name, equals(mindName2));

      final fetchedMind = await client.minds.get(mindName2);
      expect(fetchedMind.datasources.length, 1);
    });

    test('Handling completion requests', () async {
      final mind = await client.minds.get(mindName2);
      mind.parameters.addAll({"temperature": "0"});
      String userMessage = "1+1";
      final response = await mind.completion(userMessage);
      String? res = response.choices.first.message.content?.first.text;
      expect(res!.contains("2"), isTrue);
    });

    test('Streaming chat responses', () async {
      final mind = await client.minds.get(mindName2);
      String userMessage = "hello";
      await for (var response in (await mind.streamCompletion(userMessage))) {
        final res = (response.choices.first.delta.content?.first?.text);
        expect(res?.length, greaterThanOrEqualTo(0));
      }
    });

    test('Dropping multiple minds', () async {
      expect(() async => await client.minds.drop(mindName2), returnsNormally);
      expect(() async => await client.minds.drop(mindName),
          throwsA(isA<ObjectNotFound>()));
      expect(() async => await client.datasources.drop(tempDatasource.name),
          returnsNormally);
    });
  });
}
