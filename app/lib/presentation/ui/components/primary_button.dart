import 'package:app/presentation/resources/resources.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isEnabled;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isEnabled = true,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed:  isLoading || !isEnabled ? null : onPressed,
      child: isLoading
          ? SizedBox(
              width: Dimen.loadingSpinnerSizeS,
              height: Dimen.loadingSpinnerSizeS,
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onPrimary,
                strokeWidth: 2,
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (leadingIcon != null)
                  SizedBox(
                    width: Dimen.loadingSpinnerSizeS,
                    height: Dimen.loadingSpinnerSizeS,
                    child: leadingIcon!,
                  ),
                const Spacer(),
                Text(label),
                const Spacer(),
                if (trailingIcon != null)
                  SizedBox(
                    width: Dimen.loadingSpinnerSizeS,
                    height: Dimen.loadingSpinnerSizeS,
                    child: trailingIcon!,
                  ),
              ],
            ),
    );
  }
}
