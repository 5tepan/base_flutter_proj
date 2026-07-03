import 'package:base_flutter_proj/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

Future<DateTime?> showYearPicker({
  required BuildContext context,
  required DateTime lastDate,
  required DateTime selectedDate,
  required DateTime firstDate,
  DateTime? initialDate,
  String? titleText,
  TransitionBuilder? builder,
  bool useRootNavigator = true,
}) async {
  final Widget dialog = YearPickerDialog(
    initialDate: initialDate,
    selectedDate: selectedDate,
    titleText: titleText,
    lastDate: lastDate,
    firstDate: firstDate,
  );
  return showDialog<DateTime>(
    context: context,
    useRootNavigator: useRootNavigator,
    builder: (BuildContext context) {
      return builder == null ? dialog : builder(context, dialog);
    },
  );
}

class YearPickerDialog extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime selectedDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final String? titleText;

  const YearPickerDialog({
    required this.selectedDate,
    required this.firstDate,
    required this.lastDate,
    super.key,
    this.initialDate,
    this.titleText,
  });

  @override
  State<YearPickerDialog> createState() => _YearPickerDialogState();
}

class _YearPickerDialogState extends State<YearPickerDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 400,
        child: Column(
          children: [
            buildTitle(),
            Expanded(
              child: YearPicker(
                firstDate: widget.firstDate,
                lastDate: widget.lastDate,
                selectedDate: widget.selectedDate,
                dragStartBehavior: DragStartBehavior.down,
                onChanged: (date) {
                  Navigator.of(context).pop(date);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTitle() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(widget.titleText ?? S.of(context).dateTimeSelectYear),
          ),
        ),
        CupertinoButton(
          minimumSize: const Size(16, 16),
          onPressed: () => Navigator.of(context).pop(),
          child: const Icon(Icons.close),
        ),
      ],
    );
  }
}
