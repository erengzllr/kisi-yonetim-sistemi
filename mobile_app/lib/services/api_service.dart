import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/person.dart';

class ApiService {
  // Varsayılan Android emülatör adresi. Gerçek cihazda dart-define ile değiştirin.
  static const String _baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000/api',
  );

  static const Map<String, String> _headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
  };

  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  // GET /api/persons/
  Future<List<Person>> fetchPersons() async {
    final uri = Uri.parse('$_baseUrl/persons/');
    try {
      final response = await _client.get(uri, headers: _headers);
      _checkStatus(response, 'fetchPersons');
      final list = jsonDecode(response.body) as List<dynamic>;
      return list
          .map((e) => Person.fromJson(e as Map<String, dynamic>))
          .toList();
    } on ApiException {
      rethrow;
    } catch (e, st) {
      throw ApiException(message: 'Kişi listesi alınamadı: $e', stackTrace: st);
    }
  }

  // GET /api/persons/{id}/
  Future<Person> fetchPersonDetail(int id) async {
    final uri = Uri.parse('$_baseUrl/persons/$id/');
    try {
      final response = await _client.get(uri, headers: _headers);
      _checkStatus(response, 'fetchPersonDetail($id)');
      return Person.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e, st) {
      throw ApiException(
        message: 'Kişi detayı alınamadı (id=$id): $e',
        stackTrace: st,
      );
    }
  }

  // POST /api/persons/
  Future<Person> createPerson(Person person) async {
    final uri = Uri.parse('$_baseUrl/persons/');
    try {
      final response = await _client.post(
        uri,
        headers: _headers,
        body: jsonEncode(person.toJson()),
      );
      _checkStatus(response, 'createPerson', expected: 201);
      return Person.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e, st) {
      throw ApiException(message: 'Kişi oluşturulamadı: $e', stackTrace: st);
    }
  }

  // PUT /api/persons/{id}/
  Future<Person> updatePerson(Person person) async {
    if (person.id == null) {
      throw ArgumentError('updatePerson: person.id null olamaz.');
    }
    final uri = Uri.parse('$_baseUrl/persons/${person.id}/');
    try {
      final response = await _client.put(
        uri,
        headers: _headers,
        body: jsonEncode(person.toJson()),
      );
      _checkStatus(response, 'updatePerson(${person.id})');
      return Person.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e, st) {
      throw ApiException(
        message: 'Kişi güncellenemedi (id=${person.id}): $e',
        stackTrace: st,
      );
    }
  }

  // DELETE /api/persons/{id}/
  Future<void> deletePerson(int id) async {
    final uri = Uri.parse('$_baseUrl/persons/$id/');
    try {
      final response = await _client.delete(uri, headers: _headers);
      _checkStatus(response, 'deletePerson($id)', expected: 204);
    } on ApiException {
      rethrow;
    } catch (e, st) {
      throw ApiException(
        message: 'Kişi silinemedi (id=$id): $e',
        stackTrace: st,
      );
    }
  }

  void _checkStatus(http.Response r, String op, {int? expected}) {
    final ok = expected != null
        ? r.statusCode == expected
        : r.statusCode >= 200 && r.statusCode < 300;
    if (!ok) {
      throw ApiException(
        message: '[$op] HTTP ${r.statusCode}: ${r.body}',
        statusCode: r.statusCode,
      );
    }
  }

  void dispose() => _client.close();
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final StackTrace? stackTrace;

  const ApiException({required this.message, this.statusCode, this.stackTrace});

  @override
  String toString() {
    final code = statusCode != null ? ' [HTTP $statusCode]' : '';
    return 'ApiException$code: $message';
  }
}
