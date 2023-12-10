import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:simple_survey/chart/chart_provider.dart';
import 'package:simple_survey/data/student.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  @override
  void didChangeDependencies() {
    context.read<ChartProvider>().requestStudents();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.chart_screen_title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Stack(
          children: [
            Column(
              children: [
                const Spacer(),
                _levelsBack(40 * 2, Colors.greenAccent.withOpacity(0.3)),
                _levelsBack(40 * 2, Colors.yellowAccent.withOpacity(0.2)),
                _levelsBack(120 * 2, Colors.orange.withOpacity(0.1)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: _levelsBack(40, Colors.white.withOpacity(0.1)),
                ),
              ],
            ),
            Selector<ChartProvider, List<Student>>(
              selector: (_, provider) => provider.students,
              builder: (context, list, __) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: list.map((student) => _singleBar(student)).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _levelsBack(double height, Color color) {
    return ColoredBox(
      color: color,
      child: SizedBox(
        height: height,
        width: double.infinity,
      ),
    );
  }

  Widget _singleBar(Student student) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Expanded(
      child: StreamBuilder<double>(
        stream: context.read<ChartProvider>().getStudentScoreStream(student.id),
        builder: (context, snapshot) {
          double newScore = student.score + (snapshot.data ?? 0);
          return Column(
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(4.0),
                  ),
                  child: ColoredBox(
                    color: scheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        '${newScore.round()}',
                        style: theme.textTheme.titleMedium!
                            .copyWith(color: scheme.onPrimaryContainer),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: AnimatedContainer(
                  // Use AnimatedContainer
                  duration: const Duration(milliseconds: 300),
                  // Animation duration
                  curve: Curves.fastOutSlowIn,
                  // Animation curve
                  width: 50.0,
                  // Fixed width
                  height: newScore * 2,
                  // Animated height
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    context.read<ChartProvider>().createInitials(student.name),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
