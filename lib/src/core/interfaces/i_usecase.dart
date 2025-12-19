abstract class IUseCaseQuery<T, P> {
  Future<T> call(P params);
}

abstract class IUseCaseCommand<T> {
  Future<T> call();
}
