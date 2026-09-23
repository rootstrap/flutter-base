import 'dart:convert';
import 'dart:io';

import 'identity.dart';

/// Name of the repository metadata file, relative to the repository root.
const stateFileName = 'flutter_base.json';

/// Whether the repository is the Flutter Base template or a project created
/// from it.
enum RepositoryState {
  template,
  initialized;

  static RepositoryState parse(Object? value) => switch (value) {
    'template' => RepositoryState.template,
    'initialized' => RepositoryState.initialized,
    _ => throw FormatException(
      'Unknown "state" in $stateFileName: $value. '
      'Expected "template" or "initialized".',
    ),
  };
}

/// Contents of [stateFileName]: the repository state plus the identity that
/// is currently written into the repository.
class ProjectState {
  const ProjectState({required this.state, required this.identity});

  final RepositoryState state;
  final ProjectIdentity identity;

  static File file(Directory root) =>
      File('${root.path}${Platform.pathSeparator}$stateFileName');

  static ProjectState read(Directory root) {
    final stateFile = file(root);
    if (!stateFile.existsSync()) {
      throw FileSystemException(
        '$stateFileName not found. Run the initializer from the root of a '
        'Flutter Base checkout.',
        stateFile.path,
      );
    }
    final json = jsonDecode(stateFile.readAsStringSync());
    if (json is! Map<String, Object?>) {
      throw const FormatException('$stateFileName must contain a JSON object.');
    }
    final identity = json['identity'];
    if (identity is! Map<String, Object?>) {
      throw const FormatException('Missing "identity" in $stateFileName.');
    }
    return ProjectState(
      state: RepositoryState.parse(json['state']),
      identity: ProjectIdentity.fromJson(identity),
    );
  }

  String encode() {
    final json = {
      r'$comment': _comment,
      'state': state.name,
      'identity': identity.toJson(),
    };
    return '${const JsonEncoder.withIndent('  ').convert(json)}\n';
  }

  static const _comment =
      'Managed by the project initializer (melos run init). "template" means '
      'this is the Flutter Base itself; "initialized" means it is a project '
      'created from it. CI reads "state" to decide whether project-only '
      'automation runs. See docs/development/project-initialization.md.';
}
