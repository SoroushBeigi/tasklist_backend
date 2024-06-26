import 'dart:io';
import 'dart:math';

import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  return switch (context.request.method) {
    HttpMethod.patch => _updateList(context, id),
    HttpMethod.delete => _deleteList(context, id),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _updateList(RequestContext context, String id) async {
  final body = await context.request.json() as Map<String, dynamic>;
  final name = body['name'] as String?;
  if (name != null) {
    try {
      final result = await context
          .read<Connection>()
          .execute("UPDATE list SET name = '$name' WHERE id = '$id'");
      if (result.affectedRows == 1) {
        return Response.json(body: 'Successfully updated to $name');
      } else {
        return Response.json(body: 'Updating failed');
      }
    } catch (e) {
      return Response(statusCode: HttpStatus.connectionClosedWithoutResponse);
    }
  }
  return Response(statusCode: HttpStatus.badRequest);
}

Future<Response> _deleteList(RequestContext context, String id) async {
  await context
      .read<Connection>()
      .execute("DELETE FROM list WHERE id =  '$id '")
      .then(
    (value) {
      return Response(statusCode: HttpStatus.noContent);
    },
    onError: (e) {
      return Response(statusCode: HttpStatus.badRequest);
    },
  );
  return Response(statusCode: HttpStatus.badRequest);
}
