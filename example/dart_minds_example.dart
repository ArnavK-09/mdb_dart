import 'package:mdb_dart/mdb_dart.dart' as minds;
import 'package:dartenv/dartenv.dart';

const mindName = "demo";
const mindName2 = "demo2";
final tempDatasource = minds.DatabaseConfig(
  name: 'another_example_ds',
  description: minds.demoDatasourceConfigForTesting.description,
  engine: minds.demoDatasourceConfigForTesting.engine,
  connectionData: minds.demoDatasourceConfigForTesting.connectionData,
);

void main() async {
  var client = minds.Client(env("API_KEY"));
  await client.datasources.create(tempDatasource, replace: true);

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

  // expect(mind1.name, mindName);
  // expect(mind2.name, mindName2);

  print("mind 1  ${mind1.name} is $mindName");
  print("mind 2 ${mind2.name} is $mindName");

  // await client.minds.drop(mindName2);

  var fetchedMind1 = await client.minds.get(mindName);
  fetchedMind1 = await fetchedMind1.update(
    name: mindName2,
    datasources: [tempDatasource],
  );

  print("${fetchedMind1.name} updated from $mindName to $mindName2");

  // expect(fetchedMind1.name, mindName2);

  // for (var i in (await client.minds.list())) {
  //   print(i.name);
  //   print(i.datasources);
  // }

  // expect(() async => await client.minds.get(mindName),
  //     throwsA(isA<ObjectNotFound>()));

  final updatedMind = await client.minds.get(mindName2);
  print("${updatedMind.datasources.length} is length of updated $mindName2");
  // expect(updatedMind.datasources?.length, 1);

/*
  var postgresConfig = DatabaseConfig(
    name: 'my_datasource',
    description: '<DESCRIPTION-OF-YOUR-DATA>',
    engine: 'postgres',
    connectionData: {
      'user': 'demo_user',
      'password': 'demo_password',
      'host': 'samples.mindsdb.com',
      'port': 5432,
      'database': 'demo',
      'schema': 'demo_data',
    },
    tables: ['<TABLE-1>', '<TABLE-2>'],
  );

  var mind = await client.minds
      .create(name: 'mind_name', datasources: [postgresConfig], replace: true);
  var datasource = await client.datasources.create(postgresConfig);
  var mind2 =
      await client.minds.create(name: 'mind_name', datasources: [datasource]);

  var mind3 = await client.minds.create(name: 'mind_name');
  mind3.addDatasource(postgresConfig);
  mind3.addDatasource(datasource);

  mind.update(name: 'mind_name', datasources: [postgresConfig]);

  var ds = client.datasources.get('my_datasource');

  await client.datasources.drop('my_datasource');

  print(mind2);
  print(ds);
  print(await client.minds.get('mind_name'));
  print(await client.minds.list());
  print(await client.datasources.list());
  print(client);
  print(postgresConfig.toJson()); */
}
