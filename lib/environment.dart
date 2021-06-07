class Environment {
  final String secret;
  Environment(this.secret);
}

class EnvironmentValue {
  static final Environment development = Environment('development');
  static final Environment production = Environment('production');
}
