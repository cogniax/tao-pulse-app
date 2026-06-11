import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:taopulse/api/api_client.dart';

void main() {
  group('ApiClient', () {
    test('defaults to localhost on non-Android native platforms', () {
      final client = ApiClient();

      expect(client.baseUrl, 'http://127.0.0.1:5000');
    });

    test('uses explicit baseUrl override', () {
      final client = ApiClient(baseUrl: 'http://127.0.0.1:8787');

      expect(client.baseUrl, 'http://127.0.0.1:8787');
    });

    test('authenticates and fetches feed from a local backend', () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      addTearDown(server.close);

      server.listen((request) async {
        final path = request.uri.path;

        if (request.method == 'POST' && path == '/api/v1/auth/login') {
          request.response
            ..statusCode = HttpStatus.ok
            ..headers.contentType = ContentType.json
            ..write(
              jsonEncode({
                'data': {'token': 'local-test-token'},
              }),
            );
          await request.response.close();
          return;
        }

        if (request.method == 'GET' && path == '/api/v1/feed') {
          expect(
            request.headers.value(HttpHeaders.authorizationHeader),
            'Bearer local-test-token',
          );

          request.response
            ..statusCode = HttpStatus.ok
            ..headers.contentType = ContentType.json
            ..write(
              jsonEncode({
                'data': {
                  'items': [
                    {'id': 'feed-1', 'title': 'Local feed item'},
                  ],
                },
              }),
            );
          await request.response.close();
          return;
        }

        request.response
          ..statusCode = HttpStatus.notFound
          ..headers.contentType = ContentType.json
          ..write(jsonEncode({'data': {}}));
        await request.response.close();
      });

      final client = ApiClient(baseUrl: 'http://127.0.0.1:${server.port}');
      final response = await client.get('/api/v1/feed');

      expect(response['items'], isA<List<dynamic>>());
      expect((response['items'] as List<dynamic>).single['id'], 'feed-1');
    });
  });
}
