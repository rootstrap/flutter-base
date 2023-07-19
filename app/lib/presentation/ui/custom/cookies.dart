import 'package:app/main/init.dart';
import 'package:domain/repositories/common_repository.dart';
import 'package:flutter/material.dart';
import 'package:common/devices/platform/abstract/platform_info.dart';
import 'package:app/presentation/resources/locale/generated/l10n.dart';
import 'package:app/presentation/resources/resources.dart';

class Cookies extends StatefulWidget {
  final Widget child;
  final Widget? cookiesChild;
  final Alignment alignment;

  const Cookies({
    super.key,
    required this.child,
    this.cookiesChild,
    this.alignment = Alignment.bottomCenter,
  });

  @override
  State<StatefulWidget> createState() => _CookiesState();
}

class _CookiesState extends State<Cookies> {
  PlatformInfo get _platformInfo => getIt();

  CommonRepository get _commonRepo => getIt();
  bool _needsCookies = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _needsCookies = !_commonRepo.areCookiesAllowed();
    });
  }

  void _confirmCookies() {
    _commonRepo.setAcceptCookies(true);
    setState(() {
      _needsCookies = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _platformInfo.isWeb && _needsCookies
        ? Stack(
            children: [
              widget.child,
              Align(
                alignment: widget.alignment,
                child: widget.cookiesChild ??
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width,
                      ),
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.all(spacing.s),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).cookiesTitle,
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                              SizedBox(height: spacing.s),
                              SelectableText(
                                S.of(context).cookiesBody,
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                              SizedBox(height: spacing.s),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () => _confirmCookies(),
                                  child: Text(S.of(context).cookiesAcceptCTA),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              ),
            ],
          )
        : widget.child;
  }
}
