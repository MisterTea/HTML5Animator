library editobject;

import 'dart:html';
import 'dart:math' as math;
import 'dart:json' as JSON;
import 'html5animator.dart';
import 'package:web_ui/watcher.dart' as watcher;
import 'package:web_ui/web_ui.dart';

class EditObjectComponent extends WebComponent {
  /** Called once this component enters the DOM. */
  void inserted() {
    watcher.watch(() => movieState.selectedObjectId, (_) => update());
  }
  
  void update() {
    if (movieState.selectedObjectId == null) {
      return;
    }
    String fabricJson = getSelectedActor().keyFrames[0].fabricJson;
    InputElement element = query('#selectedText');
    element.value = JSON.parse(fabricJson)['text'];
  }
  
  void selectedTextChanged(Event e) {
    print("TEXT CHANGED TO " + query('#selectedText').value);
    getSelectedActor().updateAllRenderables({'text':query('#selectedText').value});
    updateAnimation();
  }
}

