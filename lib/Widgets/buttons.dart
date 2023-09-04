import 'package:flutter/material.dart';

class Buttons extends StatelessWidget {
  Buttons({
    Key? key,
    required this.onPress,
    required this.child,
    required this.height,
    required this.color,
    this.loading = false,
  }) : super(key: key);
  final bool loading;
  Function() onPress;
  Widget child;
  double height;
  Color color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(70, 1, 30, 1),
      child: Card(
        color: color,
        elevation: 20,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onPress,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: color,
            ),
            child: Center(
              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : child,
            ),
          ),
        ),
      ),
    );
  }
}
