class NetworkConstants {
  static const connectTimeout = 2;
  static const receiveTimeout = 2;
  //static const baseUrl =  String.fromEnvironment('API_URL', defaultValue: "NA");
  static const productsPath = "/products";
  static const baseUrl =  "http://www.example.com"; // To get started: comment this and uncomment line 4
  static const tokenHeader = "token";
  static const unauthorizedStatusCode = 401;
  static const forbiddenStatusCode = 403;
  static const invalidStatusCode = 422;
  static const contentTypeHeader = "Content-Type";
  static const applicationJsonContentType = "application/json";
}
