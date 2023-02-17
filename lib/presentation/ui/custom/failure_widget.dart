import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/failure/failure.dart';
import '../../resources/locale/generated/l10n.dart';

class FailureWidget extends StatelessWidget {
  final Failure failure;
  final VoidCallback onRetry;

  const FailureWidget({Key? key, required this.failure, required this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (failure is ConnectionFailure) {
      return ConnectionErrorWidget(onRetry: onRetry);
    } else {
      return UnexpectedErrorWidget(onRetry: onRetry);
    }
  }
}

class ConnectionErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const ConnectionErrorWidget({Key? key, required this.onRetry}) : super(key: key);

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

  const UnexpectedErrorWidget({Key? key, required this.onRetry}) : super(key: key);

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
