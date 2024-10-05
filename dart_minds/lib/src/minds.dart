import 'dart:convert';
import 'dart:async';
import 'package:dart_minds/src/rest_api.dart';
import 'package:dart_openai/dart_openai.dart';
import 'exceptions.dart' as exc;
import 'package:dart_minds/src/datasources.dart';
import 'package:dart_minds/src/client.dart';

const String defaultPromptTemplate =
    "Use your database tools to answer the user's question: {{question}}";

class Mind {
  final RestAPI api;
  final Client client;
  final String project = 'mindsdb';

  String name;
  final String? modelName;
  final String? provider;
  final Map<String, dynamic> parameters;
  final String? promptTemplate;
  final String? createdAt;
  final String? updatedAt;
  List<dynamic>? datasources;

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

  Future<void> update({
    String? name,
    String? modelName,
    String? provider,
    String? newPromptTemplate,
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

    if (newPromptTemplate != null) {
      data['parameters']['prompt_template'] = newPromptTemplate;
    }

    await api.patch(
      '/projects/$project/minds/$name',
      data,
    );

    if (name != null && name != this.name) {
      this.name = name;
    }
  }

  Future<void> addDatasource(DatabaseConfig datasource) async {
    final dsName = client.minds._checkDatasource(datasource);
    await api
        .post('/projects/$project/minds/$name/datasources', {'name': dsName});

    final updated = await client.minds.get(name);
    datasources = updated.datasources;
  }

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

  Stream<dynamic> streamResponse(
      Stream<OpenAIStreamCompletionModel> response) async* {
    await for (var chunk in response) {
      yield chunk.choices.first.text;
    }
  }

  factory Mind.fromJson(Client client, Map<String, dynamic> json) {
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

class Minds {
  final Client client;
  final String project = 'mindsdb';
  final RestAPI api;

  Minds(
    this.client,
  ) : api = client.api;

  Future<List<Mind>> list() async {
    final response = await api.get('/projects/$project/minds');

    // Assuming response has a method to convert to JSON
    final List<dynamic> data =
        jsonDecode(response.body); // Replace with actual response handling
    List<Mind> mindsList = [];

    for (var item in data) {
      mindsList.add(Mind(
        client: client,
        name: item['name'], // Adjust based on your data structure
        modelName: item['model_name'],
        provider: item['provider'],
        parameters: item['parameters'] ?? {},
        datasources: item['datasources'],
        createdAt: item['created_at'] ?? '',
        updatedAt: item['updated_at'] ?? '',
      ));
    }

    return mindsList;
  }

  Future<Mind> get(String name) async {
    final response = await api.get('/projects/$project/minds/$name');

    final Map<String, dynamic> data = jsonDecode(response.body);

    return Mind.fromJson(client, data);
  }

  Future<Mind> create({
    required String name,
    String? modelName,
    String? provider,
    String? promptTemplate,
    List<DatabaseConfig>? datasources,
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

  Future<void> drop(String name) async {
    await api.delete('/projects/$project/minds/$name');
  }

  String _checkDatasource(dynamic ds) {
    if (ds is Datasource) {
      return ds.name;
    } else if (ds is DatabaseConfig) {
      try {
        client.datasources.get(ds.name);
      } catch (e) {
        client.datasources.create(ds);
      }
      return ds.name;
    } else if (ds is String) {
      return ds;
    } else {
      throw exc.ValueError('Unknown type of datasource: $ds');
    }
  }
}
