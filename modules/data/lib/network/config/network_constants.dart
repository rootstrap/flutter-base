class NetworkConstants {
  static const connectTimeout = 2;
  static const receiveTimeout = 2;
  static const baseUrl = String.fromEnvironment('API_URL', defaultValue: "https://dummyjson.com");
  static const productsPath = "/products";
}
