import 'package:base_flutter_proj/core/events/event.dart';

class ApplicationPausedEvent extends BaseEvent {
  const ApplicationPausedEvent(super.sender);
}

class ApplicationResumeEvent extends BaseEvent {
  const ApplicationResumeEvent(super.sender);
}

class ReloadApplication extends BaseEvent {
  const ReloadApplication(super.sender);
}

class NetworkConnectionRestored extends BaseEvent {
  const NetworkConnectionRestored(super.sender);
}

class NetworkConnectionSwitch extends BaseEvent {
  const NetworkConnectionSwitch(super.sender);
}

class LostNetworkConnection extends BaseEvent {
  const LostNetworkConnection(super.sender);
}
