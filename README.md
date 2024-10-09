<h1 align="center">🎯 Minds Dart 🎯</h1>
<br />
<p align="center">
    <img alt="hero" width="450" src="https://cdn.prod.website-files.com/62a8755be8bcc86e6307def8/634aea01a7ad04c1c66b19c2_Mindsdb-Core%20logo%20white.png" />
</p>
<br /><br />
<p align="center">
<a href="https://pub.dev/packages/mdb_dart">
<img alt="pub verion" src="https://img.shields.io/pub/v/mdb_dart.svg">
</a>
    <a href="https://pub.dev/packages/mdb_dart">
<img alt="repo size" src="https://img.shields.io/github/repo-size/ArnavK-09/mdb_dart?color=green">
        </a>    <a href="https://github.com/ArnavK-09/mdb_dart/releases">
<img alt="repo release" src="https://img.shields.io/github/v/release/ArnavK-09/mdb_dart">   </a> 
      <a href="https://github.com/ArnavK-09/mdb_dart/actions/workflows/tests.yaml">
<img alt="Tests" src="https://github.com/ArnavK-09/mdb_dart/actions/workflows/tests.yaml/badge.svg"> </a> 
          <a href="https://github.com/ArnavK-09/mdb_dart/blob/main/LICENSE">
<img alt="license" src="https://img.shields.io/badge/License-Mozilla%20Public%20License%202.0-orange.svg"> </a> 
</p>

> [!NOTE]
>
> A powerful and intuitive **Dart SDK** for interacting with the **MindsDB API**. Seamlessly integrate machine learning capabilities into your Dart applications!

## 📚 Table of Contents

