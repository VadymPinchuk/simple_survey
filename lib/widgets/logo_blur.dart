import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:simple_survey/data/firebase_client.dart';

class LogoBlur extends StatelessWidget {
  const LogoBlur({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseClient.getImage(name),
      builder: (_, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox.shrink();
        }
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
                  child: Image.memory(snapshot.data!),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
