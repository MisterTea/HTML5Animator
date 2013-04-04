part of html5animator;

void initPalette() {
  var fabric = js.context.fabric;
  
  movieState.frame = 0;

  var layer = new Layer();
  movie.layers.add(layer);

  var actor = new Actor();
  layer.actors.add(actor);

  actor.id = "rect1";

  var renderable = new Renderable();
  actor.keyFrames.add(renderable);

  renderable.fabricJson = '{"type":"rect","originX":"center","originY":"center","left":100,"top":100,"width":100,"height":100,"fill":"red","overlayFill":null,"stroke":null,"strokeWidth":1,"strokeDashArray":null,"scaleX":1,"scaleY":1,"angle":0,"flipX":false,"flipY":false,"opacity":1,"selectable":true,"hasControls":true,"hasBorders":true,"hasRotatingPoint":true,"transparentCorners":true,"perPixelTargetFind":false,"shadow":null,"visible":true,"rx":0,"ry":0}';
  renderable.keyFrame = 0;
  movie.keyFrames.add(0);

  renderable = new Renderable();
  actor.keyFrames.add(renderable);

  renderable.fabricJson = '{"type":"rect","originX":"center","originY":"center","left":200,"top":100,"width":100,"height":100,"fill":"red","overlayFill":null,"stroke":null,"strokeWidth":1,"strokeDashArray":null,"scaleX":1,"scaleY":1,"angle":0,"flipX":false,"flipY":false,"opacity":1,"selectable":true,"hasControls":true,"hasBorders":true,"hasRotatingPoint":true,"transparentCorners":true,"perPixelTargetFind":false,"shadow":null,"visible":true,"rx":0,"ry":0}';
  renderable.keyFrame = 20;
  movie.keyFrames.add(20);

  movieState.canvas = new js.Proxy(fabric.Canvas, "palette");
  js.retain(movieState.canvas);

  // Create guidelines
  movieState.guidelines = new js.Proxy(fabric.Rect, js.map({
    'left' : 320 + 100,
    'top' : 180 + 100,
    'width' : 640,
    'height' : 360,
    'stroke' : 'grey',
    'strokeWidth' : 2,
    'fill' : null,
    'selectable' : false,
    'strokeDashArray' : [10,10]
  }));
  js.retain(movieState.guidelines);
  movieState.canvas.add(movieState.guidelines);
  
  // Create dark borders
  var border;
  border = new js.Proxy(fabric.Rect, js.map({
    'left' : 320 + 100,
    'top' : 50,
    'width' : 640,
    'height' : 100,
    'fill' : '#000000',
    'opacity': 0.5,
    'selectable' : false,
  }));
  js.retain(border);
  movieState.darkBorders.add(border);
  border = new js.Proxy(fabric.Rect, js.map({
    'left' : 50,
    'top' : 280,
    'width' : 100,
    'height' : 560,
    'fill' : '#000000',
    'opacity': 0.5,
    'selectable' : false,
  }));
  js.retain(border);
  movieState.darkBorders.add(border);
  border = new js.Proxy(fabric.Rect, js.map({
    'left' : 50 + 640 + 100,
    'top' : 280,
    'width' : 100,
    'height' : 560,
    'fill' : '#000000',
    'opacity': 0.5,
    'selectable' : false,
  }));
  js.retain(border);
  movieState.darkBorders.add(border);
  border = new js.Proxy(fabric.Rect, js.map({
    'left' : 320 + 100,
    'top' : 50 + 460,
    'width' : 640,
    'height' : 100,
    'fill' : '#000000',
    'opacity': 0.5,
    'selectable' : false,
  }));
  js.retain(border);
  movieState.darkBorders.add(border);

  window.console.debug(movieState.canvas);
  movieState.canvas.on('object:modified', new js.Callback.many(objectModified));

  movieState.canvas.on('object:selected', new js.Callback.many(objectSelected));

  movieState.canvas.on('selection:cleared', new js.Callback.many(selectionCleared));
  
  // Update animation when various movie state changes.
  watcher.watch(() => movieState.frame, (_) => updateAnimation());
  watcher.watch(() => movie.backgroundColor, (_) => updateAnimation());
}

void objectModified(var params) {
    var fabricObject = params.target;
    window.console.debug("MODIFIED");
    window.console.debug(fabricObject);
    var actor = getActorFromId(fabricObject.id);
    window.console.debug(actor);

    upsertKeyFrame(actor, fabricObject, movieState.frame);
}

void objectSelected(var params) {
  var fabricObject = params.target;
  window.console.debug("SELECTED");
  window.console.debug(fabricObject);
  movieState.selectedObjectId = fabricObject.id;
}