- [🚀 Features](#-features)
- [🎪 Installation](#-installation)
- [🏁 Getting Started](#-getting-started)
- [📘 API Reference](#-api-reference)
  - [Client](#client)
  - [Datasources](#datasources)
  - [Minds](#minds)
  - [Mind](#mind)
  - [Exceptions](#exceptions)
- [🌟 Usage Examples](#-usage-examples)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)

---

## 🚀 Features

- **🔐 Secure API Authentication**  
  Safeguard your application with cutting-edge authentication methods that ensure your connection to the MindsDB API remains protected and confidential. Experience peace of mind while accessing advanced AI functionalities.

- **📊 Intuitive Data Source Management**  
  Easily manage and configure your data sources with sdk. Add, modify, or remove data connections effortlessly, allowing your AI models to access the most relevant and up-to-date information.

- **🧠 Tailored AI Model Creation (MindsDB AI)**  
  Design bespoke AI models that suit your specific requirements. With our platform, you can create, customize, and optimize Minds that deliver personalized responses, making your applications smarter and more intuitive.

- **🔄 Effortless MindsDB API Integration**  
  Experience a hassle-free integration with the MindsDB API, enabling you to tap into the full spectrum of AI capabilities quickly. Connect your systems and workflows seamlessly, enhancing your application’s functionality.

- **📡 Real-time Interaction Capabilities**  
  Engage your users in real-time with interactive responses! Our real-time streaming support enables you to build applications that deliver immediate feedback, making conversations more dynamic and engaging.

- **📦 Modular Architecture**  
  Benefit from a flexible, modular architecture that allows you to extend and customize the functionality of your application easily. Add new features and capabilities as your project evolves, ensuring long-term adaptability.

## 🎪 Installation

> Add **[`mdb_dart`](https://pub.dev/packages/mdb_dart)** to your project!

###### bash

```bash
dart pub add mdb_dart
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

### [Client](https://github.com/ArnavK-09/mdb_dart/blob/main/lib/src/client.dart#L32)

| Method/Property                                                                                      | Description                   |
| ---------------------------------------------------------------------------------------------------- | ----------------------------- |
| [`RestAPI api`](https://github.com/ArnavK-09/mdb_dart/blob/main/lib/src/client.dart#L38)             | Instance for making API calls |
| [`Datasources datasources`](https://github.com/ArnavK-09/mdb_dart/blob/main/lib/src/client.dart#L39) | Manages data sources          |
| [`Minds minds`](https://github.com/ArnavK-09/mdb_dart/blob/main/lib/src/client.dart#L40)             | Manages minds (AI models)     |

### [Datasources](https://github.com/ArnavK-09/mdb_dart/blob/main/lib/src/datasources.dart#L65)

| Method/Property                                                                                                                                    | Description                          |
| -------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------ |
| [`list()`](https://github.com/ArnavK-09/mdb_dart/blob/main/lib/src/datasources.dart#L154)                                                          | List all datasources                 |
| [`get(String name)`](https://github.com/ArnavK-09/mdb_dart/blob/main/lib/src/datasources.dart#L198)                                                | Get a specific datasource            |
| [`create(DatabaseConfig dsConfig, {bool replace = false})`](https://github.com/ArnavK-09/mdb_dart/blob/main/lib/src/datasources.dart#L118)         | Create a new datasource              |
| [`drop(String name)`](https://github.com/ArnavK-09/mdb_dart/blob/main/lib/src/datasources.dart#L239)                                               | Delete a datasource                  |
| [`DatabaseConfig(name, engine, description, connectionData, tables)`](https://github.com/ArnavK-09/mdb_dart/blob/main/lib/src/datasources.dart#L9) | Configuration details for a database |

### [Minds](https://github.com/ArnavK-09/mdb_dart/blob/main/lib/src/minds.dart#L377)

| Method/Property                                                                                                                                               | Description                    |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------ |
| [`list()`](https://github.com/ArnavK-09/mdb_dart/blob/main/lib/src/minds.dart#L404)                                                                           | List all minds (AI models)     |
| [`get(String name)`](https://github.com/ArnavK-09/mdb_dart/blob/main/lib/src/minds.dart#L437)                                                                 | Get a specific mind (AI model) |
| [`create({required String name, modelName, provider, promptTemplate, datasources})`](https://github.com/ArnavK-09/mdb_dart/blob/main/lib/src/minds.dart#L488) | Create a new mind              |
| [`drop(String name)`](https://github.com/ArnavK-09/mdb_dart/blob/main/lib/src/minds.dart#L552)                                                                | Delete a mind                  |

Certainly! Here's how you can structure the API reference table for the `Mind` class in your README:

### [Mind](https://github.com/ArnavK-09/mdb_dart/blob/main/lib/src/minds.dart#L37)

| Method/Property                                                                                                                                                   | Description                                                               |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------- |
| [`update({String? name, modelName, provider, promptTemplate, datasources, parameters})`](https://github.com/ArnavK-09/mdb_dart/blob/main/lib/src/minds.dart#L101) | Updates the properties of the mind.                                       |
| [`addDatasource(dynamic datasource)`](https://github.com/ArnavK-09/mdb_dart/blob/main/lib/src/minds.dart#L161)                                                    | Adds a new datasource to the mind.                                        |
| [`delDatasource(dynamic datasource)`](https://github.com/ArnavK-09/mdb_dart/blob/main/lib/src/minds.dart#L195)                                                    | Deletes a specific datasource from the mind.                              |
| [`completion(String message)`](https://github.com/ArnavK-09/mdb_dart/blob/main/lib/src/minds.dart#L238)                                                           | Sends a chat message to the Mind API and retrieves a completion response. |
| [`streamCompletion(String message)`](https://github.com/ArnavK-09/mdb_dart/blob/main/lib/src/minds.dart#L286)                                                     | Streams chat completions from the Mind API based on a user's message.     |
| [`fromJson(Client client, Map<String, dynamic> json)`](https://github.com/ArnavK-09/mdb_dart/blob/main/lib/src/minds.dart#L353)                                   | Creates a new instance of Mind from a JSON map.                           |

### Exceptions

| Exception                                                                                                                                         | Description                                                 |
| ------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------- |
| [`ObjectNotFound([String message = 'Object not found.'])`](https://github.com/ArnavK-09/mdb_dart/blob/main/lib/src/exceptions.dart#L4)            | Thrown when a requested object cannot be found.             |
| [`ObjectAlreadyExists([String message = 'Object already exists.'])`](https://github.com/ArnavK-09/mdb_dart/blob/main/lib/src/exceptions.dart#L15) | Thrown when trying to create an object that already exists. |
| [`ObjectNotSupported([String message = 'Object not supported.'])`](https://github.com/ArnavK-09/mdb_dart/blob/main/lib/src/exceptions.dart#L26)   | Thrown when an unsupported operation is attempted.          |
| [`Forbidden([String message = 'Access forbidden.'])`](https://github.com/ArnavK-09/mdb_dart/blob/main/lib/src/exceptions.dart#L37)                | Thrown when access is forbidden.                            |
| [`Unauthorized([String message = 'Unauthorized access.'])`](https://github.com/ArnavK-09/mdb_dart/blob/main/lib/src/exceptions.dart#L48)          | Thrown when access is unauthorized.                         |
| [`UnknownError([String message = 'An unknown error occurred.'])`](https://github.com/ArnavK-09/mdb_dart/blob/main/lib/src/exceptions.dart#L59)    | Thrown for unspecified errors.                              |
| [`ValueError(String message)`](https://github.com/ArnavK-09/mdb_dart/blob/main/lib/src/exceptions.dart#L70)                                       | Thrown when a value is invalid or out of range.             |

---

## 🌟 Usage Examples

### 💿 Managing `Datasources`

> #### List Datasources

```dart
List<Datasource> datasources = await client.datasources.list();
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
Datasource datasource = await client.datasources.get('my_postgres_db');
print('Datasource engine: ${datasource.engine}');
```

> #### Delete a Datasource

```dart
await client.datasources.drop('my_postgres_db');
print('Datasource deleted successfully');
```

### 🧠 Managing `Minds`

> #### List Minds

```dart
List<Mind> minds = await client.minds.list();
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
Mind mind = await client.minds.get('my_predictor');
print('Mind model: ${mind.modelName}');
```

> #### Delete a Mind

```dart
await client.minds.drop('my_predictor');
print('Mind deleted successfully');
```

> #### Using a Mind for Predictions

```dart
Mind mind = await client.minds.get('my_predictor');
final completion = await mind.completion('What will be the stock price tomorrow?');
print('Prediction: ${completion.choices.first.message.content?.first.text}');
```

> #### Streaming Completions

```dart
Mind mind = await client.minds.get('my_predictor');
final stream = await mind.streamCompletion('Explain quantum computing');
await for (var chunk in stream) {
  print('Chunk: ${chunk.choices.first.delta.content?.first?.text}');
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

---

> [!WARNING]
>
> _This repository is heavily influenced by the [minds_python_sdk](https://github.com/mindsdb/minds_python_sdk) and mirrors its structure and functionality._
