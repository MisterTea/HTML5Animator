function getLayerWithActorId(id) {
  for ( var i = 0; i < globals.movie.layers.length; i++) {
    for ( var j = 0; j < globals.movie.layers[i].actors.length; j++) {
      if (globals.movie.layers[i].actors[j].id == id) {
        return globals.movie.layers[i];
      }
    }
  }
  return null;
};

function getActorIndexWithActorId(id) {
  for ( var i = 0; i < globals.movie.layers.length; i++) {
    for ( var j = 0; j < globals.movie.layers[i].actors.length; j++) {
      if (globals.movie.layers[i].actors[j].id == id) {
        return j;
      }
    }
  }
  return null;
};

function getActorFromId(id) {
  for ( var i = 0; i < globals.movie.layers.length; i++) {
    for ( var j = 0; j < globals.movie.layers[i].actors.length; j++) {
      if (globals.movie.layers[i].actors[j].id == id) {
        return globals.movie.layers[i].actors[j];
      }
    }
  }
  return null;
};

function updateAllRenderables(id, updates) {
  var actor = getActorFromId(id);
  for (var i = 0; i < actor.keyFrameRenderables.length; i++) {
    var obj = $.parseJSON(actor.keyFrameRenderables[i].fabricJson);
    $.extend(true, obj, updates);
    actor.keyFrameRenderables[i].fabricJson = JSON.stringify(obj);
  }
}

function upsertKeyFrame(actor, fabricObject, frame) {
  fabricObject.left -= globals.padding;
  fabricObject.top -= globals.padding;
  
  for ( var i = 0; i < actor.keyFrameRenderables.length; i++) {
    if (actor.keyFrameRenderables[i].keyFrame > frame) {
      var renderable = new Renderable();
      renderable.fabricJson = JSON.stringify(fabricObject.toObject());
      renderable.keyFrame = frame;
      actor.keyFrameRenderables.splice(i, 0, renderable);
      fabricObject.left += globals.padding;
      fabricObject.top += globals.padding;
      return renderable;
    } else if (actor.keyFrameRenderables[i].keyFrame == frame) {
      actor.keyFrameRenderables[i].fabricJson = JSON.stringify(fabricObject
          .toObject());
      fabricObject.left += globals.padding;
      fabricObject.top += globals.padding;
      return actor.keyFrameRenderables[i];
    } else if (i + 1 == actor.keyFrameRenderables.length) {
      var renderable = new Renderable();
      renderable.fabricJson = JSON.stringify(fabricObject.toObject());
      renderable.keyFrame = frame;
      actor.keyFrameRenderables.push(renderable);
      fabricObject.left += globals.padding;
      fabricObject.top += globals.padding;
      return renderable;
    }
  }
}

function createFabricObject(serializedObject, id) {
  if (serializedObject.type == 'line') {
    var fabricObject = fabric.Line.fromObject(serializedObject);
    fabricObject.left += globals.padding;
    fabricObject.top += globals.padding;
    fabricObject.id = id;
    globals.objectIdMap[id] = fabricObject;
    globals.canvas.add(fabricObject);
  } else if (serializedObject.type == 'rect') {
      var fabricObject = fabric.Rect.fromObject(serializedObject);
      fabricObject.left += globals.padding;
      fabricObject.top += globals.padding;
      fabricObject.id = id;
      globals.objectIdMap[id] = fabricObject;
      globals.canvas.add(fabricObject);
  } else if (serializedObject.type == 'text') {
    var fabricObject = fabric.Text.fromObject(serializedObject);
    fabricObject.left += globals.padding;
    fabricObject.top += globals.padding;
    fabricObject.id = id;
    globals.objectIdMap[id] = fabricObject;
    globals.canvas.add(fabricObject);
  } else if (serializedObject.type == 'image') {
    // Images must load asynchronously
    fabric.Image.fromObject(serializedObject, function(fabricObject) {
      fabricObject.id = id;
      fabricObject.left += globals.padding;
      fabricObject.top += globals.padding;
      globals.objectIdMap[id] = fabricObject;
      globals.canvas.add(fabricObject);
      updateAnimation();
    });
  } else {
    throw "Invalid fabric object type " + serializedObject;
  }
}

