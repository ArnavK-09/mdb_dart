import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart';
import 'rest_api.dart';
import 'package:dart_openai/dart_openai.dart';
import 'exceptions.dart' as exc;
import 'datasources.dart';
import "package:mdb_dart/mdb_dart.dart" as mdb_dart;

/// Default template for prompts used in ai queries.
const String defaultPromptTemplate =
    "Use your database tools to answer the user's question: {{question}}";

/// Represents a Mind in the MindsDB project.
///
/// This class encapsulates the properties and methods associated with a Mind,
/// allowing for interaction with the MindsDB API.
///
/// #### Properties:
/// - **`name`**: [String]
///   The name of the Mind.
/// - **`modelName`**: [String] (optional)
///   The name of the model associated with the Mind.
/// - **`provider`**: [String] (optional)
///   The provider for the Mind, such as OpenAI.
/// - **`parameters`**: [Map<String, dynamic>]
///   A map of parameters for configuring the Mind.
/// - **`promptTemplate`**: [String] (optional)
///   An optional template for prompts used by the Mind.
/// - **`createdAt`**: [String] (optional)
///   The timestamp when the Mind was created.
/// - **`updatedAt`**: [String] (optional)
///   The timestamp when the Mind was last updated.
/// - **`datasources`**: [List] of either [String]/[Datasource] (optional)
///   A list of data sources associated with the Mind.
class Mind {
  final RestAPI api;
  final mdb_dart.Client client;
  final String project = 'mindsdb';

  String name;
  final String? modelName;
  final String? provider;
  final Map<String, dynamic> parameters;
  final String? promptTemplate;
  final String? createdAt;
  final String? updatedAt;
  List<dynamic>? datasources;

  /// Constructor
  Mind({
    required this.client,
    required this.name,
    this.modelName,
    this.provider,
    Map<String, dynamic>? parameters,
    this.datasources,
    this.createdAt,
    this.updatedAt,
  })  : api = client.api,
        parameters = parameters ?? {},
        promptTemplate = parameters?['prompt_template'] as String?;

  /// Updates the properties of the mind.
  ///
  /// This method allows for modifying various attributes of the mind, including
  /// its name, model name, provider, prompt template, and associated datasources.
  /// Only the parameters that are specified will be updated. The updated mind
  /// object is then retrieved.
  ///
  /// #### Parameters:
  /// - **`name`**: [String] (optional)
  ///   The new name for the mind (if changing).
  /// - **`modelName`**: [String] (optional)
  ///   The new model name to be associated with the mind.
  /// - **`provider`**: [String] (optional)
  ///   The provider for the mind's model.
  /// - **`promptTemplate`**: [String] (optional)
  ///   The template for prompts used by the mind.
  /// - **`datasources`**: [List] of [DatabaseConfig] (optional)
  ///   A list of new datasources to be associated with the mind.
  /// - **`parameters`**: [Map<String, dynamic>] (optional)
  ///   Additional parameters for the mind.
  ///
  /// #### Returns:
  /// - **`Future<Mind>`**
  ///   A [Future] that resolves to the updated [Mind] object.
  ///
  /// #### Example:
  /// ```dart
  /// final updatedMind = await mind.update(
  ///   name: 'new_mind_name',
  ///   promptTemplate: 'Provide a elabortaed answer for: {{question}}',
  ///   datasources: ["datasource_name"],
  /// );
  /// print('Mind updated successfully: ${updatedMind.name}');
  /// ```
  /// This example demonstrates how to update a mind with a new name, prompt template, and associated datasource.
  Future<Mind> update({
    String? name,
    String? modelName,
    String? provider,
    String? promptTemplate,
    List<DatabaseConfig>? datasources,
    Map<String, dynamic>? parameters,
  }) async {
    final Map<String, dynamic> data = {};

    if (datasources != null) {
      final dsNames =
          datasources.map((ds) => client.minds._checkDatasource(ds)).toList();
      data['datasources'] = dsNames;
    }

    if (name != null) data['name'] = name;
    if (modelName != null) data['model_name'] = modelName;
    if (provider != null) data['provider'] = provider;

    data['parameters'] = parameters ?? {};

    if (promptTemplate != null) {
      data['parameters']['prompt_template'] = promptTemplate;
    }

    await api.patch(
      '/projects/$project/minds/$name',
      data,
    );

    if (name != null && name != this.name) {
      this.name = name;
    }

    return await client.minds.get(this.name);
  }

