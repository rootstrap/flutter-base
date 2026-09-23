/// The values that make a copy of the Flutter Base a specific project.
class ProjectIdentity {
  const ProjectIdentity({
    required this.displayName,
    required this.packageName,
    required this.androidApplicationId,
    required this.androidNamespace,
    required this.iosBundleId,
  });

  factory ProjectIdentity.fromJson(Map<String, Object?> json) {
    String read(String key) {
      final value = json[key];
      if (value is! String || value.isEmpty) {
        throw FormatException('Missing "identity.$key" in the state file.');
      }
      return value;
    }

    return ProjectIdentity(
      displayName: read('displayName'),
      packageName: read('packageName'),
      androidApplicationId: read('androidApplicationId'),
      androidNamespace: read('androidNamespace'),
      iosBundleId: read('iosBundleId'),
    );
  }

  /// Human-readable app name (launcher label, iOS display name, web title).
  final String displayName;

  /// Dart package name of the Flutter application package (`app/`).
  final String packageName;

  /// Android `applicationId`.
  final String androidApplicationId;

  /// Android `namespace`, which is also the Kotlin package of `MainActivity`.
  final String androidNamespace;

  /// iOS `PRODUCT_BUNDLE_IDENTIFIER` of release builds. Other build
  /// configurations append suffixes such as `.debug` or `.dev`.
  final String iosBundleId;

  Map<String, String> toJson() => {
    'displayName': displayName,
    'packageName': packageName,
    'androidApplicationId': androidApplicationId,
    'androidNamespace': androidNamespace,
    'iosBundleId': iosBundleId,
  };
}

/// Validates the values a developer provides. Every method returns an error
/// message, or `null` when the value is valid.
class IdentityValidator {
  IdentityValidator({this.reservedPackageNames = const {}});

  /// Package names the application package must not take.
  final Set<String> reservedPackageNames;

  static final _packageNamePattern = RegExp(r'^[a-z][a-z0-9_]*$');
  static final _androidSegmentPattern = RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*$');
  static final _iosSegmentPattern = RegExp(r'^[a-zA-Z0-9-]+$');

  String? displayName(String value) {
    if (value.trim().isEmpty) return 'The app name is required.';
    if (value != value.trim()) {
      return 'The app name must not start or end with whitespace.';
    }
    if (value.length > 50) {
      return 'The app name must be 50 characters or fewer.';
    }
    if (value.contains(RegExp(r'[\r\n\t]'))) {
      return 'The app name must be a single line.';
    }
    // `$` would be expanded by Xcode, `//` starts an xcconfig comment, `\` is
    // an escape character in .properties files, and a leading `@` or `?` makes
    // Android treat the label as a resource reference.
    if (value.contains(r'$') || value.contains('//') || value.contains(r'\')) {
      return r'The app name must not contain "$", "//" or "\".';
    }
    if (value.startsWith('@') || value.startsWith('?')) {
      return 'The app name must not start with "@" or "?".';
    }
    return null;
  }

  String? packageName(String value) {
    if (value.isEmpty) return 'The package name is required.';
    if (!_packageNamePattern.hasMatch(value)) {
      return 'The package name must use lowercase letters, digits and '
          'underscores, and start with a letter (for example "my_app").';
    }
    if (value.length > 64) {
      return 'The package name must be 64 characters or fewer.';
    }
    if (dartReservedWords.contains(value)) {
      return '"$value" is a reserved word in Dart.';
    }
    if (reservedPackageNames.contains(value)) {
      return '"$value" is already used by a workspace package or a dependency '
          '(direct or indirect).';
    }
    return null;
  }

  String? androidApplicationId(String value) {
    final error = _dotted(value, 'Android application ID');
    if (error != null) return error;
    for (final segment in value.split('.')) {
      if (!_androidSegmentPattern.hasMatch(segment)) {
        return 'Each segment of the Android application ID must start with a '
            'letter and contain only letters, digits and underscores '
            '("$segment" does not). Use --android-application-id to give '
            'Android a different ID than iOS.';
      }
      if (javaKotlinKeywords.contains(segment)) {
        return '"$segment" is a Java/Kotlin keyword and cannot be a segment '
            'of the Android application ID (it is also the Kotlin package).';
      }
    }
    return null;
  }

  String? iosBundleId(String value) {
    final error = _dotted(value, 'iOS bundle identifier');
    if (error != null) return error;
    for (final segment in value.split('.')) {
      if (!_iosSegmentPattern.hasMatch(segment)) {
        return 'Each segment of the iOS bundle identifier may contain only '
            'letters, digits and hyphens ("$segment" does not).';
      }
    }
    return null;
  }

  String? _dotted(String value, String label) {
    if (value.isEmpty) return 'The $label is required.';
    if (value.length > 155) return 'The $label is too long.';
    final segments = value.split('.');
    if (segments.length < 2) {
      return 'The $label needs at least two segments (for example '
          '"com.company.app").';
    }
    if (segments.any((s) => s.isEmpty)) {
      return 'The $label must not contain empty segments.';
    }
    return null;
  }

  /// Validates a complete identity and returns every error found.
  List<String> validate(ProjectIdentity identity) => [
    displayName(identity.displayName),
    packageName(identity.packageName),
    androidApplicationId(identity.androidApplicationId),
    androidApplicationId(identity.androidNamespace),
    iosBundleId(identity.iosBundleId),
  ].whereType<String>().toSet().toList();
}

/// Dart reserved words and built-in identifiers, which pub rejects as
/// package names.
const dartReservedWords = {
  'abstract',
  'as',
  'assert',
  'async',
  'await',
  'base',
  'break',
  'case',
  'catch',
  'class',
  'const',
  'continue',
  'covariant',
  'default',
  'deferred',
  'do',
  'dynamic',
  'else',
  'enum',
  'export',
  'extends',
  'extension',
  'external',
  'factory',
  'false',
  'final',
  'finally',
  'for',
  'function',
  'get',
  'hide',
  'if',
  'implements',
  'import',
  'in',
  'interface',
  'is',
  'late',
  'library',
  'mixin',
  'new',
  'null',
  'of',
  'on',
  'operator',
  'part',
  'required',
  'rethrow',
  'return',
  'sealed',
  'set',
  'show',
  'static',
  'super',
  'switch',
  'sync',
  'this',
  'throw',
  'true',
  'try',
  'type',
  'typedef',
  'var',
  'void',
  'when',
  'while',
  'with',
  'yield',
};

/// Keywords that cannot appear as a segment of a Java or Kotlin package name.
const javaKotlinKeywords = {
  'abstract',
  'as',
  'assert',
  'boolean',
  'break',
  'byte',
  'case',
  'catch',
  'char',
  'class',
  'const',
  'continue',
  'default',
  'do',
  'double',
  'else',
  'enum',
  'extends',
  'false',
  'final',
  'finally',
  'float',
  'for',
  'fun',
  'goto',
  'if',
  'implements',
  'import',
  'in',
  'instanceof',
  'int',
  'interface',
  'is',
  'long',
  'native',
  'new',
  'null',
  'object',
  'package',
  'private',
  'protected',
  'public',
  'return',
  'short',
  'static',
  'strictfp',
  'super',
  'switch',
  'synchronized',
  'this',
  'throw',
  'throws',
  'transient',
  'true',
  'try',
  'typealias',
  'typeof',
  'val',
  'var',
  'void',
  'volatile',
  'when',
  'while',
};
