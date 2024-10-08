<h1 align="center">🎯 Minds Dart 🎯</h1>
<br />
<p align="center">
    <img alt="hero" width="450" src="https://cdn.prod.website-files.com/62a8755be8bcc86e6307def8/634aea01a7ad04c1c66b19c2_Mindsdb-Core%20logo%20white.png" />
</p>
<br /><br />
<p align="center">
<img alt="pub verion" src="https://img.shields.io/pub/v/mdb_dart.svg">
<img alt="Tests" src="https://github.com/ArnavK-09/mdb_dart/actions/workflows/tests.yaml/badge.svg">
<img alt="license" src="https://img.shields.io/badge/License-Mozilla%20Public%20License%202.0-yellow.svg">

</p>

> [!NOTE]
>
> A powerful and intuitive **Dart SDK** for interacting with the **MindsDB API**. Seamlessly integrate machine learning capabilities into your Dart applications!

## 📚 Table of Contents

- [🚀 Features](#-features)
- [🛠️ Installation](#️-installation)
- [🏁 Getting Started](#-getting-started)
- [📘 API Reference](#-api-reference)
  - [Client](#client)
  - [Datasources](#datasources)
  - [Minds](#minds)
- [🌟 Usage Examples](#-usage-examples)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)

---

## 🚀 Features

- 🔐 Secure API authentication
- 📊 Manage data sources with ease
- 🧠 Create and control AI models (Minds)
- 🔄 Seamless integration with MindsDB API
- 🛡️ Robust error handling
- 📡 Real-time streaming support

## 🛠️ Installation

> Add `mdb_dart` to your `pubspec.yaml` file:

###### pubspec.yaml
```yaml
dependencies:
  mdb_dart: ^0.0.1
```

> Then run:

###### bash
```bash
dart pub get
```

## 🏁 Getting Started

Import the library and create a client:

```dart
import 'package:mdb_dart/mdb_dart.dart';

void main() async {
  final client = Client('YOUR_API_KEY');
  // Now you're ready to use the SDK!
}
```

---

## 📘 API Reference 

### Client 
| Method | Description | 
|--------|-------------| 
| [`Client(String apiKey, {String? baseURL})`](https://github.com/ArnavK-09/mdb_dart/blob/main/lib/src/client.dart#L8) | Creates a new client instance | 

### Datasources 
| Method | Description | 
|--------|-------------| 
| [`list()`](https://github.com/ArnavK-09/mdb_dart/blob/main/lib/src/datasources.dart#L15) | List all datasources | 
| [`get(String name)`](https://github.com/ArnavK-09/mdb_dart/blob/main/lib/src/datasources.dart#L26) | Get a specific datasource | 
| [`create(DatabaseConfig dsConfig, {bool replace = false})`](https://github.com/ArnavK-09/mdb_dart/blob/main/lib/src/datasources.dart#L38) | Create a new datasource | 
| [`drop(String name)`](https://github.com/ArnavK-09/mdb_dart/blob/main/lib/src/datasources.dart#L50) | Delete a datasource | 

### Minds 
| Method | Description | 
|--------|-------------| 
| [`list()`](https://github.com/ArnavK-09/mdb_dart/blob/main/lib/src/minds.dart#L15) | List all minds | 
| [`get(String name)`](https://github.com/ArnavK-09/mdb_dart/blob/main/lib/src/minds.dart#L26) | Get a specific mind | 
| [`create({required String name, ...})`](https://github.com/ArnavK-09/mdb_dart/blob/main/lib/src/minds.dart#L38) | Create a new mind | 
| [`drop(String name)`](https://github.com/ArnavK-09/mdb_dart/blob/main/lib/src/minds.dart#L50) | Delete a mind | 

## 🌟 Usage Examples

### 💿 Managing ` Datasources `

> #### List Datasources

```dart
final datasources = await client.datasources.list();
for (var ds in datasources) {
  print('Datasource: ${ds.name}');
}
```

> #### Create a Datasource

```dart
final newDatasource = await client.datasources.create(
  DatabaseConfig(
    name: 'my_postgres_db',
    engine: 'postgres',
    description: 'My PostgreSQL Database',
    connectionData: {
      'host': 'localhost',
      'port': 5432,
      'user': 'username',
      'password': 'password',
      'database': 'mydb',
    },
  )
);
print('Created datasource: ${newDatasource.name}');
```

> #### Get a Datasource

```dart
final datasource = await client.datasources.get('my_postgres_db');
print('Datasource engine: ${datasource.engine}');
```

> #### Delete a Datasource

```dart
await client.datasources.drop('my_postgres_db');
print('Datasource deleted successfully');
```

### 🧠 Managing ` Minds `

> #### List Minds

```dart
final minds = await client.minds.list();
for (var mind in minds) {
  print('Mind: ${mind.name}');
}
```

> #### Create a Mind

```dart
final newMind = await client.minds.create(
  name: 'my_predictor',
  modelName: 'gpt-4o',
  provider: 'openai',
  promptTemplate: 'Predict the next value: {{input}}',
  datasources: ['my_postgres_db'],
);
print('Created mind: ${newMind.name}');
```

> #### Get a Mind

```dart
final mind = await client.minds.get('my_predictor');
print('Mind model: ${mind.modelName}');
```

> #### Delete a Mind

```dart
await client.minds.drop('my_predictor');
print('Mind deleted successfully');
```

> #### Using a Mind for Predictions

```dart
final mind = await client.minds.get('my_predictor');
final completion = await mind.completion('What will be the stock price tomorrow?');
print('Prediction: ${completion.choices.first.message.content}');
```

> #### Streaming Completions

```dart
final mind = await client.minds.get('my_predictor');
final stream = await mind.streamCompletion('Explain quantum computing');
await for (var chunk in stream) {
  print('Chunk: ${chunk.choices.first.delta.content}');
}
```

---

<h2 align="center">📹 Contributing</h2>

<p align="center">
<strong>
We welcome contributions to improve and expand the MindsDB Dart SDK!
To get started with contributing, please follow the guidelines outlined in our <a href="CONTRIBUTING.md"><strong>CONTRIBUTING</strong></a> file.
</strong>
</p>

<h2 align="center">📄 License</h2>

<p align="center">
This project is licensed under the <code> Mozilla Public License 2.0 </code> - see the <a href="LICENSE">LICENSE</a> file for details.
</p>

---

<p align="center">
    <strong>If you find this project helpful, please give it a ⭐ on GitHub!</strong>
</p>