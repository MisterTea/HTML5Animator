import 'package:web_ui/web_ui.dart';

/** Timeline to navigate between frames and show keyframes. */
class TimelineComponent extends WebComponent {
  String message = 'Hello, world!';

  void toggleMessage() {
    if (message == 'Hello, world!') {
      message = 'Goodbye, world...';
    } else {
      message = 'Hello, world!';
    }
  }
}
