// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Flutter Target`
  String get appName {
    return Intl.message('Flutter Target', name: 'appName', desc: '', args: []);
  }

  /// `This website uses cookies`
  String get cookiesTitle {
    return Intl.message(
      'This website uses cookies',
      name: 'cookiesTitle',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get cookiesAcceptCTA {
    return Intl.message('Accept', name: 'cookiesAcceptCTA', desc: '', args: []);
  }

  /// `We use cookies to personalise content and ads, to provide social media features and to analyse our traffic. We also share information about your use of our site with our social media, advertising and analytics partners who may combine it with other information that you’ve provided to them or that they’ve collected from your use of their services.`
  String get cookiesBody {
    return Intl.message(
      'We use cookies to personalise content and ads, to provide social media features and to analyse our traffic. We also share information about your use of our site with our social media, advertising and analytics partners who may combine it with other information that you’ve provided to them or that they’ve collected from your use of their services.',
      name: 'cookiesBody',
      desc: '',
      args: [],
    );
  }

  /// `No connection`
  String get noConnection {
    return Intl.message(
      'No connection',
      name: 'noConnection',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `Please try again later, we are\nworking to fix the issue.`
  String get pleaseTryAgainLaterWeArenworkingToFixTheIssue {
    return Intl.message(
      'Please try again later, we are\nworking to fix the issue.',
      name: 'pleaseTryAgainLaterWeArenworkingToFixTheIssue',
      desc: '',
      args: [],
    );
  }

  /// `Sorry we didn't find any product`
  String get sorryWeDidntFindAnyProduct {
    return Intl.message(
      'Sorry we didn\'t find any product',
      name: 'sorryWeDidntFindAnyProduct',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get ctaLogin {
    return Intl.message('Login', name: 'ctaLogin', desc: '', args: []);
  }

  /// `Sign Up`
  String get ctaSignUp {
    return Intl.message('Sign Up', name: 'ctaSignUp', desc: '', args: []);
  }

  /// `Email`
  String get labelEmail {
    return Intl.message('Email', name: 'labelEmail', desc: '', args: []);
  }

  /// `Password`
  String get labelPassword {
    return Intl.message('Password', name: 'labelPassword', desc: '', args: []);
  }

  /// `Confirm Password`
  String get labelConfirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'labelConfirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match.`
  String get errorPasswordsDoNotMatch {
    return Intl.message(
      'Passwords do not match.',
      name: 'errorPasswordsDoNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Min 8 characters long: 1 uppercase letter, 1 lowercase letter, 1 number, and 1 special character.`
  String get passwordInstructions {
    return Intl.message(
      'Min 8 characters long: 1 uppercase letter, 1 lowercase letter, 1 number, and 1 special character.',
      name: 'passwordInstructions',
      desc: '',
      args: [],
    );
  }

  /// `I agree to the Terms and Conditions`
  String get labelAgreeToTerms {
    return Intl.message(
      'I agree to the Terms and Conditions',
      name: 'labelAgreeToTerms',
      desc: '',
      args: [],
    );
  }

  /// `Email is required.`
  String get errorEmailRequired {
    return Intl.message(
      'Email is required.',
      name: 'errorEmailRequired',
      desc: '',
      args: [],
    );
  }

  /// `Password is required.`
  String get errorPasswordRequired {
    return Intl.message(
      'Password is required.',
      name: 'errorPasswordRequired',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get titleLogin {
    return Intl.message('Login', name: 'titleLogin', desc: '', args: []);
  }

  /// `Sign Up`
  String get titleSignUp {
    return Intl.message('Sign Up', name: 'titleSignUp', desc: '', args: []);
  }

  /// `Use your email and password to login to your account.`
  String get titleLoginSubtitle {
    return Intl.message(
      'Use your email and password to login to your account.',
      name: 'titleLoginSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Create an account using your email and password.`
  String get titleSignUpSubtitle {
    return Intl.message(
      'Create an account using your email and password.',
      name: 'titleSignUpSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address.`
  String get errorEmailInvalid {
    return Intl.message(
      'Please enter a valid email address.',
      name: 'errorEmailInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Password is too weak.`
  String get errorPasswordWeak {
    return Intl.message(
      'Password is too weak.',
      name: 'errorPasswordWeak',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email or password.`
  String get loginErrorInvalidCredentials {
    return Intl.message(
      'Invalid email or password.',
      name: 'loginErrorInvalidCredentials',
      desc: '',
      args: [],
    );
  }

  /// `This should open the terms and conditions URL.`
  String get hintTermsAndConditions {
    return Intl.message(
      'This should open the terms and conditions URL.',
      name: 'hintTermsAndConditions',
      desc: '',
      args: [],
    );
  }

  /// `DEV`
  String get debugModeLabel {
    return Intl.message('DEV', name: 'debugModeLabel', desc: '', args: []);
  }

  /// `RESET`
  String get debugModeResetApp {
    return Intl.message('RESET', name: 'debugModeResetApp', desc: '', args: []);
  }

  /// `Reset App`
  String get debugModeResetAppTitle {
    return Intl.message(
      'Reset App',
      name: 'debugModeResetAppTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to reset the app?`
  String get debugModeResetAppMessage {
    return Intl.message(
      'Are you sure you want to reset the app?',
      name: 'debugModeResetAppMessage',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get debugModeCancel {
    return Intl.message('Cancel', name: 'debugModeCancel', desc: '', args: []);
  }

  /// `Confirm`
  String get debugModeConfirm {
    return Intl.message(
      'Confirm',
      name: 'debugModeConfirm',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