void selectionCleared(var params) {
  window.console.debug("UNSELECTED");
  movieState.selectedObjectId = null;
}

void prevFrame() {
  movieState.frame = Math.max(0, movieState.frame - 1);
}

void nextFrame() {
  movieState.frame = Math.min(movie.maxFrames - 1, movieState.frame + 1);
}

void play() {
  movieState.anchorFrame = movieState.frame;
  movieState.animationStartTimeMS = -1.0;
  movieState.playing = true;
  js.scoped(() {
  for (int a=0;a<movieState.darkBorders.length;a++) {
    var border = movieState.darkBorders[a];
    movieState.canvas.add(border);
  }
  movieState.canvas.remove(movieState.guidelines);
  });
  window.requestAnimationFrame(animloop);
}

void pause() {
  if (movieState.playing == false) {
    return;
  }
  movieState.playing = false;
  js.scoped(() {
  for (int a=0;a<movieState.darkBorders.length;a++) {
    var border = movieState.darkBorders[a];
    movieState.canvas.remove(border);
  }
  movieState.canvas.add(movieState.guidelines);
  });
  updateAnimation();
}

void animloop(num highResTime) {
  if (movieState.animationStartTimeMS<0) {
    movieState.animationStartTimeMS = highResTime - 100 * movieState.frame;
  }
  if (movieState.playing == false) {
    print("NOT PLAYING");
    return;
  }
  window.requestAnimationFrame(animloop);

  // Render
  movieState.playFrame = ((highResTime - movieState.animationStartTimeMS) / 100);
  movieState.frame = movieState.playFrame.floor();
  updateAnimation();
  
  if (movieState.frame>movie.lastKeyFrameTime || movieState.frame >= movie.maxFrames) {
    movieState.frame = movieState.anchorFrame;
    pause();
  }
}

void addText() {
  js.scoped(() {
    var fabric = js.context.fabric;
    
  var text = new js.Proxy(fabric.Text, 'Dart Rocks!', {
    'left' : 100,
    'top' : 100,
  });
  js.retain(text);

  var layer = new Layer();
  movie.layers.add(layer);

  var actor = new Actor();
  layer.actors.add(actor);

  actor.id = "text" + randomString();

  var renderable = new Renderable();
  actor.keyFrames.add(renderable);

  renderable.fabricJson = js.context.JSON.stringify(text.toObject());
  print(renderable.fabricJson);
  renderable.keyFrame = movieState.frame;
  // $rootScope.canvas.add(oImg);
  });
  
  updateAnimation();
}

void addImage(String imageUrl, num x, num y) {
  print("ADDING IMAGE "+imageUrl + ".");
  js.scoped(() {
    var fabric = js.context.fabric;
    
    fabric.Image.fromURL(imageUrl, new js.Callback.many((var oImg) {
      print("LOADED IMAGE");
      oImg.left = x-oImg.width / 2;
      oImg.top = y-oImg.height / 2;

      var layer = new Layer();
      movie.layers.add(layer);

      var actor = new Actor();
      layer.actors.add(actor);

      actor.id = "image" + randomString();

      var renderable = new Renderable();
      actor.keyFrames.add(renderable);

      js.scoped(() {
        renderable.fabricJson = js.context.JSON.stringify(oImg.toObject());
      });
      renderable.keyFrame = movieState.frame;
      // $rootScope.canvas.add(oImg);

      updateAnimation();
    }));
  });
}

void addLine() {
  js.scoped(() {
    var fabric = js.context.fabric;
    
  var line = new js.Proxy(fabric.Line, js.array([300,100,500,100]), js.map({
    'strokeWidth': 10,
  }));
  js.retain(line);

  var layer = new Layer();
  movie.layers.add(layer);

  var actor = new Actor();
  layer.actors.add(actor);

  actor.id = "line" + randomString();

  var renderable = new Renderable();
  actor.keyFrames.add(renderable);

  renderable.fabricJson = js.context.JSON.stringify(line.toObject());
  print("ADDED JSON: " + renderable.fabricJson);
  print(renderable.fabricJson);
  renderable.keyFrame = movieState.frame;
  // $rootScope.canvas.add(oImg);
  });
  
  updateAnimation();
}

