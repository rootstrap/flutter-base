import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:common/core/failure/failure.dart';
import 'package:app/presentation/resources/locale/generated/l10n.dart';

class FailureWidget extends StatelessWidget {
  final Failure? failure;
  final VoidCallback onRetry;

  const FailureWidget({super.key, required this.failure, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return switch (failure) {
      ConnectionFailure _ => ConnectionErrorWidget(onRetry: onRetry),
      UnexpectedErrorWidget _ => UnexpectedErrorWidget(onRetry: onRetry),
      _ => UnexpectedErrorWidget(onRetry: onRetry),
    };
  }
}

class ConnectionErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const ConnectionErrorWidget({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/images/connection.svg", width: 120),
          const SizedBox(height: 16),
          Text(
            S.of(context).noConnection,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: Text(S.of(context).retry)),
        ],
      ),
    );
  }
}

class UnexpectedErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const UnexpectedErrorWidget({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/images/error_ghost.svg", width: 120),
          const SizedBox(height: 16),
          Text(
            S.of(context).pleaseTryAgainLaterWeArenworkingToFixTheIssue,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: Text(S.of(context).retry)),
        ],
      ),
    );
  }
}
