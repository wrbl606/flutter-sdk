# Flutter SDK for GitHub Actions

[![MIT license](https://img.shields.io/badge/license-MIT-blue.svg)](./LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](.)
<img src="./doc/assets/monterail_logo.svg" alt="Monterail's logo" width="25%" height="100" align="right"/>

Flutter and Dart in your GitHub Actions. Use effortlessly in your project, inspire yourself with our [Recipes](#recipes).

## Installation

Copy and paste the following snippet into your action's `.yml` file.

```yaml
  - name: Install Flutter
    uses: monterail/flutter-action@v2
```

## Usage

With Flutter SDK for GitHub Actions you can do the following:

```yaml
steps:
  - uses: monterail/flutter-action@v2
  - run: flutter build ...
```

### Action arguments

`monterail/flutter-action@v1` provides sane defaults, assuming the default usage is to get the newest, production-ready, Flutter SDK. For more complex use-cases, customize the action with the non-standard inputs.

| Name | Description | Default |
| --- | --- | --- |
| `channel` | Flutter [channel](https://github.com/flutter/flutter/wiki/Flutter-build-release-channels) | `stable` |
| `precache` | `flutter precache` arguments list, see [recipe](#precache-web-and-android-build-tools) | no-op |

## Recipes

List of practical applications of `monterail/flutter-action@v1` for your project. Click the `Details` dropdown to see the implementation. Test the recipe by putting it into `.github/workflows/action.yml` file in your project's repository. 

### Assure code quality standard for each PR

Will check (and annotate, if necessary) code quality and formatting guidelines set in `analysis_options.yaml`. Once code quality is checked, will run tests.

<details>

```yaml
name: Lint and Test PRs

on:
  pull_request:
    branches:
      - main

jobs:
  lint:
    runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v4
        - uses: monterail/flutter-action@v2
        - run: flutter pub get
        - uses: invertase/github-action-dart-analyzer@v3
          with:
            annotate: true
        - run: dart format --set-exit-if-changed --output none
        - run: flutter test
```

</details>

### Build web project artifact on each `main` push

Load project's dependencies and build web app into a `.zip` file, stored as an artifact for the given commit.

<details>

```yaml
name: Build web app

on:
  push:
    branches:
      - main

jobs:
  lint:
    runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v4
        - uses: monterail/flutter-action@v2
        - run: flutter pub get
        - run: flutter build web
        - uses: actions/upload-artifact@v4
          with:
            name: web-app
            path: build/web
```

</details>

### Precache web and Android build tools

By default Flutter will fetch the tools necessary to build specific platforms after `flutter build` command is ran. The process can be sped up with precaching specific platforms at Flutter installation stage.

<details>

```yaml
name: Setup Flutter for web and Android builds

on:
  push:
    branches:
      - main

jobs:
  lint:
    runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v4
        - uses: monterail/flutter-action@v2
          with:
            precache: "--web --android"
        - run: flutter pub get
        - run: flutter build web
        - uses: actions/upload-artifact@v4
          with:
            name: web-app
            path: build/web
```

</details>
