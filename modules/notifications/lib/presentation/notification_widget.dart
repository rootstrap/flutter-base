import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_rounded_progress_bar/flutter_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:notifications/presentation/resources/resources.dart';
import 'package:notifications/service/notification_service.dart';
import 'package:notifications/utils/notification_constants.dart';

class NotificationWidget extends StatefulWidget {
  final VoidCallback? onClose;
  final String message;
  final TextStyle? style;
  final NotificationStatus status;
  final double? maxWidth;
  final Color progressBarColor;
  final Color? progressBarBorderColor;
  final Color? progressBarBackgroundColor;

  const NotificationWidget({
    super.key,
    required this.onClose,
    required this.message,
    required this.style,
    this.status = NotificationStatus.idle,
    this.maxWidth,
    required this.progressBarColor,
    this.progressBarBorderColor,
    this.progressBarBackgroundColor,
  });

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController progressController;
  late Animation<double> animation;
  late Animation<Color> colorAnimation;
  late CurvedAnimation curve;
  final Future countDown = Future.delayed(
    NotificationConstants.toastDurationInMilliseconds.milliseconds,
  );

  @override
  void initState() {
    super.initState();

    progressController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1,
      ),
    );

    curve = CurvedAnimation(
      parent: progressController,
      curve: Curves.linear,
    );

    animation = Tween<double>(begin: 100, end: 0).animate(curve)
      ..addListener(() {
        setState(() {});
      });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      progressController.forward();
      _closeToast();
    });
  }

  void _closeToast() async {
    await countDown;
    if (mounted) {
      widget.onClose?.call();
    }
  }

  @override
  void dispose() {
    progressController.dispose();
    countDown.ignore();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: widget.maxWidth ?? double.infinity,
      ),
      child: Card(
        elevation: 5.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: NotificationConstants.closeToastButtonPadding,
                      right: NotificationConstants.closeToastButtonPadding,
                    ),
                    child: InkWell(
                      onTap: widget.onClose,
                      child: const Icon(Icons.close),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: spacing.m,
                      horizontal: spacing.s,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Change according of project needs
                        switch (widget.status) {
                          NotificationStatus.idle => const SizedBox.shrink(),
                          NotificationStatus.information =>
                            const Icon(Icons.info_outline),
                          NotificationStatus.success =>
                            const Icon(Icons.check_circle_outline),
                          NotificationStatus.error =>
                            const Icon(Icons.error_outline),
                        },
                        SizedBox(width: spacing.xs),
                        Expanded(
                          child: Text(
                            widget.message,
                            style: widget.style,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            RoundedProgressBar(
              milliseconds: NotificationConstants.toastDurationInMilliseconds,
              height: NotificationConstants.roundedProgressBarHeight,
              borderRadius: const BorderRadius.all(
                Radius.circular(
                  NotificationConstants.progressBarRadius,
                ),
              ),
              style: RoundedProgressBarStyle(
                borderWidth: spacing.xxs,
                widthShadow: 0,
                colorBorder:
                    widget.progressBarBorderColor ?? Colors.transparent,
                colorProgress: widget.progressBarColor,
                backgroundProgress:
                    widget.progressBarBackgroundColor ?? Colors.transparent,
              ),
              percent: animation.value,
            ),
          ],
        ),
      ),
    );
  }
}