app
    .directive(
        'palette',
        function($rootScope) {
          // return the directive link function. (compile function not needed)
          return function(scope, element, attrs) {
            globals.frame = 0;

            globals.movie = new Movie();
            globals.movie.id = "Movie";

            var layer = new Layer();
            globals.movie.layers.push(layer);

            var actor = new Actor();
            layer.actors.push(actor);

            actor.id = "rect1";

            var renderable = new Renderable();
            actor.keyFrameRenderables.push(renderable);

            renderable.fabricJson = '{"type":"rect","originX":"center","originY":"center","left":100,"top":100,"width":100,"height":100,"fill":"red","overlayFill":null,"stroke":null,"strokeWidth":1,"strokeDashArray":null,"scaleX":1,"scaleY":1,"angle":0,"flipX":false,"flipY":false,"opacity":1,"selectable":true,"hasControls":true,"hasBorders":true,"hasRotatingPoint":true,"transparentCorners":true,"perPixelTargetFind":false,"shadow":null,"visible":true,"rx":0,"ry":0}';
            renderable.keyFrame = 0;

            renderable = new Renderable();
            actor.keyFrameRenderables.push(renderable);

            renderable.fabricJson = '{"type":"rect","originX":"center","originY":"center","left":200,"top":100,"width":100,"height":100,"fill":"red","overlayFill":null,"stroke":null,"strokeWidth":1,"strokeDashArray":null,"scaleX":1,"scaleY":1,"angle":0,"flipX":false,"flipY":false,"opacity":1,"selectable":true,"hasControls":true,"hasBorders":true,"hasRotatingPoint":true,"transparentCorners":true,"perPixelTargetFind":false,"shadow":null,"visible":true,"rx":0,"ry":0}';
            renderable.keyFrame = 20;

            fabric.Image
                .fromURL(
                    'http://bobbydazzler.ca/wp-content/themes/shopperpress/thumbs/item_SPPC051_large-300x300.jpg',
                    function(oImg) {
                      console.log("IMAGE DATA:");
                      console.log(JSON.stringify(oImg.toObject()));
                    });

            globals.canvas = new fabric.Canvas(element.get(0));

            // Create guidelines
            globals.guidelines = new fabric.Rect({
              left : 320 + 100,
              top : 180 + 100,
              width : 640,
              height : 360,
              stroke : 'grey',
              strokeWidth : 2,
              fill : null,
              selectable : false,
            });
            globals.canvas.add(globals.guidelines);

            globals.canvas.on('object:modified', function(params) {
              var fabricObject = params.target;
              console.log("MODIFIED");
              console.log(fabricObject);
              var actor = getActorFromId(fabricObject.id);
              console.log(actor);

              upsertKeyFrame(actor, fabricObject, globals.frame);
            });

            globals.canvas.on('object:selected', function(params) {
              var fabricObject = params.target;
              console.log("SELECTED");
              console.log(fabricObject);
              globals.selectedObjectId = fabricObject.id;
              $rootScope.$apply();
            });

            globals.canvas.on('selection:cleared', function(params) {
              console.log("UNSELECTED");
              globals.selectedObjectId = null;
              $rootScope.$apply();
            });
            
            updateAnimation();
          };
        });

function updateAnimation() {
  // Frame changed, redraw
  console.log(globals.frame);

  for ( var actor_i = 0; actor_i < globals.movie.layers.length; actor_i++) {
    for ( var actor_j = 0; actor_j < globals.movie.layers[actor_i].actors.length; actor_j++) {
      var actor = globals.movie.layers[actor_i].actors[actor_j];
      console.log(actor);

      var removeObject = true;
      if (actor.keyFrameRenderables[0].keyFrame <= globals.frame) {
        removeObject = false;
        var keyFrameBefore = actor.keyFrameRenderables.length - 1;
        var keyFrameAfter = -1;
        for ( var i = 0; i < actor.keyFrameRenderables.length - 1; i++) {
          if (actor.keyFrameRenderables[i].keyFrame <= globals.frame
              && actor.keyFrameRenderables[i + 1].keyFrame > globals.frame) {
            keyFrameBefore = i;
            keyFrameAfter = i + 1;
            break;
          }
        }

        if (keyFrameAfter == -1
            && actor.keyFrameRenderables[keyFrameBefore].destroy == true) {
          removeObject = true;
        } else {

          if (!(actor.id in globals.objectIdMap)) {
            if (keyFrameAfter == -1) {
              createFabricObject(
                  jQuery
                      .parseJSON(actor.keyFrameRenderables[keyFrameBefore].fabricJson),
                  actor.id);
            } else {
              createFabricObject(
                  tween(
                      globals.frame
                          - actor.keyFrameRenderables[keyFrameBefore].keyFrame,
                      actor.keyFrameRenderables[keyFrameAfter].keyFrame
                          - actor.keyFrameRenderables[keyFrameBefore].keyFrame,
                      jQuery
                          .parseJSON(actor.keyFrameRenderables[keyFrameBefore].fabricJson),
                      jQuery
                          .parseJSON(actor.keyFrameRenderables[keyFrameAfter].fabricJson),
                      actor.keyFrameRenderables[keyFrameBefore].easeAfter),
                  actor.id);
            }

            console.log("ADDING OBJECT");
          } else {
            var fabricObject = globals.objectIdMap[actor.id];

            console.log("UPDATING OBJECT");
            // Update the object based on a new tween.
            // TODO: For performance, cache these objects so we don't
            // keep
            // calling parseJSON
            if (keyFrameAfter == -1) {
              fabricObject
                  .set(jQuery
                      .parseJSON(actor.keyFrameRenderables[keyFrameBefore].fabricJson));
            } else {
              fabricObject
                  .set(tween(
                      globals.frame
                          - actor.keyFrameRenderables[keyFrameBefore].keyFrame,
                      actor.keyFrameRenderables[keyFrameAfter].keyFrame
                          - actor.keyFrameRenderables[keyFrameBefore].keyFrame,
                      jQuery
                          .parseJSON(actor.keyFrameRenderables[keyFrameBefore].fabricJson),
                      jQuery
                          .parseJSON(actor.keyFrameRenderables[keyFrameAfter].fabricJson),
                      actor.keyFrameRenderables[keyFrameBefore].easeAfter));
            }
            fabricObject.left += globals.padding;
            fabricObject.top += globals.padding;
            fabricObject.setCoords();
          }
        }

      }
      if (removeObject) {
        if (actor.id in globals.objectIdMap) {
          console.log("REMOVING OBJECT");
          console.log(actor);
          globals.canvas.remove(globals.objectIdMap[actor.id]);
          delete globals.objectIdMap[actor.id];
        }
      }
    }
  }

  globals.canvas.renderAll();
  globals.canvas.calcOffset();
}

function PaletteController($scope, $routeParams, $cookies, $http, $location,
    $rootScope, $timeout, tokenValidator) {
  $scope.getFrame = function() {
    return globals.frame;
  };
}

PaletteController.$inject = [ '$scope', '$routeParams', '$cookies', '$http',
    '$location', '$rootScope', '$timeout', 'tokenValidator' ];