void addBox() {
  js.scoped(() {
    var fabric = js.context.fabric;
    
  var rect = new js.Proxy(fabric.Rect, js.map({
    'left': 100,
    'top': 100,
    'width': 100,
    'height': 100,
  }));
  js.retain(rect);

  var layer = new Layer();
  movie.layers.add(layer);

  var actor = new Actor();
  layer.actors.add(actor);

  actor.id = "rect" + randomString();

  var renderable = new Renderable();
  actor.keyFrames.add(renderable);

  renderable.fabricJson = js.context.JSON.stringify(rect.toObject());
  print("ADDED JSON: " + renderable.fabricJson);
  print(renderable.fabricJson);
  renderable.keyFrame = movieState.frame;
  // $rootScope.canvas.add(oImg);
  });
  
  updateAnimation();
}

void addEllipse() {
  js.scoped(() {
    var fabric = js.context.fabric;
    
  var rect = new js.Proxy(fabric.Ellipse, js.map({
    'left': 100,
    'top': 100,
    'rx': 100,
    'ry': 100,
  }));
  js.retain(rect);

  var layer = new Layer();
  movie.layers.add(layer);

  var actor = new Actor();
  layer.actors.add(actor);

  actor.id = "ellipse" + randomString();

  var renderable = new Renderable();
  actor.keyFrames.add(renderable);

  renderable.fabricJson = js.context.JSON.stringify(rect.toObject());
  print("ADDED JSON: " + renderable.fabricJson);
  print(renderable.fabricJson);
  renderable.keyFrame = movieState.frame;
  // $rootScope.canvas.add(oImg);
  });
  
  updateAnimation();
}

void addTriangle() {
  js.scoped(() {
    var fabric = js.context.fabric;
    
  var rect = new js.Proxy(fabric.Triangle, js.map({
    'left': 100,
    'top': 100,
    'width': 100,
    'height': 100,
  }));
  js.retain(rect);

  var layer = new Layer();
  movie.layers.add(layer);

  var actor = new Actor();
  layer.actors.add(actor);

  actor.id = "rect" + randomString();

  var renderable = new Renderable();
  actor.keyFrames.add(renderable);

  renderable.fabricJson = js.context.JSON.stringify(rect.toObject());
  print("ADDED JSON: " + renderable.fabricJson);
  print(renderable.fabricJson);
  renderable.keyFrame = movieState.frame;
  // $rootScope.canvas.add(oImg);
  });
  
  updateAnimation();
}

Layer getLayerWithActorId(id) {
  for ( var i = 0; i < movie.layers.length; i++) {
    for ( var j = 0; j < movie.layers[i].actors.length; j++) {
      if (movie.layers[i].actors[j].id == id) {
        return movie.layers[i];
      }
    }
  }
  return null;
}

num getActorIndexWithActorId(id) {
  for ( var i = 0; i < movie.layers.length; i++) {
    for ( var j = 0; j < movie.layers[i].actors.length; j++) {
      if (movie.layers[i].actors[j].id == id) {
        return j;
      }
    }
  }
  return null;
}

Actor getSelectedActor() {
  return getActorFromId(movieState.selectedObjectId);
}

Actor getActorFromId(String id) {
  for ( var i = 0; i < movie.layers.length; i++) {
    for ( var j = 0; j < movie.layers[i].actors.length; j++) {
      if (movie.layers[i].actors[j].id == id) {
        return movie.layers[i].actors[j];
      }
    }
  }
  return null;
}

Renderable upsertKeyFrame(actor, fabricObject, int frame) {
  // TODO(Eric): Deal with keyframe removal.
  movie.keyFrames.add(frame);
  
  movie.lastKeyFrameTime = -1;
  var it = movie.keyFrames.iterator;
  while (it.moveNext()) {
    movie.lastKeyFrameTime = Math.max(movie.lastKeyFrameTime, it.current);
  }

  print("UPDATING " + actor.id);
  
  fabricObject.left -= movieState.padding;
  fabricObject.top -= movieState.padding;
  
  for ( var i = 0; i < actor.keyFrames.length; i++) {
    if (actor.keyFrames[i].keyFrame > frame) {
      var renderable = new Renderable();
      renderable.fabricJson = js.context.JSON.stringify(fabricObject.toObject());
      renderable.keyFrame = frame;
      actor.keyFrames.insert(i, renderable);
      fabricObject.left += movieState.padding;
      fabricObject.top += movieState.padding;
      return renderable;
    } else if (actor.keyFrames[i].keyFrame == frame) {
      print("UPDATING");
      print(actor.keyFrames[i].fabricJson);
      actor.keyFrames[i].fabricJson = js.context.JSON.stringify(fabricObject
          .toObject());
      print("TO");
      print(actor.keyFrames[i].fabricJson);
      fabricObject.left += movieState.padding;
      fabricObject.top += movieState.padding;
      return actor.keyFrames[i];
    } else if (i + 1 == actor.keyFrames.length) {
      var renderable = new Renderable();
      renderable.fabricJson = js.context.JSON.stringify(fabricObject.toObject());
      renderable.keyFrame = frame;
      actor.keyFrames.add(renderable);
      fabricObject.left += movieState.padding;
      fabricObject.top += movieState.padding;
      return renderable;
    }
  }
}

