import 'package:mdb_dart/mdb_dart.dart';

/// Represents a client for interacting with the MindsDB API.
///
/// The [Client] class is responsible for managing connections to the
/// MindsDB API, providing access to various functionalities such as
/// managing datasources and minds.
///
/// #### Properties:
/// - **`api`**: [RestAPI]]
///   An instance of the [RestAPI] class for making API calls.
/// - **`datasources`**: [Datasources]
///   An instance of the [Datasources] class for managing datasources.
/// - **`minds`**: [Minds]
///   An instance of the [Minds] class for interacting with minds.
///
/// #### Constructor:
/// - **`Client(String apiKey, {String? baseURL = "https://mdb.ai"})`**
///   Creates a new [Client] instance with the specified API key and optional base URL.
///
///   - **Parameters:**
///     - **`apiKey`**: [String]
///       The API key for authenticating with the MindsDB API.
///     - **`baseURL`**: [String] (optional)
///       An optional base URL for the MindsDB API. Defaults to "https://mdb.ai".
///
/// #### Example:
/// ```dart
/// final client = Client('your_api_key_here');
/// // Now you can use client.datasources and client.minds to interact with the API.
/// ```
class Client {
  late final RestAPI api;
  late final Datasources datasources;
  late final Minds minds;

  Client(String apiKey, {String? baseURL = "https://mdb.ai"}) {
    api = RestAPI(apiKey, baseURL!);
    datasources = Datasources(this);
    minds = Minds(this);
  }
}
