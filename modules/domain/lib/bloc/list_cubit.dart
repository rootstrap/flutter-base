import 'package:domain/bloc/base_cubit.dart';

class ListBlocState<T> extends BaseCubit<List<T>> {
  ListBlocState(super.initialState);

  List<T> get items => state.data ?? [];

  void addItem(T item) {
    final currentList = List<T>.from(state.data ?? []);
    currentList.add(item);
    isSuccess(currentList);
  }

  void removeItem(T item) {
    final currentList = List<T>.from(state.data ?? []);
    currentList.remove(item);
    isSuccess(currentList);
  }

  void clearList() => isSuccess([]);

  void setList(List<T> items) => isSuccess(items);
}
