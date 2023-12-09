import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_survey/router.dart';

class VoteScreen extends StatefulWidget {
  const VoteScreen({super.key});

  @override
  State<StatefulWidget> createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen> {
  String dropdownValue = 'Option 1';
  double sliderValue1 = 10;
  double sliderValue2 = 20;
  double sliderValue3 = 30;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave your vote'),
        actions: [
          if (!kIsWeb)
            IconButton(
              onPressed: () => context.goNamed(Routes.chart.name),
              icon: const Icon(Icons.bar_chart),
            )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Виберіть презентера із списку',
                style: theme.textTheme.titleLarge,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: DropdownMenu<String>(
                  initialSelection: 'Option 1',
                  onSelected: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                  dropdownMenuEntries: <String>[
                    'Option 1',
                    'Option 2',
                    'Option 3',
                    'Option 4'
                  ].map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(
                      value: value,
                      label: value,
                    );
                  }).toList(),
                ),
              ),
              Text(
                'Оцініть ідею',
                style: theme.textTheme.titleMedium,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Slider(
                  value: sliderValue1,
                  min: 10,
                  max: 30,
                  divisions: 20,
                  label: sliderValue1.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      sliderValue1 = value;
                    });
                  },
                ),
              ),
              Text(
                'Оцініть презентацію',
                style: theme.textTheme.titleMedium,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Slider(
                  value: sliderValue2,
                  min: 10,
                  max: 30,
                  divisions: 20,
                  label: sliderValue2.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      sliderValue2 = value;
                    });
                  },
                ),
              ),
              Text(
                'Оцініть реалізацію',
                style: theme.textTheme.titleMedium,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Slider(
                  value: sliderValue3,
                  min: 10,
                  max: 30,
                  divisions: 20,
                  label: sliderValue3.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      sliderValue3 = value;
                    });
                  },
                ),
              ),
              Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    minimumSize: const Size(88, 48),
                    padding: const EdgeInsets.all(16.0),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                  ),
                  onPressed: () {},
                  child: Text('Відправити оцінку'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
