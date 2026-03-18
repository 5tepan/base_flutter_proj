import 'package:base_flutter_proj/core/events/event.dart';
import 'package:talker_flutter/talker_flutter.dart';

class EventBusLogEvent extends TalkerLog {
  final BaseEvent event;

  EventBusLogEvent(this.event)
    : super(
        '${event.sender.runtimeType} отправил ${event.runtimeType} в EventBus',
      );

  @override
  AnsiPen get pen => AnsiPen()..xterm(49);

  @override
  String? get key => 'eventBus';

  @override
  String generateTextMessage({
    TimeFormat timeFormat = TimeFormat.timeAndSeconds,
  }) {
    return '${displayTitleWithTime(timeFormat: timeFormat)} ${event.sender.runtimeType} отправил ${event.runtimeType} в EventBus';
  }
}
