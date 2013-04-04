library editobject;

import 'dart:html';
import 'dart:math' as math;
import 'dart:json' as JSON;
import 'html5animator.dart';
import 'package:web_ui/watcher.dart' as watcher;
import 'package:web_ui/web_ui.dart';
import 'package:js/js.dart' as js;

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
    var v = JSON.parse(fabricJson);
    if (v.containsKey('text')) {
      element.value = v['text'];
    }
    print("UPDATING");
    print(v.containsKey('fill'));
    if (v.containsKey('fill')) {
      print(v['fill']);
      query('#bgColorInput').value = v['fill'];
    }
  }
  
  void selectedTextChanged(Event e) {
    print("TEXT CHANGED TO " + query('#selectedText').value);
    getSelectedActor().updateAllRenderables({'text':query('#selectedText').value});
    updateAnimation();
  }
  
  void eraseObject() {
    js.scoped(() {
    upsertKeyFrame(getSelectedActor(), movieState.objectIdMap[movieState.selectedObjectId], movieState.frame);
    getSelectedActor().destroyOnLastKeyFrame = !(getSelectedActor().destroyOnLastKeyFrame);
    });
  }

  void deleteObject() {
    js.scoped(() {
      movie.deleteActor(getSelectedActor());
    });
    print("DELETE OBJECT");
    movieState.selectedObjectId = null;
  }
  
  void deleteKeyFrame() {
    js.scoped(() {
      getSelectedActor().deleteKeyFrame(movieState.frame);
      movie.updateKeyFrames();
    });
    print("DELETE KEYFRAME");
    movieState.selectedObjectId = null;
  }
  
  void bgColorChanged() {
    print("COLOR CHANGED TO " + query('#bgColorInput').value);
    getSelectedActor().updateAllRenderables({'fill':query('#bgColorInput').value});
    updateAnimation();
  }
}

