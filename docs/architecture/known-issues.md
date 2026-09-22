# Known issues and technical debt

This register lists defects and debt that were verified by reading the source (on 2026-09-22). It exists
so that people and agents **don't rediscover these repeatedly, and don't fix them silently inside unrelated
changes**. Fix each one in its own PR, then delete its entry or mark it resolved. Numbers are stable
because other docs reference them.

## Correctness

**#1 `ResultType.mapError` never calls its callback, so auth errors never reach the UI.**
`modules/common/lib/core/result_type.dart`: `mapError` returns `TError(e.error)` without invoking `error(...)`.
`AuthCubit.login` / `signUp` use `..mapSuccess(...)..mapError((f) => isError(f))`, so a `TError` leaves the
cubit in `RLoading` forever. It's latent today because the fake `AuthRepositoryImpl` always succeeds. It will
surface the moment a real backend is connected. Use `BaseCubit.onResult` or a `switch` until it's fixed.

**#2 The two environment mechanisms disagree.**
- `Environment.envConfigFile` loads `env/.<ENV>` (`--dart-define ENV`, default `dev`). `EnvConfig.apiUrl` reads
  `API_URL_<DEV|QA|PROD>`. The committed `env/.dev` defines `API_URL` (unsuffixed), so **the base URL is `''`**.
- `FlavorConfig.getEnvFilePath()` and `EnvConfig.envConfigFile` both return `env/.env.example` and are unused.
- The doc comments tell you to create `env/.env` and add it to assets, but the code never loads `.env`.
- `melos run run:web` runs the **prod** entrypoint (`lib/main.dart`) with `env/.dev`, so the flavor is PROD with dev values.
- `app/pubspec.yaml` bundles all of `env/` as assets, so any secret placed there ships in the binary.
- `Environment.clientSecret` / `portalUrl` read unsuffixed keys and are unused.

**#3 There are no tests, and CI fails before it checks anything.**
No package has a `test/` directory. `.github/workflows/sonar-qube-scann.yml` is enabled for PRs and pushes to `main`,
but its first step (`webfactory/ssh-agent`) fails because the `SSH_PRIVATE_KEY` secret isn't configured, so analyze,
tests and SonarQube are skipped. No pub dependency is git-based, so the step isn't needed. The workflow also has no
format-check or build step. `sonar.tests` lists `app/test` and `modules/domain/test`, and neither exists.

**#4 The analytics scaffolding isn't wired.**
No `AnalyticsClient` is registered in GetIt, so any `TrackedPage` throws on first track. `routeObserver` isn't passed
to `GoRouter(observers:)`, so the enter/exit events never fire. `FirebaseAnalytics` throws `UnimplementedError`, and
`SetupAnalytics.initialize()` is never called. `firebase_core` is a dependency, but `Firebase.initializeApp` is commented out.

**#5 Build targets point to files that don't exist.**
`ios/Flutter/Release.xcconfig` has `FLUTTER_TARGET=lib/main/env/main.dart`, but the prod entrypoint is `lib/main.dart`.
`ios/qa.xcconfig` uses `FLUTTER_TARGET=lib/main/env/main_dev.dart` and `PREFIX=dev`. The README build commands use
`-t lib/main/env/main.dart --dart-define-from-file=env_prod.json`, which is a nonexistent path and file.

**#6 `addModule.py` copies from the wrong path.**
It clones `rootstrap/flutter-modules` into `/Users/Shared` (a hardcoded macOS path) but copies from
`/Users/Shared/flutter-base/modules/<name>` and deletes `/Users/Shared/flutter-base`. The clone directory is `flutter-modules`.

**#7 Error mapping is incomplete.**
`FailureMapper` maps `DioExceptionType.connectionError` to `UnexpectedFailure`, so `ConnectionFailure` is never produced
and `ConnectionErrorWidget` is never shown. In `FailureWidget`, the case `UnexpectedErrorWidget _` matches a `Failure`
against a widget type, which is dead code. No repository uses `toFailure()` yet.

**#8 `AuthTokenInterceptor` clears every preference.**
It calls `Preferences.clear()` (which also removes theme, language, and cookie consent) on 401/403/422 and on
**every request made without a token**. It sets `Content-Type` only when a token exists.

**#9 Minor code defects.**
`Images.appLogo` → `assets/icons/logo.png` doesn't exist (and `assets/icons/` isn't declared). `Images.img()` passes
`width` as `height`. `CustomNetworkImage` force-unwraps `svgIconColor!` when `color` is non-null.

## Architecture and boundaries

**#10 Boundary exceptions.**
`app/.../ui/custom/cookies.dart` resolves `CommonRepository` directly (it skips the cubit/service). `domain` depends on
`flutter_dotenv`, which is infrastructure. `common` depends on `dio` and `flutter_bloc`. The rule set is in
[modules.md](modules.md). None of it is tool-enforced.

**#11 Service layer is pass-through.** `AuthService` only forwards to the repository, and there's no use-case layer.
That's acceptable, but it means "where business rules go" is by convention only (services).

## Tooling and template hygiene

**#12 Melos scripts.**
`pub:runner` runs `dart run build_runner` in every package, but only `app` declares `build_runner` and no generators are
configured, so it has nothing to do (and fails in packages without the dependency). `run:web` uses the prod entrypoint (see #2).

**#13 Dependency hygiene.**
- `intl_utils` (a code generator) is a runtime dependency of `app` and `common`, and `flutter_gen` is an unversioned
  `app` dev dependency that nothing uses.
- Test dependencies are declared but unused, because there are no tests (#3).

**#14 Repository hygiene.**
There are empty `.github/instructions/*.md.new` files. A stray `ios/Podfile` sits at the repo root: a default Flutter-generated
Podfile that references a nonexistent `RunnerTests` target. The one the app uses is `app/ios/Podfile`. `app/linux/` contains only generated plugin registrant files (a partial platform). The template
`README.md`/`CHANGELOG.md` are still in each module.

**#15 Documentation drift.**
The root `README.md` advertises "Chat with Gemini and Vertex AI" and an "RS-GPT-Review" GitHub Action. Neither exists in
this repo. It describes Bitrise CI, but there's no config for it, and its license badge points at `rootstrap/ios-base`.
`.cursor/rules/*.mdc` and `.github/instructions/*.instructions.md` prescribe conventions the code doesn't follow
(PascalCase `AuthService.dart` file names, `ALL_CAPS` constants, "avoid global cubits", entity classes with a
`parseFlexibleNumber` helper that doesn't exist). `CLAUDE.md` and `docs/` describe the actual code.

**#16 Version sources disagree.** Pubspec `1.0.0+1`, iOS xcconfig `2.0.0`, and Android `build.properties` `1.0.0` (not read by Gradle).
