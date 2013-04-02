function getLayerWithActorId(movie, id) {
  for ( var i = 0; i < movie.layers.length; i++) {
    for ( var j = 0; j < movie.layers[i].actors.length; j++) {
      if (movie.layers[i].actors[j].id == id) {
        return movie.layers[i];
      }
    }
  }
  return null;
};

function getActorIndexWithActorId(movie, id) {
  for ( var i = 0; i < movie.layers.length; i++) {
    for ( var j = 0; j < movie.layers[i].actors.length; j++) {
      if (movie.layers[i].actors[j].id == id) {
        return j;
      }
    }
  }
  return null;
};

function getActorFromId(movie, id) {
  for ( var i = 0; i < movie.layers.length; i++) {
    for ( var j = 0; j < movie.layers[i].actors.length; j++) {
      if (movie.layers[i].actors[j].id == id) {
        return movie.layers[i].actors[j];
      }
    }
  }
  return null;
};

function upsertKeyFrame(actor, fabricObject, frame) {
  for ( var i = 0; i < actor.keyFrameRenderables.length; i++) {
    if (actor.keyFrameRenderables[i].keyFrame > frame) {
      var renderable = new Renderable();
      renderable.fabricJson = JSON.stringify(fabricObject.toObject());
      renderable.keyFrame = frame;
      actor.keyFrameRenderables.splice(i, 0, renderable);
      return renderable;
    } else if (actor.keyFrameRenderables[i].keyFrame == frame) {
      actor.keyFrameRenderables[i].fabricJson = JSON.stringify(fabricObject
          .toObject());
      return actor.keyFrameRenderables[i];
    } else if (i + 1 == actor.keyFrameRenderables.length) {
      var renderable = new Renderable();
      renderable.fabricJson = JSON.stringify(fabricObject.toObject());
      renderable.keyFrame = frame;
      actor.keyFrameRenderables.push(renderable);
      return renderable;
    }
  }
}

function createFabricObject(serializedObject, id) {
  console.log(serializedObject);
  console.log(serializedObject.type);
  console.log(serializedObject.type == 'image');
  if (serializedObject.type == 'rect') {
    var fabricObject = fabric.Rect.fromObject(serializedObject);
    fabricObject.id = id;
    objectIdMap[id] = fabricObject;
    canvas.add(fabricObject);
  } else if(serializedObject.type == 'image') {
    fabric.Image.fromObject(serializedObject, function(fabricObject) {
      fabricObject.id = id;
      objectIdMap[id] = fabricObject;
      canvas.add(fabricObject);
      updateAnimation();
    });
  } else {
    throw "Invalid fabric object type " + serializedObject;
  }
}

objectIdMap = {};
frame = null;
canvas = null;
movie = null;

app
    .directive(
        'palette',
        function($rootScope) {
          // return the directive link function. (compile function not needed)
          return function(scope, element, attrs) {
            frame = 0;

            movie = new Movie();
            movie.id = "Movie";

            var layer = new Layer();
            movie.layers.push(layer);

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

            canvas = new fabric.Canvas(element.get(0));

            // Create guidelines
            var rect = new fabric.Rect({
              left : 320 + 100,
              top : 180 + 100,
              width : 640,
              height : 360,
              stroke: 'grey',
              strokeWidth: 2,
              fill: null,
              selectable: false,
            });
            canvas.add(rect);

            canvas.on('object:modified', function(params) {
              var fabricObject = params.target;
              console.log("MODIFIED");
              console.log(fabricObject);
              var actor = getActorFromId(movie, fabricObject.id);
              console.log(actor);

              upsertKeyFrame(actor, fabricObject, frame);
            });

            canvas.on('object:selected', function(params) {
              var fabricObject = params.target;
              console.log("SELECTED");
              console.log(fabricObject);
              $rootScope.selectedObjectId = fabricObject.id;
              $rootScope.$apply();
            });

            canvas.on('selection:cleared', function(params) {
              console.log("UNSELECTED");
              $rootScope.selectedObjectId = null;
              $rootScope.$apply();
            });
          };
        });

function updateAnimation() {
  // Frame changed, redraw
  console.log(frame);

  for ( var actor_i = 0; actor_i < movie.layers.length; actor_i++) {
    for ( var actor_j = 0; actor_j < movie.layers[actor_i].actors.length; actor_j++) {
      var actor = movie.layers[actor_i].actors[actor_j];
      console.log(actor);

      var removeObject = true;
      if (actor.keyFrameRenderables[0].keyFrame <= frame) {
        removeObject = false;
        var keyFrameBefore = actor.keyFrameRenderables.length - 1;
        var keyFrameAfter = -1;
        for ( var i = 0; i < actor.keyFrameRenderables.length - 1; i++) {
          if (actor.keyFrameRenderables[i].keyFrame <= frame
              && actor.keyFrameRenderables[i + 1].keyFrame > frame) {
            keyFrameBefore = i;
            keyFrameAfter = i + 1;
            break;
          }
        }

        if (keyFrameAfter == -1
            && actor.keyFrameRenderables[keyFrameBefore].destroy == true) {
          removeObject = true;
        } else {

          if (!(actor.id in objectIdMap)) {
            if (keyFrameAfter == -1) {
              createFabricObject(jQuery
                      .parseJSON(actor.keyFrameRenderables[keyFrameBefore].fabricJson), actor.id);
            } else {
              createFabricObject(tween(
                      frame
                          - actor.keyFrameRenderables[keyFrameBefore].keyFrame,
                      actor.keyFrameRenderables[keyFrameAfter].keyFrame
                          - actor.keyFrameRenderables[keyFrameBefore].keyFrame,
                      jQuery
                          .parseJSON(actor.keyFrameRenderables[keyFrameBefore].fabricJson),
                      jQuery
                          .parseJSON(actor.keyFrameRenderables[keyFrameAfter].fabricJson),
                      actor.keyFrameRenderables[keyFrameBefore].easeAfter), actor.id);
            }

            console.log("ADDING OBJECT");
          } else {
            fabricObject = objectIdMap[actor.id];

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
                      frame
                          - actor.keyFrameRenderables[keyFrameBefore].keyFrame,
                      actor.keyFrameRenderables[keyFrameAfter].keyFrame
                          - actor.keyFrameRenderables[keyFrameBefore].keyFrame,
                      jQuery
                          .parseJSON(actor.keyFrameRenderables[keyFrameBefore].fabricJson),
                      jQuery
                          .parseJSON(actor.keyFrameRenderables[keyFrameAfter].fabricJson),
                      actor.keyFrameRenderables[keyFrameBefore].easeAfter));
            }
            fabricObject.setCoords();
          }
        }

      }
      if (removeObject) {
        if (actor.id in objectIdMap) {
          console.log("REMOVING OBJECT");
          console.log(actor);
          canvas.remove(objectIdMap[actor.id]);
          delete objectIdMap[actor.id];
        }
      }
    }
  }

  canvas.renderAll();
  canvas.calcOffset();
}

function PaletteController($scope, $routeParams, $cookies, $http, $location,
    $rootScope, $timeout, tokenValidator) {
  $scope.getFrame = function() {
    return frame;
  };

  objectIdMap = {};

  $scope.$watch($scope.getFrame, function(newVal, oldVal) {
    updateAnimation();
  });
}

PaletteController.$inject = [ '$scope', '$routeParams', '$cookies', '$http',
    '$location', '$rootScope', '$timeout', 'tokenValidator' ];
