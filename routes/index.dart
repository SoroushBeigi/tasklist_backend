import 'package:dart_frog/dart_frog.dart';

//curl --request GET --url http://localhost:8080
Response onRequest(RequestContext context) {
  return Response(body: 'Welcome!');
}
