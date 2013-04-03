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
  num keyFrame;
  String easeAfter = "linear";
  bool destroy = false;
}

@observable
class Actor {
  String id;
  
  List<Renderable> keyFrames = [];
}

@observable
class Layer {
  String id;
  bool visible = false;
  bool locked = false;
  List<Actor> actors = [];
  
  Layer() {
  }
}

@observable
class Movie {
  String id;
  int maxFrames = 100;
  String name;
  String musicId;
  List<Layer> layers;
  num frameMs;
  Point size;
  String backgroundColor = "#ffffff";
  
  Movie() {
    name = "My Movie";
    musicId = null;
    layers = [];
    frameMs = 100;
    size = new Point(640,360);
  }
}
Movie movie = new Movie();

@observable
class MovieState {
  num playFrame = 0; // Play frame is for interpolation only.
  int frame = 0;
  var canvas = null;
  var objectIdMap = new Map();
  num padding = 100;
  var guidelines = null;
  String selectedObjectId = "";
  num animationStartTimeMS = 0.0;
  bool playing = false;
  
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

var LOADED_IMAGE = null;
void onDropFn(MouseEvent e) {
  window.console.debug("ON DROP");
  e.stopPropagation(); // Stops some browsers from redirecting.
  e.preventDefault();

  var files = e.dataTransfer.files;
  var f;
  for (var i = 0; (f = files[i]) != null; i++) {
    // Read the File objects in this FileList.
    print('FILE: ${f.size} *** ${f.name} *** $f');
    //window.console.debug("FILE: " + f.size + " *** " + f.name + " *** " + f.toString());
    
    FileReader reader = new FileReader();
    reader.onLoad.listen((var theFile) {
        // Render thumbnail.
        ImageElement img = new ImageElement();
        img.src = reader.result;
        LOADED_IMAGE = reader.result;
        document.query('#droppedImage').children.add(img);
        print('DROPPED IMAGE');
    });

    // Read in the image file as a data URL.
    reader.readAsDataUrl(f);
  }
}
 