String NEXT_ID = "";
void createFabricObject(serializedObject, id) {
  NEXT_ID = id;
  var fabric = js.context.fabric;
  var serializedObjectJs = js.map(serializedObject);
  window.console.log(serializedObject);
  if (serializedObject['type'] == 'line') {
    print("CREATING LINE WITH JS ");
    print(serializedObject);
    var serializedObjectJs = js.map(serializedObject);
    var fabricObject = js.context.fabric.Line.fromObject(serializedObjectJs);
    fabricObject.perPixelTargetFind = true;
    fabricObject.targetFindTolerance = 4;
    fabricObject._setWidthHeight(serializedObjectJs);
    print(fabricObject);
    js.retain(fabricObject);
    print(fabricObject.left);
    print(movieState.padding);
    fabricObject.left += movieState.padding;
    fabricObject.top += movieState.padding;
    fabricObject.id = id;
    movieState.objectIdMap[id] = fabricObject;
    movieState.canvas.add(fabricObject);
  } else if (serializedObject['type'] == 'rect') {
      var fabricObject = new js.Proxy(fabric.Rect, serializedObjectJs);
      fabricObject.perPixelTargetFind = true;
      fabricObject.targetFindTolerance = 4;
      js.retain(fabricObject);
      fabricObject.left += movieState.padding;
      fabricObject.top += movieState.padding;
      fabricObject.id = id;
      movieState.objectIdMap[id] = fabricObject;
      movieState.canvas.add(fabricObject);
  } else if (serializedObject['type'] == 'ellipse') {
    var fabricObject = new js.Proxy(fabric.Ellipse, serializedObjectJs);
    fabricObject.perPixelTargetFind = true;
    fabricObject.targetFindTolerance = 4;
    js.retain(fabricObject);
    fabricObject.left += movieState.padding;
    fabricObject.top += movieState.padding;
    fabricObject.id = id;
    movieState.objectIdMap[id] = fabricObject;
    movieState.canvas.add(fabricObject);
  } else if (serializedObject['type'] == 'triangle') {
    var fabricObject = new js.Proxy(fabric.Triangle, serializedObjectJs);
    fabricObject.perPixelTargetFind = true;
    fabricObject.targetFindTolerance = 4;
    js.retain(fabricObject);
    fabricObject.left += movieState.padding;
    fabricObject.top += movieState.padding;
    fabricObject.id = id;
    movieState.objectIdMap[id] = fabricObject;
    movieState.canvas.add(fabricObject);
  } else if (serializedObject['type'] == 'text') {
    var fabricObject = fabric.Text.fromObject(serializedObjectJs);
    fabricObject.perPixelTargetFind = true;
    fabricObject.targetFindTolerance = 4;
    js.retain(fabricObject);
    fabricObject.left += movieState.padding;
    fabricObject.top += movieState.padding;
    fabricObject.id = id;
    movieState.objectIdMap[id] = fabricObject;
    movieState.canvas.add(fabricObject);
  } else if (serializedObject['type'] == 'image') {
    // Images must load asynchronously
    fabric.Image.fromObject(serializedObjectJs, new js.Callback.many(fabricImageCreated));
  } else {
    throw "Invalid fabric object type " + serializedObject;
  }
}

void fabricImageCreated(var fabricObject) {
    js.retain(fabricObject);
    fabricObject.perPixelTargetFind = true;
    fabricObject.targetFindTolerance = 4;
    fabricObject.id = NEXT_ID;
    fabricObject.left += movieState.padding;
    fabricObject.top += movieState.padding;
    movieState.objectIdMap[NEXT_ID] = fabricObject;
    movieState.canvas.add(fabricObject);
    updateAnimation();
}

