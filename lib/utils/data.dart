class Data<T> {
  final bool isInitial;
  final bool isLoading;
  final T? data;
  final bool isError;
  final String? errorMessage;

  Data({
    this.isInitial = true,
    this.isLoading = false,
    this.data,
    this.isError = false,
    this.errorMessage,
  });
}
