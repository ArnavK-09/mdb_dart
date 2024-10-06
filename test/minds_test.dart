
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

    tearDown(() async {
      await client.datasources.drop(tempDatasource.name);
    });

    test('Creating mind', () async {
      final res = await client.minds.create(
          name: mindName,
          modelName: "openai",
          datasources: [tempDatasource],
          replace: true);
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
      final mind1 = await client.minds.create(
          name: mindName,
          modelName: "openai",
          datasources: [tempDatasource],
          replace: true);

      final mind2 = await client.minds.create(
          name: mindName2,
          modelName: "openai",
          datasources: [tempDatasource],
          replace: true);

      expect(mind1.name, mindName);
      expect(mind2.name, mindName2);

      var fetchedMind1 = await client.minds.get(mindName);
      fetchedMind1 = await fetchedMind1.update(
        name: mindName2,
        datasources: [tempDatasource],
      );

      expect(fetchedMind1.name, mindName2);

      for (var i in (await client.minds.list())) {
        print(i.name);
        print(i.datasources);
      }

      // expect(() async => await client.minds.get(mindName),
      //     throwsA(isA<ObjectNotFound>()));

      final updatedMind = await client.minds.get(mindName2);
      expect(updatedMind.datasources?.length, 1);
    });

    test('Dropping multiple minds', () async {
      expect(() async => await client.minds.drop(mindName), returnsNormally);
      expect(() async => await client.minds.drop(mindName2), returnsNormally);
    });

    // test('Handling completion requests', () async {
    //   final mind = await client.minds.create(
    //     name: mindName,
    //     modelName: "openai",
    //     datasources: [tempDatasource],
    //     replace: true
    //   );

    //   final response = await mind.completion('say hello');
    //   expect(response.toLowerCase(), contains('hello'));

    //   final dataResponse = await mind.completion('what is the max rental price?');
    //   expect(dataResponse, contains('5602'));
    // });

    //   test('Streaming completion', () async {
    //     final mind = await client.minds.create(
    //       name: mindName2,
    //       modelName: "openai",
    //       datasources: [tempDatasource],
    //     );

    //     bool success = false;
    //     await for (var chunk in mind.completion('say hello', stream: true)) {
    //       if (chunk.content.toLowerCase().contains('hola')) {
    //         success = true;
    //       }
    //     }
    //     expect(success, isTrue);
    //   });
  });
}
