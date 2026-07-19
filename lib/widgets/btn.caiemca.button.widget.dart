import 'package:caiemca_app/settings.dart';
import 'package:flutter/material.dart';

class CaiemcaButtonWidget extends StatelessWidget {
  final String title;
  bool dangerButton;
  final VoidCallback? onPressed;
  CaiemcaButtonWidget({
    super.key,
    this.title = 'ACCION',
    this.dangerButton = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        elevation: dangerButton
            ? WidgetStatePropertyAll(0)
            : WidgetStatePropertyAll(1),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            side: dangerButton
                ? BorderSide(
                    color: Theme.of(context).colorScheme.error,
                    width: 1.5,
                  )
                : BorderSide.none,
            borderRadius: BorderRadiusGeometry.circular(kBorderRadius),
          ),
        ),
        backgroundColor: WidgetStatePropertyAll(
          dangerButton ? Colors.transparent : kPrimaryColor,
        ),
      ),
      child: Text(
        title,
        softWrap: false,
        style: TextStyle(
          color: dangerButton
              ? Theme.of(context).colorScheme.error
              : Colors.white,
        ),
      ),
    );
  }
}
