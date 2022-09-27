class UserCrudRequest {
  String? name;
  String? job;

  UserCrudRequest({this.name, this.job});

  UserCrudRequest.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    job = json['job'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['job'] = job;
    return data;
  }
}
