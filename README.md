# Flutter Template

## Usage

Clone the repository

## Prerequisite

- Flutter 3.41.6
- Flutter version manager (recommend): [fvm](https://fvm.app/)

## Getting Started

### Setup

- Create these `.env` files in the root directory according to the flavors and add the required
  environment variables into them. The example environment variable is in `.env.sample`.

    - Dev: `.env.dev`

    - Staging: `.env.staging`

    - Production: `.env`

- Run code generator:

    - `$ fvm dart run build_runner build --delete-conflicting-outputs`

### Run

- Run the app with the desire app flavor:

    - Dev: `$ fvm flutter run --flavor dev --target lib/main_dev.dart --dart-define-from-file=.env.dev`

    - Staging: `$ fvm flutter run --flavor staging --target lib/main_staging.dart --dart-define-from-file=.env.staging`

    - Production: `$ fvm flutter run --flavor production --target lib/main.dart --dart-define-from-file=.env`

## License

This project is Copyright (c) 2014 and onwards. It is free software,
and may be redistributed under the terms specified in the [LICENSE] file.

[LICENSE]: /LICENSE
