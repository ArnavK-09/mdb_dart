import 'package:dart_minds/dart_minds.dart';

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
