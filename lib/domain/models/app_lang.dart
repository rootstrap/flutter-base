enum AppLang {
  es,
  en;

  String toName() => name;

  static AppLang fromName(String name) => values.byName(name);
}