  /// Adds a new datasource to the current mind.
  ///
  /// This method associates a specified [Datasource] with the [Mind]. It expects
  /// a [DatabaseConfig] object and verifies the [Datasource] before adding it.
  /// If the datasource is successfully added, the updated list of datasources
  /// is retrieved.
  ///
  /// #### Parameters:
  /// - **`datasource`**: [DatabaseConfig] or [String] or [Datasource]
  ///   The datasource to be added to the mind.
  ///
  /// #### Returns:
  /// - **`Future<void>`**
  ///   A [Future] that completes when the datasource has been successfully added.
  ///
  /// #### Example:
  /// ```dart
  /// await mind.addDatasource(myDatasource);
  /// print('Datasource added successfully.');
  /// ```
  /// This example attempts to add a datasource to the current mind.
  Future<void> addDatasource(dynamic datasource) async {
    final dsName = client.minds._checkDatasource(datasource);
    await api
        .post('/projects/$project/minds/$name/datasources', {'name': dsName});

    final updated = await client.minds.get(name);
    datasources = updated.datasources;
  }

  /// Deletes a specific datasource from the current mind.
  ///
  /// This method removes a datasource identified by its name or [Datasource] object
  /// from the mind's configuration. If the provided datasource type is unknown,
  /// it throws a [ValueError].
  ///
  /// #### Parameters:
  /// - **`datasource`**: [dynamic]
  ///   The datasource to be deleted. It can be either a [Datasource] object
  ///   or a [String] representing the datasource's name.
  ///
  /// #### Returns:
  /// - **`Future<void>`**
  ///   A [Future] that completes when the datasource has been successfully removed.
  ///
  /// #### Example:
  /// ```dart
  /// try {
  ///   await mind.delDatasource('example_datasource');
  ///   print('Datasource deleted successfully.');
  /// } catch (e) {
  ///   print('Error: $e');
  /// }
  /// ```
  /// This example attempts to delete a datasource named 'example_datasource'.
  Future<void> delDatasource(dynamic datasource) async {
    String datasourceName;

    if (datasource is Datasource) {
      datasourceName = datasource.name;
    } else if (datasource is String) {
      datasourceName = datasource;
    } else {
      throw exc.ValueError('Unknown type of datasource: $datasource');
    }

    await api
        .delete('/projects/$project/minds/$name/datasources/$datasourceName');

    final updated = await client.minds.get(name);
    datasources = updated.datasources;
  }

  /// @TODO
  Future<dynamic> completion(String message, {bool stream = false}) async {
    final parsedUrl = Uri.parse(api.baseUrl);
    final llmHost =
        parsedUrl.host == 'mdb.ai' ? 'llm.mdb.ai' : 'ai.${parsedUrl.host}';

    final baseUrl = parsedUrl.replace(path: '', host: llmHost).toString();

    OpenAI.apiKey = api.apiKey;
    OpenAI.baseUrl = baseUrl;

    final openaiClient = OpenAI.instance;

    if (stream) {
      Stream<OpenAIStreamCompletionModel> completionStream =
          OpenAI.instance.completion.createStream(
        model: name,
        prompt: message,
      );

      return completionStream;
    } else {
      final response = await openaiClient.completion.create(
        model: name,
        prompt: message,
      );
      return response.choices.first.text;
    }
  }

  /// @ TODO
  Stream<dynamic> streamResponse(
      Stream<OpenAIStreamCompletionModel> response) async* {
    await for (var chunk in response) {
      yield chunk.choices.first.text;
    }
  }

