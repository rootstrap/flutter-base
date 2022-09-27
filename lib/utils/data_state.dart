class Data<T> {
  final bool isLoading;
  final T? data;
  final bool isError;
  final String? errorMessage;

  Data({
    this.isLoading = false,
    this.data,
    this.isError = false,
    this.errorMessage,
  });
}
