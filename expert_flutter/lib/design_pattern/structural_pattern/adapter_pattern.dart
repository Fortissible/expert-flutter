abstract class Authentication {
  authenticate();
}

class GoogleSDKAuthentication implements Authentication {
  @override
  authenticate() {
    // implementasi autentikasi Google
    return 'Authenticated!';
  }
}

class GitHubSDKAuthentication {
  String? _token;
  String? _mode;

  set token(String? value) {
    _token = value;
  }

  set mode(String value) {
    _mode = value;
  }

  signIn() {
    // implementasi autentikasi GitHub
    if (_token == null || _mode == null) {
      throw Exception('Need to define token and mode');
    }

    return 'Authenticated!';
  }
}

class GitHubAuthenticationAdapter implements Authentication {
  final String token;
  final String mode;

  GitHubAuthenticationAdapter(this.token, this.mode);

  @override
  authenticate() {
    final gitHubSDKAuthentication = GitHubSDKAuthentication();
    gitHubSDKAuthentication.token = token;
    gitHubSDKAuthentication.mode = mode;
    return gitHubSDKAuthentication.signIn();
  }
}

void authenticateApps(Authentication authentication) {
  print(authentication.authenticate());
}