  /// Creates a new instance of [Mind] from a JSON map.
  ///
  /// This factory constructor takes a [Client] and a JSON map as input,
  /// extracting relevant fields to initialize a [Mind] object.
  ///
  /// #### Parameters:
  /// - **`client`**: [Client]
  ///   The client used to interact with the MindsDB API.
  /// - **`json`**: [Map<String, dynamic>]
  ///   A map containing the JSON representation of a Mind.
  ///
  /// #### Returns:
  /// - **`Mind`**
  ///   An instance of [Mind] initialized with values from the JSON map.
  ///
  /// #### Example:
  /// ```dart
  /// Map<String, dynamic> jsonData = {
  ///   'name': 'example_mind',
  ///   'model_name': 'openai',
  ///   'provider': 'openai',
  ///   'parameters': {'key': 'value'},
  ///   'datasources': ['datasource1'],
  ///   'created_at': '2023-01-01T00:00:00Z',
  ///   'updated_at': '2023-01-02T00:00:00Z',
  /// };
  ///
  /// Mind mind = Mind.fromJson(client, jsonData);
  /// ```
  factory Mind.fromJson(mdb_dart.Client client, Map<String, dynamic> json) {
    return Mind(
      client: client,
      name: json['name'],
      modelName: json['model_name'],
      provider: json['provider'],
      parameters: json['parameters'] ?? {},
      datasources: json['datasources'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

/// ### Minds
/// A class for managing [Mind]s in the MindsDB API.
///
/// #### Constructor:
/// - **`Minds(Client client)`**
///   Creates a new [Minds] instance with the specified [Client].
///
///   - **Parameters**:
///     - **`client`**: [Client]
///       The client instance used to interact with the MindsDB API.
class Minds {
  final mdb_dart.Client client;
  final String project = 'mindsdb';
  final RestAPI api;

  Minds(
    this.client,
  ) : api = client.api;

  /// Retrieves a list of all [Mind] objects associated with the current project.
  ///
  /// This function fetches the details of minds from the MindsDB API and
  /// constructs a list of [Mind] objects based on the retrieved data.
  ///
  /// #### Returns:
  /// - **`Future<List<Mind>>`**
  ///   A [Future] that resolves to a [List] of [Mind] objects. If no minds are found,
  ///   an empty list is returned.
  ///
  /// #### Example:
  /// ```dart
  /// final minds = await client.minds.list();
  /// for (var mind in minds) {
  ///   print('Mind Name: ${mind.name}');
  /// }
  /// ```
  /// This example retrieves and prints the names of all minds associated with the project.
  Future<List<Mind>> list() async {
    final response = await api.get('/projects/$project/minds');
    final List<dynamic> data = jsonDecode(response.body);
    List<Mind> mindsList = [];

    for (var item in data) {
      mindsList.add(Mind.fromJson(client, item));
    }

    return mindsList;
  }

  /// Retrieves a specific [Mind] object identified by [name].
  ///
  /// This function fetches the details of a mind from the MindsDB API
  /// using the provided name. If the mind does not exist, it may result
  /// in an [ObjectNotFound] exception.
  ///
  /// #### Parameters:
  /// - **`name`**: [String]
  ///   The name of the mind to be retrieved.
  ///
  /// #### Returns:
  /// - **`Future<Mind>`**
  ///   A [Future] that resolves to the corresponding [Mind] object. If the mind
  ///   is not found, an exception is thrown.
  ///
  /// #### Example:
  /// ```dart
  /// final mind = await client.minds.get('demo');
  /// print('Mind retrieved: ${mind.name}');
  /// ```
  /// This example attempts to retrieve the [Mind] named 'demo' and prints its name.
  Future<Mind> get(String name) async {
    final response = await api.get('/projects/$project/minds/$name');
    final Map<String, dynamic> data = jsonDecode(response.body);
    return Mind.fromJson(client, data);
  }

  /// Creates a new [Mind] object with the specified parameters.
  ///
  /// This function initializes a new mind in the MindsDB system.
  /// If a mind with the same name already exists and [replace] is set to
  /// true, the existing mind will be dropped before creating a new one.
  ///
  /// #### Parameters:
  /// - **`name`**: [String]
  ///   The name of the mind to be created. This must be unique.
  ///
  /// - **`modelName`**: [String] (optional)
  ///   The name of the llm model to be used by the mind.
  ///
  /// - **`provider`**: [String] (optional)
  ///   The provider for the llm
  ///
  /// - **`promptTemplate`**: [String] (optional)
  ///   Custom instructions to llm
  ///
  /// - **`datasources`**: [List] of either [String] or [Datasource] or [DatabaseConfig] (optional)
  ///   A list of datasources that the mind will use.
  ///
  /// - **`parameters`**: [Map<String, dynamic>?] (optional)
  ///   Additional parameters for the mind.
  ///
  /// - **`replace`**: [bool] (optional)
  ///   (Default: `false`) If true, any existing mind with the same name
  ///   will be dropped before creating the new one.
  ///
  /// #### Returns:
  /// - **`Future<Mind>`**
  ///   A [Future] that resolves to the newly created [Mind] object.
  ///
  /// #### Example:
  /// ```dart
  /// final newMind = await client.minds.create(
  ///   name: 'demo',
  ///   modelName: 'openai',
  ///   provider: 'openai',
  ///   promptTemplate: 'Answer in German',
  ///   datasources: ["datasource_name"],
  /// );
  /// print('Mind created: ${newMind.name}');
  /// ```
  /// This example attempts to create a new [Mind] named 'demo'.
  Future<Mind> create({
    required String name,
    String? modelName,
    String? provider,
    String? promptTemplate,
    List<dynamic>? datasources,
    Map<String, dynamic>? parameters,
    bool replace = false,
  }) async {
    if (replace) {
      try {
        await get(name);
        await drop(name);
      } catch (e) {
        // Ignore
      }
    }

    final dsNames =
        datasources?.map((ds) => _checkDatasource(ds)).toList() ?? [];
    parameters ??= {};

    if (promptTemplate != null) {
      parameters['prompt_template'] = promptTemplate;
    }
    if (!parameters.containsKey('prompt_template')) {
      parameters['prompt_template'] = defaultPromptTemplate;
    }

    await api.post(
      '/projects/$project/minds',
      {
        'name': name,
        'model_name': modelName,
        'provider': provider,
        'parameters': parameters,
        'datasources': dsNames,
      },
    );

    return await get(name);
  }

  /// This function removes the mind from the server. If the mind does not exist,
  /// it may result in an [ObjectNotFound] error.
  ///
  /// #### Parameters:
  /// - **`name`**: [String]
  ///   The name of the [Mind] to be deleted.
  ///
  /// #### Returns:
  /// - **`Future<void>`**
  ///   A future that completes when the deletion is successful.
  ///
  /// #### Example:
  /// ```dart
  /// try {
  ///   await client.minds.drop('example_mind');
  ///   print('Mind dropped successfully.');
  /// } catch (e) {
  ///   print('Error: $e');
  /// }
  /// ```
  /// This example attempts to drop the mind named 'example_mind'.
  Future<void> drop(String name) async {
    await api.delete('/projects/$project/minds/$name');
  }

  /// Checks and retrieves the name of a given datasource.
  ///
  /// This function verifies the type of the provided datasource. If the
  /// datasource is of type [Datasource], it returns its name. If it is
  /// of type [DatabaseConfig], it checks if the datasource exists; if not,
  /// it creates it before returning the name. If the datasource is provided
  /// as a string, it simply returns that string. If the type is unknown,
  /// an [ValueError] is thrown.
  ///
  /// #### Parameters:
  /// - **`ds`**: [dynamic]
  ///   The datasource to be checked. It can be of type [Datasource],
  ///   [DatabaseConfig], or [String].
  ///
  /// #### Returns:
  /// - **`String`**
  ///   The name of the datasource.
  ///
  /// #### Throws:
  /// - [ValueError] if the type of the datasource is unknown.
  ///
  /// #### Example:
  /// ```dart
  /// String datasourceName = _checkDatasource(tempDatasource);
  /// print('Datasource name: $datasourceName');
  /// ```
  /// This example checks the given datasource and prints its name.
  String _checkDatasource(dynamic ds) {
    if (ds is Datasource) {
      return ds.name;
    } else if (ds is DatabaseConfig) {
      try {
        client.datasources.get(ds.name);
      } catch (e) {
        if (e is exc.ObjectNotFound) {
          client.datasources.create(ds);
        } else {
          rethrow;
        }
      }
      return ds.name;
    } else if (ds is String) {
      return ds;
    } else {
      throw exc.ValueError('Unknown type of datasource: $ds');
    }
  }
}
