import 'dart:convert';
import '../mdb_dart.dart' as mdb_dart;
import 'exceptions.dart';

/// Represents the configuration settings for a database.
///
/// Contains details such as the database [name], [engine], [description],
/// connection parameters, and the list of [tables].
class DatabaseConfig {
  /// The name of the database.
  final String name;

  /// The database engine.
  final String engine;

  /// A brief description of the database.
  final String description;

  /// Connection parameters for the database.
  final Map<String, dynamic> connectionData;

  /// A list of table names associated with the database.
  final List<String> tables;

  /// Creates a new [DatabaseConfig] instance.
  ///
  /// The [name], [engine], and [description] are required parameters.
  /// [connectionData] defaults to an empty map if not provided.
  /// [tables] defaults to an empty list if not provided.
  const DatabaseConfig({
    required this.name,
    required this.engine,
    required this.description,
    this.connectionData = const {},
    this.tables = const [],
  });

  /// ### toJson
  /// Converts the [DatabaseConfig] instance to a JSON-compatible map.
  ///
  /// Returns a [Map<String, dynamic>] representation of the instance.
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

/// A class that extends [DatabaseConfig] to represent a specific database datasource.
///
/// Inherits configuration settings such as [name], [engine], [description],
/// connection parameters, and [tables] from [DatabaseConfig].
class Datasource extends DatabaseConfig {
  /// Creates a new [Datasource] instance.
  ///
  /// The [name], [engine], and [description] are required parameters.
  /// [connectionData] and [tables] are optional and default to inherited values.
  const Datasource({
    required super.name,
    required super.engine,
    required super.description,
    super.connectionData,
    super.tables,
  });
}

/// A class for managing database datasources using the [Client].
///
/// Provides methods to create, list, retrieve, and delete datasources.
class Datasources {
  final mdb_dart.Client client;

  /// Creates a new [Datasources] instance with the specified [client].
  Datasources(this.client);

  /// Creates a new datasource using the provided [DatabaseConfig].
  ///
  /// This function allows you to create a new datasource in the system.
  /// If a datasource with the same name already exists and the [replace]
  /// parameter is set to true, it will attempt to drop the existing
  /// datasource before creating the new one.
  ///
  /// #### Parameters:
  /// - **`dsConfig`** [DatabaseConfig]
  ///   The configuration for the new datasource, including its name,
  ///   engine, description, connection data, and tables.
  /// - **`replace`**: [bool] (optional)
  ///   A flag indicating whether to replace an existing datasource with
  ///   the same name. If true, the function will attempt to drop the
  ///   existing datasource before creating a new one. Defaults to false.
  ///
  /// #### Returns:
  /// - **`Future<Datasource>`**
  ///   A [Future] that resolves to the created [Datasource]] object.
  ///
  /// #### Throws:
  /// - **[ValueError]**
  ///   If an error occurs while dropping the existing datasource when
  ///   [replace] is true.
  ///
  /// #### Example:
  /// ```dart
  /// final newDatasource = await datasources.create(
  ///   DatabaseConfig(
  ///     name: 'example_ds',
  ///     engine: 'postgres',
  ///     description: 'House Sales Data',
  ///     connectionData: {
  ///       'user': 'demo_user',
  ///       'password': 'demo_password',
  ///       'host': 'samples.mindsdb.com',
  ///       'port': '5432',
  ///       'database': 'demo',
  ///       'schema': 'demo_data',
  ///     },
  ///   ),
  ///   replace: true,
  /// );
  /// ```
  /// This example creates a new datasource named 'example_ds'. If a
  /// datasource with this name already exists, it will be dropped
  /// before the new one is created.
  Future<Datasource> create(DatabaseConfig dsConfig,
      {bool replace = false}) async {
    final name = dsConfig.name;

    try {
      if (replace) {
        await get(name);
        await drop(name);
      }
    } catch (e) {
      if (e is ObjectAlreadyExists) throw e;
    }
    await client.api.post('/datasources', dsConfig.toJson());
    return await get(name);
  }

  /// Retrieves a list of all available datasources.
  ///
  /// This function fetches all datasources from the server and returns a
  /// [List] of [Datasource] objects. Only datasources with a valid engine
  /// will be included in the result.
  ///
  /// #### Returns:
  /// - **`Future<List<Datasource>>`**
  ///   A [Future] that resolves to a list of [Datasource] objects.
  ///
  /// #### Example:
  /// ```dart
  /// final datasourcesList = await datasources.list();
  /// for (var datasource in datasourcesList) {
  ///   print('Datasource Name: ${datasource.name}, Engine: ${datasource.engine}');
  /// }
  /// ```
  /// This example retrieves all available datasources and prints their names and engines.
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

  /// Retrieves a specific datasource identified by [name].
  ///
  /// This function fetches the details of a [Datasource] from the server.
  /// If the [Datasource] does not have a valid engine, it will throw an error.
  ///
  /// #### Parameters:
  /// - **`name`**: [String]
  ///   The name of the datasource to be retrieved.
  ///
  /// #### Returns:
  /// - **`Future<Datasource>`**
  ///   A [Future] that resolves to the [Datasource] object corresponding to the specified name.
  ///
  /// #### Throws:
  /// - **[ValueError]**
  ///   If the retrieved [Datasource] does not have a valid engine.
  ///
  /// #### Example:
  /// ```dart
  /// try {
  ///   final datasource = await datasources.get('example_ds');
  ///   print('Datasource Name: ${datasource.name}, Engine: ${datasource.engine}');
  /// } catch (e) {
  ///   print('Error: $e');
  /// }
  /// ```
  /// This example retrieves the datasource named 'example_ds' and prints its [name] and engine.
  /// If the [Datasource] is not found or has an invalid engine, it will throw [Exception].
  Future<Datasource> get(String name) async {
    final response = await client.api.get('/datasources/$name');

    final data = jsonDecode(response.body);

    if (data['engine'] == null) {
      throw ValueError('Invalid datasource type: $name');
    }

    return Datasource(
      name: data['name'],
      engine: data['engine'],
      description: data['description'],
      connectionData: data['connection_data'],
      tables: List<String>.from(data['tables'] ?? []),
    );
  }

  /// Deletes a specific [Datasource] identified by [name].
  ///
  /// This function removes the [Datasource] from the server. If the [Datasource]
  /// does not exist, it may result in an [ObjectNotFound].
  ///
  /// #### Parameters:
  /// - **`name`**: [String]
  ///   The name of the datasource to be deleted.
  ///
  /// #### Returns:
  /// - **`Future<void>`**
  ///   A future that completes when the deletion is successful.
  ///
  /// #### Example:
  /// ```dart
  /// try {
  ///   await datasources.drop('example_ds');
  ///   print('Datasource dropped successfully.');
  /// } catch (e) {
  ///   print('Error: $e');
  /// }
  /// ```
  /// This example attempts to drop the [Datasource] named 'example_ds'
  Future<void> drop(String name) async {
    await client.api.delete('/datasources/$name');
  }
}

/// An instance of [DatabaseConfig] for testing purposes.
///
/// Represents a sample database configuration for a datasource named 'example_ds',
/// using PostgreSQL as the database engine. Contains connection details for accessing
/// the 'House Sales Data' database.
const demoDatasourceConfigForTesting = DatabaseConfig(
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
