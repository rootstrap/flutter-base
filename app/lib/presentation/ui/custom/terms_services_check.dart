import 'package:app/presentation/resources/locale/generated/l10n.dart';
import 'package:app/presentation/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TermsServicesCheck extends StatelessWidget {
  final bool agreeToTerms;
  final void Function(bool)? onChanged;

  const TermsServicesCheck({
    super.key,
    this.agreeToTerms = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: Theme.of(context).textButtonTheme.style?.copyWith(
              alignment: Alignment.centerLeft, // <-- important
              padding: WidgetStateProperty.all(
                EdgeInsets.zero,
              ), // optional, but helps
            ),
        onPressed: () => onChanged?.call(!agreeToTerms),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
              value: agreeToTerms,
              onChanged: (value) => onChanged?.call(value ?? false),
            ),
            Expanded(
              child: Text(
                S.of(context).labelAgreeToTerms,
                style: Theme.of(context).textTheme.titleSmall,
                maxLines: 2,
                textAlign: TextAlign.start,
              ),
            ),
            const Gap(Dimen.spacingS),
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(S.of(context).hintTermsAndConditions),
                  ),
                );
              },
              icon: const Icon(Icons.info),
            ),
          ],
        ),
      ),
    );
  }
}
