import 'package:flutter/material.dart';
import 'app_circular_progress_indicator.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: const Center(
        child: AppCircularProgressIndicator(),
      ),
    );
  }
}
