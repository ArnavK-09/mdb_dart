import 'package:dartenv/dartenv.dart';
import 'package:mdb_dart/mdb_dart.dart';

// Fetching API Key
final apiKey = env("API_KEY");

// Example
void main(List<String> arguments) async {
  Client client = Client(apiKey);
  print(client);
  // @ TODO
}
