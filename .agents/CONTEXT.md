---
trigger: always_on
description: Repository context for agentic AI
globs: 
---

# Repository Context

## Overview

This document describes the architectural patterns, folder structure, and coding standards for the Flutter application. Use this context when adding new features to ensure consistency.

## High-Level Architecture

The application follows a **Feature-First Architecture** combined with separated layers for State Management, UI, and Repositories.

- **State Management**: Uses **Riverpod** with `Notifier` and `NotifierProvider`. State classes are managed with `Equatable`.
- **Dependency Injection**: Uses **GetIt** and **Injectable** for Repositories and Services.
- **Routing**: Uses **GoRouter** with Riverpod providers.
- **Networking**: Uses **Dio** and **Retrofit** for API calls. API responses are wrapped in a generic `Result` (`Success`/`Failed`).
- **Data Models**: Employs `Equatable` for models and states.

## Project Structure

```
lib/
├── common/             # Reusable widgets, enums, extensions, utils, exceptions
├── core/               # Core configuration, Dependency Injection, Networking, Storage
│   ├── api/            # Retrofit Clients, API Models (Request Body, Responses)
│   ├── data/           # Base data models (e.g., Result wrapper)
│   ├── di/             # GetIt & Injectable setup
│   ├── dio/            # Dio interceptors and configurations
│   └── storage/        # Local storage (Shared Preferences, Secure Storage)
├── features/           # Feature folders
│   └── [FeatureName]/
│       ├── data/
│       │   ├── model/      # Local feature domain models
│       │   ├── notifier/   # Riverpod Notifiers
│       │   ├── repository/ # Data repositories (API calls wrapped in Result)
│       │   └── state/      # Riverpod State classes (using Equatable)
│       └── presentation/
│           ├── view/       # Flutter Pages / Screens
│           └── widget/     # Flutter Widgets used by views
├── gen/                # Auto-generated code (e.g., localization, assets)
├── l10n/               # Localization ARB files
├── navigation/         # GoRouter configurations and route constants (route_const.dart)
└── main*.dart          # Entry points for different environments
```

## Key Patterns
- **Riverpod State Management**: Each feature has `Notifier` classes extending `Notifier<T>` to manage `State` classes which extend `Equatable`.
- **Result Wrapper**: Repositories catch exceptions and return `Result<T>` with either `Result.success(data)` or `Result.failed(error)`.
- **Dependency Injection**: Repositories and Services use `@Singleton` or `@Injectable` from the `injectable` package.

## Scripts & Generation
- Use `build_runner` for generating Retrofit clients, Injectable DI files, and Riverpod lints.
- Example: `dart run build_runner build --delete-conflicting-outputs`