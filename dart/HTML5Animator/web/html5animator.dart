library html5animator;

import 'dart:html';
import 'dart:math' as Math;
import 'dart:json' as JSON;
import 'package:web_ui/web_ui.dart';
import 'package:web_ui/watcher.dart' as watchers;
import 'package:js/js.dart' as js;

part "GIFEncoder.dart";
part "LZWEncoder.dart";
part "NeuQuant.dart";

part "util.dart";
part "tween.dart";
part "palette.dart";

class Point {
  num x;
  num y;
  
  Point(num x, num y) {
    this.x = x;
    this.y = y;
  }
}

class Renderable {
  String fabricJson;
  num keyFrame;
  String easeAfter = "linear";
  bool destroy = false;
}

class Actor {
  String id;
  
  List<Renderable> keyFrames = [];
}

class Layer {
  String id;
  bool visible = false;
  bool locked = false;
  List<Actor> actors = [];
  
  Layer() {
  }
}

class Movie {
  String id;
  String name;
  String musicId;
  List<Layer> layers;
  num frameMs;
  Point size;
  
  Movie() {
    id = "movie1";
    name = "My Movie";
    musicId = null;
    layers = [];
    frameMs = 100;
    size = new Point(640,360);
  }
}
Movie movie = new Movie();

class MovieState {
  num frame = 0;
  num maxFrames = 100;
  var canvas = null;
  var objectIdMap = new Map();
  num padding = 100;
  var guidelines = null;
  String selectedObjectId = "";
  
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
  js.scoped(() {
  window.console.debug('LOG');
  // Enable this to use Shadow DOM in the browser.
  //useShadowDom = true;
  
  /*
  var div = document.query('#content');
  HttpRequest.getString("partials/edit.html").then(
      (responseText) {
    div.children.add(new Element.html(responseText));
    watchers.dispatch();
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
        document.query('#droppedImage').children.add(img);
        print('DROPPED IMAGE');
    });

    // Read in the image file as a data URL.
    reader.readAsDataUrl(f);
  }
}
