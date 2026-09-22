# Feature development guide

How to implement a typical feature (for example, "list products from the API and show details") using the
established patterns. The canonical reference is the **auth** feature. Mirror it.

## Flow

```
requirement
 → decide placement: existing layers (default) or a new module (see modules.md)
 → domain:  model(s) → repository interface → service → cubit + state
 → data:    DTO/parsing → repository impl (Dio / Preferences) → register in DataInit
 → domain:  register service + (global) cubit in DomainInit
 → app:     route (Routes enum + GoRoute) → page + widgets → BlocProvider/BlocBuilder → strings in .arb
 → tests:   cubit, repository, widget
```

## 1. Domain (`modules/domain/lib/`)

- **Model**: `models/<name>.dart`. It's an immutable class or enum, with no JSON. (`User`, `AppLang` are examples.)
- **Repository interface**: `repositories/<name>_repository.dart`, where each method returns `Future<ResultType<T>>`.
  ```dart
  abstract class ProductRepository {
    Future<ResultType<List<Product>>> getProducts();
  }
  ```
- **Service**: `services/<name>_service.dart`. It orchestrates one or more repositories. It's thin today
  (`AuthService` just forwards), so put cross-repository and business rules here, not in cubits.
- **Cubit + state**: `bloc/<feature>/<feature>_cubit.dart` and `_state.dart`.
  - For async load/submit screens, extend `BaseCubit<T>` so the state is `Resource<T>`:
    ```dart
    class ProductsCubit extends BaseCubit<List<Product>> {
      final ProductService _service;
      ProductsCubit(this._service) : super(RSuccess(data: const []));
      Future<void> load() async {
        isLoading();
        onResult(await _service.getProducts());
      }
    }
    ```
  - For lists with local add/remove, extend `ListBlocState<T>`.
  - Mix in `CancelableCubitMixin` and wrap futures with `toCancelable(...)` when a request may outlive the screen.
  - For multi-variant state (like `AuthState`), use a sealed class and emit it as the `T` of `Resource<T>`.
  - Don't chain `mapSuccess`/`mapError` for side effects (known-issues #1).

## 2. Data (`modules/data/lib/`)

- **Remote calls**: inject the registered `Dio` (`getIt<Dio>()`) into the repository or a data source under
  `data_sources/remote/`. Add path constants to `network/config/network_constants.dart`.
- **Parsing**: there's no codegen. Write `fromJson` by hand in a data-layer class and map it to the domain model
  before returning. Domain models must not know JSON.
- **Errors**: wrap calls so every failure becomes a `Failure`:
  ```dart
  try {
    final res = await _dio.get(NetworkConstants.productsPath);
    return TSuccess((res.data['products'] as List).map(ProductDto.fromJson).map((d) => d.toModel()).toList());
  } on DioException catch (e) {
    return TError(e.toFailure());
  }
  ```
- **Local data**: extend the `Preferences` interface and impl for small key/value data. Anything larger needs a
  decision (no DB is set up).
- **Register**: `getIt.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(getIt()));` in `DataInit`.

## 3. Register domain objects (`modules/domain/lib/init.dart`)

- Services: `getIt.registerLazySingleton(() => ProductService(getIt()));`
- A cubit is registered **only if it's global** (it lives for the whole app, like `AppCubit`/`AuthCubit`). Screen cubits
  aren't registered. They're created in the page's `BlocProvider`.

## 4. Presentation (`app/lib/presentation/`)

- **Route**: add a value to the `Routes` enum and a `GoRoute` under the right `ShellRoute` in `navigation/routers.dart`.
  Authenticated screens go under `/app`, and public ones go under the first shell. Use `subPath` for nested routes.
- **Page**: `ui/pages/<area>/<feature>/<feature>_page.dart`. It provides the cubit, and a sibling `_view`/`_form` widget renders it:
  ```dart
  BlocProvider(create: (_) => ProductsCubit(getIt())..load(), child: const ProductsView())
  ```
- **Render state**: `BlocBuilder<ProductsCubit, Resource<List<Product>>>` and branch on `RLoading` / `RError` / `RSuccess`.
  Use `FailureWidget(failure: state.exception as Failure?, onRetry: …)` for errors, `PrimaryButton(isLoading: …)` for
  submits, and `FormValidator` for inputs.
- **Strings**: add keys to **both** `intl_en.arb` and `intl_es.arb`, then run `cd app && dart run intl_utils:generate` and use `S.of(context).key`.
- **Styling**: `Dimen.*` for spacing and sizes, `Theme.of(context).textTheme/colorScheme` or `context.colors`. Don't hardcode values.
- **Analytics (optional)**: extend `TrackedPage` only after `AnalyticsClient` is registered and `routeObserver` is added
  to GoRouter's `observers` (known-issues #4).

## 5. Tests

See [testing.md](testing.md). At minimum: a cubit test (states emitted for success and failure), a repository test
(DTO mapping + `DioException` → `Failure`), and a widget test for the page's loading, error, and success branches.

## Checklist for a reviewer

- [ ] No forbidden imports ([modules.md](../architecture/modules.md#dependency-rules)).
- [ ] The repository returns `ResultType`, and the cubit exposes `Resource`.
- [ ] Registrations are in the right `init.dart`. Screen cubits aren't registered as singletons.
- [ ] Strings are localized in all `.arb` files, and the generated code is refreshed.
- [ ] Tests are added. `melos run analyze` and `melos run format` are clean.
