import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final bool isLoading;
  final bool disable;
  final String label;
  final void Function()? onPressed;
  final Widget? icon;
  final MaterialStateProperty<Color?>? backgroundColor;
  const CustomButton({
    Key? key,
    this.isLoading = false,
    this.disable = false,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        elevation: MaterialStateProperty.all(2),
        padding: MaterialStateProperty.all(const EdgeInsets.all(14)),
        backgroundColor: disable
            ? MaterialStateProperty.all(Colors.grey)
            : backgroundColor ??
                MaterialStateProperty.all(Theme.of(context).primaryColor),
      ),
      onPressed: onPressed,
      child: AnimatedSwitcher(
        switchOutCurve: Curves.linear,
        switchInCurve: Curves.linear,
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: animation,
          child: child,
        ),
        child: isLoading
            ? const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation(
                      Colors.white,
                    ),
                  ),
                ),
              )
            : icon != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      icon!,
                      const SizedBox(width: 15),
                      Text(
                        label,
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  )
                : Text(
                    label,
                    style: const TextStyle(color: Colors.white),
                  ),
      ),
    );
  }
}
