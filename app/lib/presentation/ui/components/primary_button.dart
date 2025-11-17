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
  }) : assert(
          leadingIcon == null || trailingIcon == null,
          'Only one of leadingIcon or trailingIcon can be provided',
        );

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
            minimumSize: WidgetStateProperty.all<Size>(
              const Size(
                double.infinity,
                Dimen.buttonHeightM,
              ),
            ),
          ),
      onPressed: isLoading || !isEnabled ? null : onPressed,
      icon: leadingIcon ?? trailingIcon ?? const SizedBox.shrink(),
      iconAlignment: leadingIcon != null
          ? IconAlignment.start
          : trailingIcon != null
              ? IconAlignment.end
              : null,
      label: isLoading
          ? SizedBox(
              width: Dimen.loadingSpinnerSizeS,
              height: Dimen.loadingSpinnerSizeS,
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onPrimary,
                strokeWidth: 2,
              ),
            )
          : Text(label),
    );
  }
}
