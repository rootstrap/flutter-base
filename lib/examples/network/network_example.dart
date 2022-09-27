import 'package:flutter_base_rootstrap/examples/network/model/user.dart';
import 'package:flutter_base_rootstrap/examples/network/model/user_crud_request.dart';
import 'package:flutter_base_rootstrap/examples/network/model/user_crud_response.dart';
import 'package:flutter_base_rootstrap/repository/data_source/remote/network/http_client.dart';

/// This example was maded using reqres.in to generate a CRUD of users.
/// Using as base url: https://reqres.in/api and providing all the operations
/// making use of HttpClient class on base project.

class NetworkExample {
  final String baseUrl = "https://reqres.in/api";

  Future<User> getUser({required String id}) async {
    HttpClient httpClient = HttpClient(baseUrl, path: '/users/$id');
    final userDataResponse = await httpClient.get();
    try {
      return User.fromJson(userDataResponse);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCrudResponse> createUser(
      {required UserCrudRequest request}) async {
    HttpClient httpClient =
        HttpClient(baseUrl, path: '/users', parameters: request.toJson());
    final userCreateResponse = await httpClient.post();
    try {
      return UserCrudResponse.fromJson(userCreateResponse);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCrudResponse> updateUser(
      {required UserCrudRequest request, required String id}) async {
    HttpClient httpClient =
        HttpClient(baseUrl, path: '/users/$id', parameters: request.toJson());
    final userCreateResponse = await httpClient.patch();
    try {
      return UserCrudResponse.fromJson(userCreateResponse);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUser({required String id}) async {
    HttpClient httpClient = HttpClient(baseUrl, path: '/users/$id');
    await httpClient.delete();
  }
}
