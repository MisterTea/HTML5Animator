library html5animator;

import 'dart:async';
import 'dart:html';
import 'dart:math' as Math;
import 'dart:json' as JSON;
import 'package:web_ui/web_ui.dart';
import 'package:web_ui/watcher.dart' as watcher;
import 'package:js/js.dart' as js;

import 'imagePalette.dart';

part "b64.dart";
part "GIFEncoder.dart";
part "LZWEncoder.dart";
part "NeuQuant.dart";

part "util.dart";

part "tween.dart";
part "palette.dart";

@observable
class Renderable {
  String fabricJson;
  int keyFrame;
  String easeAfter = "linear";
  
  void update(Map updates) {
    print("CHANGING " + fabricJson);
    var current = JSON.parse(fabricJson);
    for (String key in updates.keys) {
      current[key] = updates[key];
    }
    fabricJson = JSON.stringify(current);
    print("CHANGING TO " + fabricJson);
  }
}

@observable
class Actor {
  String id;
  bool destroyOnLastKeyFrame = false;
  
  List<Renderable> keyFrames = [];
  
  void updateAllRenderables(Map updates) {
    print("UPDATING ALL KEYFRAMES");
    for (int i = 0; i < keyFrames.length; i++) {
      keyFrames[i].update(updates);
    }
  }
  
  void deleteKeyFrame(int frame) {
    for (Renderable keyFrame in keyFrames) {
      if (keyFrame.keyFrame == frame) {
        keyFrames.remove(keyFrame);
        break;
      }
    }
    updateAnimation();
  }
}

@observable
class Layer {
  String id;
  bool visible = false;
  bool locked = false;
  List<Actor> actors = [];
  
  Layer() {
  }
  
  void deleteActor(Actor actor) {
    actors.remove(actor);
  }
}

@observable
class Movie {
  String id;
  int maxFrames = 2100;
  int lastKeyFrameTime = 20; //TODO: This is becuse we put a rect with keyframe 20 at startup.
  Set<int> keyFrames = toObservable(new Set());
  String name = "My Movie";
  String musicId = null;
  List<Layer> layers = [];
  num frameMs = 100;
  Point size = new Point(640, 360);  
  String backgroundColor = '#ffffff';
  var audioSrc = null;
  
  void deleteActor(Actor actor) {
    for(Layer l in layers) {
      l.deleteActor(actor);
    }
    if (movieState.objectIdMap.containsKey(actor.id)) {
      window.console.debug("REMOVING OBJECT");
      window.console.debug(actor);
      movieState.canvas.remove(movieState.objectIdMap[actor.id]);
      movieState.objectIdMap.remove(actor.id);
    }
    updateKeyFrames();
    updateAnimation();
  }
  
  void updateKeyFrames() {
    keyFrames.clear();
    lastKeyFrameTime = -1;
    for (Layer l in layers) {
      for (Actor a in l.actors) {
        for (Renderable r in a.keyFrames) {
          keyFrames.add(r.keyFrame);
          lastKeyFrameTime = Math.max(lastKeyFrameTime, r.keyFrame);
        }
      }
    }
  }
}
Movie movie = new Movie();

@observable
class MovieState {
  num playFrame = 0; // Play frame is for interpolation only.
  int anchorFrame = 0;  // Frame that movie returns to after playing.
  int frame = 0;
  var canvas = null;
  var objectIdMap = new Map();
  num padding = 100;
  var guidelines = null;
  String selectedObjectId = null;
  num animationStartTimeMS = 0.0;
  bool playing = false;
  List<dynamic> darkBorders = [];
  bool selectable = true;
  
  MovieState() {
  }
}
MovieState movieState = new MovieState();
String currentTime;
  
/**
 * Learn about the Web UI package by visiting
 * http://www.dartlang.org/articles/dart-web-components/.
 */
void main() {
  print("HASH");
  print(window.location.hash);
  if (window.location.hash.length == 0) {
    window.location.hash = randomString();
  }
  movie.id = window.location.hash;
  
  js.scoped(() {
  window.console.debug('LOG');
  // Enable this to use Shadow DOM in the browser.
  //useShadowDom = true;
  
  /*
  var div = document.query('#content');
  HttpRequest.getString("partials/edit.html").then(
      (responseText) {
    div.children.add(new Element.html(responseText));
    watcher.dispatch();
  });
  */
  
  currentTime = "asdfasdf";
  window.console.debug(currentTime);
  
  initPalette();
  });
  
  window.onDrop.listen(onDropFn);
  
  window.onDragOver.listen(onDragOverFn);
  updateAnimation();
}

void onDragOverFn(MouseEvent e) {
    e.stopPropagation();
    e.preventDefault();
    e.dataTransfer.dropEffect = 'copy'; // Explicitly show this is a copy.
}

void onDropFn(MouseEvent e) {
  window.console.debug("ON DROP");
  e.stopPropagation(); // Stops some browsers from redirecting.
  e.preventDefault();

  var files = e.dataTransfer.files;
  File f;
  
  var imageUri = e.dataTransfer.getData("text/uri-list");
  if (imageUri != null && imageUri.length > 1){
    addImage(imageUri,e.clientX, e.clientY);
  } else{
   for (var i = 0; (f = files[i]) != null; i++) {
    // Read the File objects in this FileList.
    print('FILE: ${f.size} *** ${f.name} *** $f');
    //window.console.debug("FILE: " + f.size + " *** " + f.name + " *** " + f.toString());
    
    FileReader reader = new FileReader();
    if (f.name.endsWith("\.mp3") || f.name.endsWith("\.wav") || f.name.endsWith("\.ogg")) {
      reader.onLoad.listen((var theFile) {
        AudioElement bgMusicElement = document.query("#BGMusic");
        bgMusicElement.src = reader.result;
        movie.audioSrc = reader.result;
      });
    } else {
      reader.onLoad.listen((var theFile) {
          addImageToPalette(reader.result);
      });
    }
    // Read in the image file as a data URL.
    reader.readAsDataUrl(f);
  }
 }
}
 
