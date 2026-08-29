---
trigger: always_on
description: Agentic AI instructions
globs: 
---

# Agentic AI Instructions

## Feature Organization
When creating a new feature, place it inside `lib/features/[feature_name]/` and create two main subdirectories: `data` and `presentation`. Inside `data`, create `model`, `notifier`, `repository`, and `state`. Inside `presentation`, create `view` and `widget`.

## Models & States
Use `Equatable` for state and model classes to ensure value equality.

**Example (`data/state/[feature]_state.dart`):**
```dart
import 'package:equatable/equatable.dart';
import '../../../common/enums/loading_status.dart';

class MyFeatureState extends Equatable {
  const MyFeatureState({
    this.loadingStatus = LoadingStatus.initial,
  });

  final LoadingStatus loadingStatus;

  MyFeatureState copyWith({
    LoadingStatus? loadingStatus,
  }) {
    return MyFeatureState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
    );
  }

  @override
  List<Object?> get props => [loadingStatus];
}
```

## Repositories
Repositories define abstract interfaces and their `Injectable` implementations. They must handle exceptions and return a `Result<T>`.

- Define Request/Response models in `lib/core/api/`.
- Repositories inject needed services via the constructor.

**Example (`data/repository/[feature]_repository.dart`):**
```dart
import 'package:injectable/injectable.dart';
import '../../../core/data/base/result.dart';

abstract class MyFeatureRepository {
  Future<Result<MyDataResponse>> fetchData();
}

@Singleton(as: MyFeatureRepository)
class MyFeatureRepositoryImpl implements MyFeatureRepository {
  MyFeatureRepositoryImpl({required ApiService apiService})
      : _apiService = apiService;

  final ApiService _apiService;

  @override
  Future<Result<MyDataResponse>> fetchData() async {
    try {
      final result = await _apiService.fetchData();
      return Result.success(result);
    } catch (e) {
      return Result.failed(UseCaseException(e));
    }
  }
}
```

## Riverpod Notifiers
Use Riverpod `NotifierProvider` to manage UI state. Avoid relying on global DI for Notifiers directly from UI, but you can inject dependencies from GetIt directly into the `NotifierProvider`.

**Example (`data/notifier/[feature]_notifier.dart`):**
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/di.dart';
import '../../../core/data/base/result.dart';
import '../repository/my_feature_repository.dart';
import '../state/my_feature_state.dart';
import '../../../common/enums/loading_status.dart';

final myFeatureNotifierProvider = NotifierProvider<MyFeatureNotifier, MyFeatureState>(
  () => MyFeatureNotifier(getIt.get<MyFeatureRepository>()),
);

class MyFeatureNotifier extends Notifier<MyFeatureState> {
  MyFeatureNotifier(this._repository);
  final MyFeatureRepository _repository;

  Future<void> loadData() async {
    state = state.copyWith(loadingStatus: LoadingStatus.loading);
    final result = await _repository.fetchData();
    
    if (result is Success) {
      state = state.copyWith(loadingStatus: LoadingStatus.done);
    } else {
      state = state.copyWith(loadingStatus: LoadingStatus.error);
    }
  }

  @override
  MyFeatureState build() => const MyFeatureState();
}
```

## Navigation / Routing
Routing is handled centrally in `lib/navigation/app_routes.dart` via `GoRouter`.
- Define your route names and paths as `static const` fields in `AppRouteName` and `AppRoutePath` respectively within `lib/navigation/route_const.dart`.
- Add new routes to the `routes` list in `app_routes.dart` returning a `GoRoute`, referencing the constants from `route_const.dart`.
- Pass Riverpod `ref` if a dynamically resolved state is needed for routing, though `goRouterProvider` handles the static config.

## API Setup
- Define API calls in `lib/core/api/api_service.dart` (using Retrofit).
- Separate Request `body` and `response` objects in `lib/core/api/body/` and `lib/core/api/response/` respectively.
- Run `dart run build_runner build --delete-conflicting-outputs` after modifying API files or Repositories to regenerate injectables.

## General Coding Rules
- Do NOT use plain `StatefulWidget` for global state. Use `ConsumerWidget` or `ConsumerStatefulWidget` via Riverpod.
- Handle translations using generated classes like `AppLocalizations.of(context)`.
- Follow strict linting rules; use standard naming conventions (camelCase variables, PascalCase classes, snake_case files).
- Always use `const` constructors for Widgets when possible.

---
**Summary for AI Agent:**
To create a new feature:
1. Define API request bodies and responses in `lib/core/api/`. Update `ApiService` if an endpoint is needed.
2. Formulate **State** using `Equatable` in `features/[feature]/data/state`.
3. Create **Repository** in `features/[feature]/data/repository` using `@Singleton(as: ...)`.
4. Create **Notifier** in `features/[feature]/data/notifier` utilizing `getIt<Repository>()` via `NotifierProvider`.
5. Create **UI widgets / views** in `features/[feature]/presentation/` subscribing to the Notifier.
6. Register the route in `lib/navigation/app_routes.dart`.
7. Remember to execute `dart run build_runner build --delete-conflicting-outputs` to generate routes, APIs, or injectable settings!