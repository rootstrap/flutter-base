# Known issues and technical debt

This register lists defects and debt that were verified by reading the source (on 2026-09-22). It exists
so that people and agents **don't rediscover these repeatedly, and don't fix them silently inside unrelated
changes**. Fix each one in its own PR, then delete its entry or mark it resolved. Numbers are stable
because other docs reference them.

## Correctness

**#1 Resolved (#118).** `ResultType.mapError` now invokes its callback, so `AuthCubit` emits `RError` on failure.

**#2 The two environment mechanisms disagree.**
- `Environment.envConfigFile` loads `env/.<ENV>` (`--dart-define ENV`, default `dev`), while `.env.example` documents a
  single file with suffixed keys. `EnvConfig.apiUrl` accepts both (`API_URL_<FLAVOR>`, falling back to `API_URL`, since #119),
  but the template still needs to settle on one layout.
- `FlavorConfig.getEnvFilePath()` and `EnvConfig.envConfigFile` both return `env/.env.example` and are unused.
- The doc comments tell you to create `env/.env` and add it to assets, but the code never loads `.env`.
- `melos run run:web` runs the **prod** entrypoint (`lib/main.dart`) with `env/.dev`, so the flavor is PROD with dev values.
- `app/pubspec.yaml` bundles all of `env/` as assets, so any secret placed there ships in the binary.
- `Environment.clientSecret` / `portalUrl` read unsuffixed keys and are unused.

**#3 Almost no tests, and CI fails before it checks anything.**
The only tests are `modules/common/test` (`ResultType`) and `modules/domain/test` (`EnvConfig`). `app` and `data` have none. `.github/workflows/sonar-qube-scann.yml` is enabled for PRs and pushes to `main`,
but its first step (`webfactory/ssh-agent`) fails because the `SSH_PRIVATE_KEY` secret isn't configured, so analyze,
tests and SonarQube are skipped. No pub dependency is git-based, so the step isn't needed. The workflow also has no
format-check or build step. `sonar.tests` lists `app/test`, which doesn't exist.

**#4 The analytics scaffolding isn't wired.**
No `AnalyticsClient` is registered in GetIt, so any `TrackedPage` throws on first track. `routeObserver` isn't passed
to `GoRouter(observers:)`, so the enter/exit events never fire. `FirebaseAnalytics` throws `UnimplementedError`, and
`SetupAnalytics.initialize()` is never called. `firebase_core` is a dependency, but `Firebase.initializeApp` is commented out.

**#5 Resolved (#120).** The iOS Release and QA xcconfigs and the README build commands now point at existing entrypoints.
Still unverified with a real iOS build: the xcconfigs set `FLUTTER_TARGET` after including `Generated.xcconfig`, so they
may override the target passed with `flutter build -t`.

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
- Most test dependencies (`bloc_test`, `mocktail`, `build_runner`) are still unused (#3).

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
