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

TBD

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

TBD

### Quality gates

This project will run static code analyser on every commit and full test suite on git push.

### Static code analyser

TBD (dart lint + overcommit)

### Testing

TBD

### Continuous Integration

[AppCenter](https://appcenter.ms) is recommended for CI.

## Maintainers

- [Ensar Sarajcic](https://github.com/esensar)