library playcontrols;

import 'dart:html';
import 'html5animator.dart';
import 'package:web_ui/web_ui.dart';


/** Play controls to play, pause, and jump to beginning or end. */
class PlayControlsComponent extends WebComponent {  
  void handlePress() {
    if (movieState.playing) {
      pause();
    } else {
      play();
    }
  }
}
