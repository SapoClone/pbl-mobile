enum LoadingStatus {
  initial,
  loading,
  done,
  error;

  bool get isLoading => this == LoadingStatus.loading;

  bool get isInitial => this == LoadingStatus.initial;

  bool get isDone => this == LoadingStatus.done;

  bool get isError => this == LoadingStatus.error;
}
