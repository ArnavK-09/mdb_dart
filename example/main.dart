// Import mdb_dart
import 'package:mdb_dart/mdb_dart.dart';

// Fetching API Key
final apiKey = "YOUR_API_KEY";

// Example
void main() async {
  // Initializing Client
  Client client = Client(apiKey);

  // Managing Datasources
  print('--- Managing Datasources ---');

  // Create a new Datasource
  final newDatasource = await client.datasources
      .create(demoDatasourceConfigForTesting, replace: true);
  print('Created Datasource: ${newDatasource.name}');

  // List Datasources
  List<Datasource> datasources = await client.datasources.list();
  print('Current Datasources:');
  for (var ds in datasources) {
    print('Datasource: ${ds.name}');
  }

  // Get a specific Datasource
  Datasource datasource =
      await client.datasources.get(demoDatasourceConfigForTesting.name);
  print('Datasource Description: ${datasource.description}');

  // Delete a Datasource
  await client.datasources.drop(datasource.name);
  print('Datasource deleted successfully');

  // Managing Minds
  print('--- Managing Minds ---');

  // Create a new Mind
  final newMind = await client.minds.create(
      name: 'my_predictor',
      modelName: 'gpt-4o',
      provider: 'openai',
      datasources: [demoDatasourceConfigForTesting],
      replace: true);
  print('Created Mind: ${newMind.name}');

  // Get a specific Mind
  Mind mind = await client.minds.get('my_predictor');
  print('Mind model: ${mind.modelName}');

  // Use the Mind for Predictions
  final completion = await mind.completion('List datasource description');
  print('Prediction: ${completion.choices.first.message.content?.first.text}');

  // Streaming Completions
  final stream = await mind.streamCompletion('Whats datasource size');
  print('Streaming Completions:');
  await for (var chunk in stream) {
    print('Chunk: ${chunk.choices.first.delta.content?.first?.text}');
  }

  // Delete a Mind
  await client.minds.drop('my_predictor');
  print('Mind deleted successfully');
}
