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
    String newText = query('#selectedText').value.replaceAll("\\n","\n");
    
    print("TEXT CHANGED TO " + newText);
    var selectedActor = getSelectedActor();
    if (selectedActor != null) {
      selectedActor.updateAllRenderables({'text':newText});
      updateAnimation();
    }
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
      movieState.updateKeyFrames();
    });
    print("DELETE KEYFRAME");
    movieState.selectedObjectId = null;
  }
  
  int hexToNum(String hex) {
    int val = 0;

    int len = hex.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = hex.codeUnits[i];
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        // A..F
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        // a..f
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw new BadNumberFormatException("Bad hexidecimal value");
      }
    }

    return val;
  }
  
  void bgColorChanged() {
    print("COLOR CHANGED TO " + query('#bgColorInput').value);
    num colorIntensity =
        (hexToNum(query('#bgColorInput').value.substring(1,3)) + 
        hexToNum(query('#bgColorInput').value.substring(3,5)) + 
        hexToNum(query('#bgColorInput').value.substring(5,7)))/3;
    String shadowColor = (colorIntensity>96) ? "black" : "white";
    getSelectedActor().updateAllRenderables({
      'fill':query('#bgColorInput').value,
      'textShadow':(shadowColor + ' 0 0 5px'),
    });
    updateAnimation();
  }
}