void updateAnimation() {
  print(movie.backgroundColor);
  js.scoped(() {
  // Frame changed, redraw
    if (movieState.playing == false) {
      movieState.playFrame = movieState.frame;
    }
  window.console.debug(movieState.playFrame);

  for ( var actor_i = 0; actor_i < movie.layers.length; actor_i++) {
    for ( var actor_j = 0; actor_j < movie.layers[actor_i].actors.length; actor_j++) {
      var actor = movie.layers[actor_i].actors[actor_j];
      window.console.debug(actor.id);

      var removeObject = true;
      if (actor.keyFrames[0].keyFrame <= movieState.playFrame) {
        removeObject = false;
        var keyFrameBefore = actor.keyFrames.length - 1;
        var keyFrameAfter = -1;
        for ( var i = 0; i < actor.keyFrames.length - 1; i++) {
          if (actor.keyFrames[i].keyFrame <= movieState.playFrame
              && actor.keyFrames[i + 1].keyFrame > movieState.playFrame) {
            keyFrameBefore = i;
            keyFrameAfter = i + 1;
            break;
          }
        }

        if (keyFrameAfter == -1
            && actor.destroyOnLastKeyFrame == true) {
          removeObject = true;
        } else {

          if (!(movieState.objectIdMap.containsKey(actor.id))) {
            if (keyFrameAfter == -1) {
              createFabricObject(
                  JSON.parse(actor.keyFrames[keyFrameBefore].fabricJson),
                  actor.id);
            } else {
              createFabricObject(
                  tween(
                      movieState.playFrame
                          - actor.keyFrames[keyFrameBefore].keyFrame,
                      actor.keyFrames[keyFrameAfter].keyFrame
                          - actor.keyFrames[keyFrameBefore].keyFrame,
                      JSON.parse(actor.keyFrames[keyFrameBefore].fabricJson),
                      JSON.parse(actor.keyFrames[keyFrameAfter].fabricJson),
                      actor.keyFrames[keyFrameBefore].easeAfter),
                  actor.id);
            }

            window.console.debug("ADDING OBJECT");
          } else {
            var fabricObject = movieState.objectIdMap[actor.id];

            // Update the object based on a new tween.
            // TODO: For performance, cache these objects so we don't
            // keep
            // calling parseJSON
            if (keyFrameAfter == -1) {
              fabricObject
                  .set(js.map(JSON.parse(actor.keyFrames[keyFrameBefore].fabricJson)));
            } else {
              fabricObject
                  .set(js.map(tween(
                      movieState.playFrame
                          - actor.keyFrames[keyFrameBefore].keyFrame,
                      actor.keyFrames[keyFrameAfter].keyFrame
                          - actor.keyFrames[keyFrameBefore].keyFrame,
                      JSON.parse(actor.keyFrames[keyFrameBefore].fabricJson),
                      JSON.parse(actor.keyFrames[keyFrameAfter].fabricJson),
                      actor.keyFrames[keyFrameBefore].easeAfter)));
            }
            fabricObject.left += movieState.padding;
            fabricObject.top += movieState.padding;
            fabricObject.setCoords();
          }
        }

      }
      if (removeObject) {
        if (movieState.objectIdMap.containsKey(actor.id)) {
          window.console.debug("REMOVING OBJECT");
          window.console.debug(actor);
          movieState.canvas.remove(movieState.objectIdMap[actor.id]);
          movieState.objectIdMap.remove(actor.id);
        }
      }
    }
  }

  movieState.canvas.backgroundColor = movie.backgroundColor;
  movieState.canvas.renderAll();
  movieState.canvas.calcOffset();
  });
}

void makeGif() {
  js.scoped(() {
  movieState.canvas.setWidth(640);
  movieState.canvas.setHeight(360);
  movieState.padding = 0;
  movieState.canvas.remove(movieState.guidelines);
  });
  updateAnimation();
  //js.scoped(() {
  //var encoder = new js.Proxy(js.context.GIFEncoder);
  var encoder2 = new GIFEncoder();
  //encoder.setRepeat(0); // auto-loop
  //encoder.setDelay(10);
  encoder2.setRepeat(0); // auto-loop
  encoder2.setDelay(5);
  print("***");
  //print(encoder.start());
  print(encoder2.start());
  movieState.playing = true;
  movieState.playFrame = 0;
  for (; movieState.playFrame <= movie.lastKeyFrameTime && movieState.playFrame < movie.maxFrames; movieState.playFrame+=0.5) {
    updateAnimation();
    print("***");
    //print(encoder.addFrameFromId('palette'));
    print(encoder2.addFrameFromId('palette'));
  }
  movieState.playing = false;
  //encoder.finish();
  encoder2.finish();
  document.query('#gifImage').src = 'data:image/gif;base64,'
      + encode64(encoder2.stream().getData());
  js.scoped(() {
  movieState.canvas.add(movieState.guidelines);
  movieState.canvas.setWidth(840);
  movieState.canvas.setHeight(560);
  movieState.padding = 100;
  });
  
  updateAnimation();
}
