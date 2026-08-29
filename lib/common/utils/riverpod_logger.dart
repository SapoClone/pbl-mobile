import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class RiverpodLogger extends ProviderObserver {
  @override
  void didAddProvider(
    ProviderBase provider,
    Object? value,
    ProviderContainer container,
  ) {
    log(
      '''
        {
          "provider_add": "${provider.name ?? provider.runtimeType}",
          "value": "$value"
        }
    ''',
      name: '${provider.name ?? provider.runtimeType}',
    );
  }

  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    log(
      '''
          {
            "provider": "${provider.name ?? provider.runtimeType}",
            "newValue": "$newValue"
          }
    ''',
      name: '${provider.name ?? provider.runtimeType}',
    );
  }

  @override
  void didDisposeProvider(ProviderBase provider, ProviderContainer container) {
    log(
      '''
        {
          "provider_dispose_called": "${provider.name ?? provider.runtimeType}",
        }
    ''',
      name: '${provider.name ?? provider.runtimeType}',
    );
  }
}
