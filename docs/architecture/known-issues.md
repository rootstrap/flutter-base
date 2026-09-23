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
- `app/pubspec.yaml` bundles all of `env/` as assets, so any secret placed there ships in the binary.
- `Environment.clientSecret` / `portalUrl` read unsuffixed keys and are unused.

**#3 Test coverage is thin, and iOS isn't built in CI.**
The only app-code tests are `modules/common/test` (`ResultType`) and `modules/domain/test` (`EnvConfig`). `app` and
`data` have none. (`tool/project_init` has its own suite.) CI (`ci.yml`) runs format, analyze, test and an Android debug
build on every PR. The SonarQube workflow is project-only and needs the `SONAR_TOKEN`/`SONAR_URL` secrets. iOS builds
are only validated locally.

**#4 The analytics scaffolding isn't wired.**
No `AnalyticsClient` is registered in GetIt, so any `TrackedPage` throws on first track. `routeObserver` isn't passed
to `GoRouter(observers:)`, so the enter/exit events never fire. `FirebaseAnalytics` throws `UnimplementedError`, and
`SetupAnalytics.initialize()` is never called. `firebase_core` is a dependency, but `Firebase.initializeApp` is commented out.

**#5 Resolved (#120, verified by iOS builds of every scheme).** The iOS xcconfigs point at existing entrypoints.
Design note: they set `FLUTTER_TARGET` after including `Generated.xcconfig`, so a flavor always builds its own
entrypoint, even if `flutter build -t` names another one.

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

**#12 Resolved.** `pub:runner` now only runs in packages that depend on `build_runner`, and `run:web` uses the dev
entrypoint.

**#13 Dependency hygiene.**
- `intl_utils` (a code generator) is a runtime dependency of `app` and `common`, and `flutter_gen` is an unversioned
  `app` dev dependency that nothing uses.
- Most test dependencies (`bloc_test`, `mocktail`, `build_runner`) are still unused (#3). `equatable` is declared in
  `app`, `data` and `domain` but not imported anywhere.

**#14 Repository hygiene.**
There are empty `.github/instructions/*.md.new` files. `app/linux/` contains only generated plugin registrant files (a
partial platform). The template `README.md`/`CHANGELOG.md` are still in each module.

**#15 Documentation drift.**
The root `README.md` was rewritten to match the code (it used to advertise a Gemini chat, an "RS-GPT-Review" action
and Bitrise CI, none of which exist). The repository has no `LICENSE` file, so projects must add their own.
`.cursor/rules/*.mdc` and `.github/instructions/*.instructions.md` prescribe conventions the code doesn't follow
(PascalCase `AuthService.dart` file names, `ALL_CAPS` constants, "avoid global cubits", entity classes with a
`parseFlexibleNumber` helper that doesn't exist). `CLAUDE.md` and `docs/` describe the actual code.

**#16 Resolved.** `app/pubspec.yaml` `version:` is the single source: the iOS xcconfigs no longer override
`FLUTTER_BUILD_NAME/NUMBER`, and the unused version keys were removed from `android/build.properties`.

## Toolchain (found during the Flutter 3.47 / Melos 8 upgrade)

**#17 `melos run` re-splits forwarded arguments.** `melos run init -- --name "My App"` passes `My` and `App` separately.
That is why `melos run init` prompts for its values, and why the documented non-interactive form calls
`dart tool/project_init/bin/init.dart` directly.

**#18 `firebase_core` is heavy and unused.** Under Swift Package Manager it pulls the whole `firebase-ios-sdk` package
graph (including Firestore, gRPC and Analytics binaries, hundreds of MB) into every iOS build, and on Android it is the
last plugin that applies the Kotlin Gradle Plugin itself (a build warning ahead of AGP's built-in Kotlin). Yet Firebase is
never initialized (#4). Consider making it opt-in per project.

**#19 Lock files are not committed.** `pubspec.lock` and SPM's `Package.resolved` are git-ignored (`*.lock` in the root
`.gitignore`), so two checkouts can resolve different versions. Committing them is the usual choice for an application.

**#20 compileSdk 37 is ahead of Flutter's default.** `permission_handler` 13 requires it, while Flutter 3.47 defaults to
36, so machines and CI must install `platforms;android-37.0` (`ci.yml` does). `targetSdk` stays 36.

**#21 AGP 9 compatibility flags.** `android/gradle.properties` sets `android.newDsl=false` and `android.builtInKotlin=false`,
as the Flutter 3.47 template does. Both are transitional; revisit them when Flutter moves to the new DSL and built-in Kotlin.
