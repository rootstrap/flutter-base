import 'package:app/main/init.dart';
import 'package:app/presentation/ui/base/route_observer.dart';
import 'package:common/analytics/abstract/analytics_client.dart';
import 'package:flutter/material.dart';

/// A base class for pages that are tracked for analytics purposes.
/// This class can be extended to implement specific tracking logic
/// for different pages in the application.
/// class HomePage extends TrackedPage {
///  const HomePage({super.key});
///  @override
///  String get trackingName => "home_page";
///  @override
///  Map<String, dynamic>? get trackingProperties => {
///        'userType': 'guest',
///        'origin': 'splash_screen',
///      };
///  @override
///  Widget buildPage(BuildContext context) {
///    return Scaffold(
///      appBar: AppBar(title: const Text("Home")),
///      body: const Center(child: Text("Welcome")),
///    );
///  }
///}
abstract class TrackedPage extends StatefulWidget {
  const TrackedPage({super.key});

  /// The name used for tracking this page.
  String get trackingName;

  /// Automatic Events
  /// Override when needed
  bool get trackOnCreate => true;
  bool get trackOnEnter => true;
  bool get trackOnExit => true;
  bool get trackOnDispose => false;

  /// Extra properties for tracking.
  Map<String, dynamic>? get trackingProperties => null;

  /// Build normal
  Widget buildPage(BuildContext context);

  @override
  State<TrackedPage> createState() => _TrackedPageState();
}

class _TrackedPageState extends State<TrackedPage> with RouteAware {
  ModalRoute? _route;

  AnalyticsClient get analytics => getIt<AnalyticsClient>();

  void _track(String phase) {
    analytics.trackEvent('${widget.trackingName}_$phase',
        properties: widget.trackingProperties);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.trackOnCreate) _track("create");
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _route = ModalRoute.of(context);
    if (_route is PageRoute) {
      routeObserver.subscribe(this, _route as PageRoute);
    }
  }

  @override
  void dispose() {
    if (widget.trackOnDispose) _track("dispose");
    if (_route is PageRoute) {
      routeObserver.unsubscribe(this);
    }
    super.dispose();
  }

  @override
  void didPush() {
    if (widget.trackOnEnter) _track("enter");
  }

  @override
  void didPopNext() {
    if (widget.trackOnEnter) _track("enter");
  }

  @override
  void didPushNext() {
    if (widget.trackOnExit) _track("exit");
  }

  @override
  void didPop() {
    if (widget.trackOnExit) _track("exit");
  }

  @override
  Widget build(BuildContext context) {
    return widget.buildPage(context);
  }
}
