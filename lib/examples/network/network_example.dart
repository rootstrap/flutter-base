import 'package:flutter_base_rootstrap/data/data_sources/network/http_client.dart';
import 'package:flutter_base_rootstrap/examples/network/model/user.dart';
import 'package:flutter_base_rootstrap/examples/network/model/user_crud_request.dart';
import 'package:flutter_base_rootstrap/examples/network/model/user_crud_response.dart';

/// This example was maded using reqres.in to generate a CRUD of users.
/// Using as base url: https://reqres.in/api and providing all the operations
/// making use of HttpClient class on base project.

class NetworkExample {
  final String baseUrl = "https://reqres.in/api";

  Future<User?> getUser({required String id}) async {
    HttpClient httpClient = HttpClient(baseUrl: baseUrl, path: '/users/$id');
    final userDataResponse = await httpClient.get();

    if (userDataResponse.isSuccess) {
      try {
        return User.fromJson(userDataResponse.data as Map<String, dynamic>);
      } catch (e) {
        rethrow;
      }
    }
    return null;
  }

  Future<UserCrudResponse?> createUser({
    required UserCrudRequest request,
  }) async {
    HttpClient httpClient = HttpClient(
        baseUrl: baseUrl, path: '/users', parameters: request.toJson());
    final userCreateResponse = await httpClient.post();
    if (userCreateResponse.isSuccess) {
      try {
        return UserCrudResponse.fromJson(
          userCreateResponse.data as Map<String, dynamic>,
        );
      } catch (e) {
        rethrow;
      }
    }

    return null;
  }

  Future<UserCrudResponse?> updateUser(
      {required UserCrudRequest request, required String id}) async {
    HttpClient httpClient = HttpClient(
      baseUrl: baseUrl,
      path: '/users/$id',
      parameters: request.toJson(),
    );
    final userCreateResponse = await httpClient.patch();
    if (userCreateResponse.isSuccess) {
      try {
        return UserCrudResponse.fromJson(
          userCreateResponse.data as Map<String, dynamic>,
        );
      } catch (e) {
        rethrow;
      }
    }

    return null;
  }

  Future<void> deleteUser({required String id}) async {
    HttpClient httpClient = HttpClient(baseUrl: baseUrl, path: '/users/$id');
    await httpClient.delete();
  }
}
