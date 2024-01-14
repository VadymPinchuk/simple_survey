import 'package:blur/blur.dart';
import 'package:flutter/material.dart';

class LogoBlur extends StatelessWidget {
  const LogoBlur({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.bottomEnd,
      child: Blur(
        blur: 3,
        blurColor: Theme.of(context).colorScheme.background,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width / 2,
            child: Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: Image.network(url),
            ),
          ),
        ),
      ),
    );
  }
}
