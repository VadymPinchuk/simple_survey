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
                _levelsBack(40 * 2, Colors.greenAccent.withOpacity(0.2)),
                _levelsBack(40 * 2, Colors.yellowAccent.withOpacity(0.1)),
                _levelsBack(120 * 2, Colors.orange.withOpacity(0.05)),
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
          double newScore = snapshot.data ?? 0;
          double total = student.score + newScore;
          return Column(
            children: [
              const Spacer(),
              // total text
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24.0),
                  child: ColoredBox(
                    color: scheme.tertiaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        '${total.round()}',
                        style: theme.textTheme.titleMedium!.copyWith(
                          color: scheme.onTertiaryContainer,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // current score
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
                  height: newScore.round() * 2,
                  // Animated height
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Align(
                    alignment: AlignmentDirectional.topCenter,
                    child: Center(
                      child: Text(
                        newScore.round().toString(),
                        style: theme.textTheme.titleSmall!.copyWith(
                          color: scheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // small gap between points
              const SizedBox(height: 2),
              // points till now
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: ColoredBox(
                    color: scheme.primary,
                    child: SizedBox(
                      height: student.score * 2,
                      width: 50.0,
                      child: Align(
                        alignment: AlignmentDirectional.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            student.score.toString(),
                            style: theme.textTheme.titleSmall!.copyWith(
                              color: scheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(student.getInitials()),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
