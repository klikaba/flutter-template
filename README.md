# Flutter Template

This template provides starting point for Flutter hybrid app, following Klika quality guidelines, with implemented authentication following OAuth2 standard.

## Setup

### Dependencies

* Latest Flutter SDK
* Ruby + overcommit gem

```
scripts/setup
```

This script will:
 * Setup overcommit hooks

### Configuration

To get basic idea about configuration approach read [12factor](https://12factor.net/).

Configuration is achieved using *"flavors"* and is stored in [lib/config.dart](lib/config.dart). By default, application is started in `production` flavor. To run in `development`, start with `flutter run -t lib/main-dev.dart`. Platform flavors can be used too (`flutter run --flavor dev -t lib/main-dev.dart`). This project defines `dev` and `prod` platform flavors.

Running development:
```
flutter run --flavor dev -t lib/main-dev.dart
```

Running production:
```
flutter run --flavor prod
```

## Getting started

Use Klika quality guidelines for general development references.

### Flutter/Dart styleguides

This project is following [official Flutter codestyle](https://dart.dev/guides/language/effective-dart/style), which is also enforced by [lint tool](https://pub.dev/packages/lint). More guidelines are available in [official documentation](https://dart.dev/guides/language/effective-dart).

### New feature

Use [GitFlow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow) development workflow with tests included.

### Pull request quality gates

- no conflicts with target branch
- pass CI tests
- code review approval

## Tools

### Networking with Dio
Networking is implemented using [dio](https://pub.dev/packages/dio), to provide HTTP client as well as interceptors, combined with [json_serializable](https://pub.dev/packages/json_serializable) for generating utilities for transforming classes to and from JSON.

### Local DB with Hive
[Hive](https://pub.dev/packages/hive) is used for local database.

### Dependency injection and state management with Provider
We are using [provider](https://pub.dev/packages/provider) library for dependency injection, as well as state management.

### Quality gates

This project will run static code analyser on every commit and full test suite on git push.

### Static code analyser

This template is using [dartanalyzer](https://dart.dev/tools/dartanalyzer) with [pedantic package](https://pub.dev/packages/pedantic) for static code analysis. All offenses are automatically tracked and prevented on every commit. This feature is handled by [Overcommit](https://github.com/brigade/overcommit) git hook manager.

### Testing

We are using [flutter_test library](https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html) with [mockito](https://pub.dev/packages/mockito) for mocking and [http_mock_adapter](https://pub.dev/packages/http_mock_adapter) for mocking HTTP requests.

### Continuous Integration

[AppCenter](https://appcenter.ms) is recommended for CI.
Since Flutter is not supported by AppCenter, check out [official scripts](https://github.com/microsoft/appcenter/tree/master/sample-build-scripts/flutter) for more info on setup.

## Maintainers

- [Ensar Sarajcic](https://github.com/esensar)
