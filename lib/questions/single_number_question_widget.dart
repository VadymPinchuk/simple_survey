import 'package:flutter/material.dart';
import 'package:simple_survey/models/single_number_survey_question.dart';
import 'package:simple_survey/models/survey_question.dart';

enum QuestionMode { editable, submittable }

class SingleNumberQuestionWidget extends StatefulWidget {
  const SingleNumberQuestionWidget({
    super.key,
    required this.question,
    required this.mode,
  });

  final SurveyQuestion question;
  final QuestionMode mode;

  @override
  State<StatefulWidget> createState() => _SingleNumberQuestionWidgetState();
}

class _SingleNumberQuestionWidgetState
    extends State<SingleNumberQuestionWidget> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.question.title);
    _descriptionController =
        TextEditingController(text: widget.question.description);
    _currentValue = _question.minValue.toDouble();
  }

  SingleNumberSurveyQuestion get _question =>
      widget.question as SingleNumberSurveyQuestion;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Theme.of(context).colorScheme.primaryContainer,
        elevation: 4.0,
        child: _buildCardContent(),
      ),
    );
  }

  Widget _buildCardContent() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          widget.mode == QuestionMode.editable
              ? TextField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                )
              : Text(widget.question.title),
          widget.mode == QuestionMode.editable
              ? TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                )
              : Text(_question.description),
          widget.mode == QuestionMode.editable
              ? RangeSlider(
                  values: RangeValues(_question.minValue.toDouble(),
                      _question.maxValue.toDouble()),
                  min: 0,
                  max: 100,
                  // Assuming 100 is the maximum limit
                  divisions: 100,
                  onChanged: (RangeValues values) {
                    // Handle change
                  },
                )
              : Slider(
                  value: _currentValue,
                  min: _question.minValue.toDouble(),
                  max: _question.maxValue.toDouble(),
                  onChanged: (double value) {
                    setState(() {
                      _currentValue = value;
                    });
                  },
                ),
        ],
      ),
    );
  }
}
