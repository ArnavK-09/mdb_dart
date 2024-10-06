// import 'package:mdb_dart/mdb_dart.dart' as minds;

// @ TODO
void main() async {
  // var client = minds.Client(String.fromEnvironment("API_KEY"));

  // print(env("API_KEY"));

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
