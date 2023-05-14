enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated;

  String toName() => name;
  static AuthStatus fromName(String name) => values.byName(name);
}
