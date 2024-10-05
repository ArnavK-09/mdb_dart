import 'dart:convert';
import 'package:dart_minds/dart_minds.dart' as dart_minds;

class DatabaseConfig {
  final String name;
  final String engine;
  final String description;
  final Map<String, dynamic> connectionData;
  final List<String> tables;

  DatabaseConfig({
    required this.name,
    required this.engine,
    required this.description,
    Map<String, dynamic>? connectionData,
    List<String>? tables,
  })  : connectionData = connectionData ?? {},
        tables = tables ?? [];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'engine': engine,
      'description': description,
      'connection_data': connectionData,
      'tables': tables,
    };
  }
}

class Datasource extends DatabaseConfig {
  Datasource({
    required super.name,
    required super.engine,
    required super.description,
    super.connectionData,
    super.tables,
  }) : super();
}

class Datasources {
  final dart_minds.Client client;

  Datasources(this.client);

  Future<Datasource> create(DatabaseConfig dsConfig,
      {bool replace = false}) async {
    final name = dsConfig.name;

    if (replace) {
      try {
        await get(name);
        await drop(name);
      } catch (e) {
        // Ignore
      }
    }

    await client.api.post('/datasources', dsConfig.toJson());

    return await get(name);
  }

  Future<List<Datasource>> list() async {
    final response = await client.api.get('/datasources');

    final List<dynamic> data = jsonDecode(response.body);
    return data
        .where((item) => item['engine'] != null)
        .map((item) => Datasource(
              name: item['name'],
              engine: item['engine'],
              description: item['description'],
              connectionData: item['connection_data'],
              tables: List<String>.from(item['tables'] ?? []),
            ))
        .toList();
  }

  Future<Datasource> get(String name) async {
    final response = await client.api.get('/datasources/$name');

    final data = jsonDecode(response.body);

    if (data['engine'] == null) {
      throw Exception('Wrong type of datasource: $name');
    }

    return Datasource(
      name: data['name'],
      engine: data['engine'],
      description: data['description'],
      connectionData: data['connection_data'],
      tables: List<String>.from(data['tables'] ?? []),
    );
  }

  Future<void> drop(String name) async {
    await client.api.delete('/datasources/$name');
  }
}

final demoDatasourceConfigForTesting = DatabaseConfig(
  name: 'example_ds',
  description: 'House Sales Data',
  engine: 'postgres',
  connectionData: {
    'user': 'demo_user',
    'password': 'demo_password',
    'host': 'samples.mindsdb.com',
    'port': '5432',
    'database': 'demo',
    'schema': 'demo_data'
  },
);
