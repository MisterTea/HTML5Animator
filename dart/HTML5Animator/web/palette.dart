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

  renderable = new Renderable();
  actor.keyFrames.add(renderable);

  renderable.fabricJson = '{"type":"rect","originX":"center","originY":"center","left":200,"top":100,"width":100,"height":100,"fill":"red","overlayFill":null,"stroke":null,"strokeWidth":1,"strokeDashArray":null,"scaleX":1,"scaleY":1,"angle":0,"flipX":false,"flipY":false,"opacity":1,"selectable":true,"hasControls":true,"hasBorders":true,"hasRotatingPoint":true,"transparentCorners":true,"perPixelTargetFind":false,"shadow":null,"visible":true,"rx":0,"ry":0}';
  renderable.keyFrame = 20;

  movieState.canvas = new js.Proxy(fabric.Canvas, "palette");
  js.retain(movieState.canvas);

  // Create guidelines
  movieState.guidelines = new js.Proxy(fabric.Rect, {
    'left' : 320 + 100,
    'top' : 180 + 100,
    'width' : 640,
    'height' : 360,
    'stroke' : 'grey',
    'strokeWidth' : 2,
    'fill' : null,
    'selectable' : false,
  });
  js.retain(movieState.guidelines);
  movieState.canvas.add(movieState.guidelines);

  window.console.debug(movieState.canvas);
  movieState.canvas.on('object:modified', new js.Callback.many(objectModified));

  movieState.canvas.on('object:selected', new js.Callback.many(objectSelected));

  movieState.canvas.on('selection:cleared', new js.Callback.many(selectionCleared));
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

void selectionCleared() {
  window.console.debug("UNSELECTED");
  movieState.selectedObjectId = null;
}

void prevFrame() {
  movieState.frame = Math.max(0, movieState.frame - 1);
  updateAnimation();
}

void nextFrame() {
  movieState.frame = Math.min(movieState.maxFrames - 1, movieState.frame + 1);
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

Actor getActorFromId(id) {
  for ( var i = 0; i < movie.layers.length; i++) {
    for ( var j = 0; j < movie.layers[i].actors.length; j++) {
      if (movie.layers[i].actors[j].id == id) {
        return movie.layers[i].actors[j];
      }
    }
  }
  return null;
}

Renderable upsertKeyFrame(actor, fabricObject, frame) {
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
      actor.keyFrames[i].fabricJson = js.context.JSON.stringify(fabricObject
          .toObject());
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

void createFabricObject(serializedObject, id) {
  var fabric = js.context.fabric;
  var serializedObjectJs = js.map(serializedObject);
  window.console.log(serializedObject);
  if (serializedObject['type'] == 'line') {
    var fabricObject = fabric.Line.fromObject(serializedObject);
    js.retain(fabricObject);
    fabricObject.left += movieState.padding;
    fabricObject.top += movieState.padding;
    fabricObject.id = id;
    movieState.objectIdMap[id] = fabricObject;
    movieState.canvas.add(fabricObject);
  } else if (serializedObject['type'] == 'rect') {
      var fabricObject = new js.Proxy(fabric.Rect, serializedObjectJs);
      js.retain(fabricObject);
      fabricObject.left += movieState.padding;
      fabricObject.top += movieState.padding;
      fabricObject.id = id;
      movieState.objectIdMap[id] = fabricObject;
      movieState.canvas.add(fabricObject);
  } else if (serializedObject['type'] == 'text') {
    var fabricObject = fabric.Text.fromObject(serializedObjectJs);
    js.retain(fabricObject);
    fabricObject.left += movieState.padding;
    fabricObject.top += movieState.padding;
    fabricObject.id = id;
    movieState.objectIdMap[id] = fabricObject;
    movieState.canvas.add(fabricObject);
  } else if (serializedObject['type'] == 'image') {
    // Images must load asynchronously
    fabric.Image.fromObject(serializedObjectJs, (fabricObject) {
      js.retain(fabricObject);
      fabricObject.id = id;
      fabricObject.left += movieState.padding;
      fabricObject.top += movieState.padding;
      movieState.objectIdMap[id] = fabricObject;
      movieState.canvas.add(fabricObject);
      updateAnimation();
    });
  } else {
    throw "Invalid fabric object type " + serializedObject;
  }
}

void updateAnimation() {
  js.scoped(() {
  // Frame changed, redraw
  window.console.debug(movieState.frame);

  for ( var actor_i = 0; actor_i < movie.layers.length; actor_i++) {
    for ( var actor_j = 0; actor_j < movie.layers[actor_i].actors.length; actor_j++) {
      var actor = movie.layers[actor_i].actors[actor_j];
      window.console.debug(actor);

      var removeObject = true;
      if (actor.keyFrames[0].keyFrame <= movieState.frame) {
        removeObject = false;
        var keyFrameBefore = actor.keyFrames.length - 1;
        var keyFrameAfter = -1;
        for ( var i = 0; i < actor.keyFrames.length - 1; i++) {
          if (actor.keyFrames[i].keyFrame <= movieState.frame
              && actor.keyFrames[i + 1].keyFrame > movieState.frame) {
            keyFrameBefore = i;
            keyFrameAfter = i + 1;
            break;
          }
        }

        if (keyFrameAfter == -1
            && actor.keyFrames[keyFrameBefore].destroy == true) {
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
                      movieState.frame
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

            window.console.debug("UPDATING OBJECT");
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
                      movieState.frame
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

  movieState.canvas.renderAll();
  movieState.canvas.calcOffset();
  });
}
