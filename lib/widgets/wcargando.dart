import 'package:flutter/material.dart';

class WCargando extends StatelessWidget {
  const WCargando({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
      ],
    ));
  }
}
