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

app
    .directive(
        'palette',
        function($rootScope) {
          // return the directive link function. (compile function not needed)
          return function(scope, element, attrs) {
            $rootScope.frame = 0;

            var movie = new Movie();
            movie.id = "Movie";
            $rootScope.movie = movie;

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

            $rootScope.canvas = new fabric.Canvas(element.get(0));

            $rootScope.canvas
                .on(
                    'object:modified',
                    function(params) {
                      var fabricObject = params.target;
                      console.log("MODIFIED");
                      console.log(fabricObject);
                      var actor = getActorFromId($rootScope.movie,
                          fabricObject.id);
                      console.log(actor);

                      for ( var i = 0; i < actor.keyFrameRenderables.length; i++) {
                        if (actor.keyFrameRenderables[i].keyFrame > $rootScope.frame) {
                          var renderable = new Renderable();
                          renderable.fabricJson = JSON.stringify(fabricObject
                              .toObject());
                          renderable.keyFrame = $rootScope.frame;
                          actor.keyFrameRenderables.splice(i, 0, renderable);
                          break;
                        } else if (actor.keyFrameRenderables[i].keyFrame == $rootScope.frame) {
                          actor.keyFrameRenderables[i].fabricJson = JSON
                              .stringify(fabricObject.toObject());
                          break;
                        }
                      }
                    });

            $rootScope.canvas.on('object:selected', function(params) {
              var fabricObject = params.target;
              console.log("SELECTED");
              console.log(fabricObject);
              $rootScope.selectedObjectId = fabricObject.id;
              $rootScope.$apply();
            });

            $rootScope.canvas.on('selection:cleared', function(params) {
              console.log("UNSELECTED");
              $rootScope.selectedObjectId = null;
              $rootScope.$apply();
            });
          };
        });

function PaletteController($scope, $routeParams, $cookies, $http, $location,
    $rootScope, $timeout, tokenValidator) {
  $scope.getFrame = function() {
    return $rootScope.frame;
  };

  $scope.objectIdMap = {};

  $scope
      .$watch(
          $scope.getFrame,
          function(newVal, oldVal) {
            // Frame changed, redraw
            var frame = newVal;
            var canvas = $rootScope.canvas;
            var movie = $rootScope.movie;
            console.log(frame);

            for ( var actor_i = 0; actor_i < movie.layers.length; actor_i++) {
              for ( var actor_j = 0; actor_j < movie.layers[actor_i].actors.length; actor_j++) {
                var actor = $rootScope.movie.layers[actor_i].actors[actor_j];
                console.log(actor);

                if (actor.keyFrameRenderables[0].keyFrame <= frame
                    && actor.keyFrameRenderables[actor.keyFrameRenderables.length - 1].keyFrame > frame) {
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

                  var fabricObject = null;
                  if (!(actor.id in $scope.objectIdMap)) {
                    if (keyFrameAfter == -1) {
                      fabricObject = fabric.Rect
                          .fromObject(jQuery
                              .parseJSON(actor.keyFrameRenderables[keyFrameBefore].fabricJson));
                      fabricObject.id = actor.id;
                    } else {
                      fabricObject = fabric.Rect
                          .fromObject(tween(
                              frame
                                  - actor.keyFrameRenderables[keyFrameBefore].keyFrame,
                              actor.keyFrameRenderables[keyFrameAfter].keyFrame
                                  - actor.keyFrameRenderables[keyFrameBefore].keyFrame,
                              jQuery
                                  .parseJSON(actor.keyFrameRenderables[keyFrameBefore].fabricJson),
                              jQuery
                                  .parseJSON(actor.keyFrameRenderables[keyFrameAfter].fabricJson),
                              actor.keyFrameRenderables[keyFrameBefore].easeAfter));
                      fabricObject.id = actor.id;
                    }

                    console.log("ADDING OBJECT");
                    console.log(fabricObject);
                    $scope.objectIdMap[actor.id] = fabricObject;
                    canvas.add(fabricObject);
                  } else {
                    fabricObject = $scope.objectIdMap[actor.id];

                    console.log("UPDATING OBJECT");
                    // Update the object based on a new tween.
                    // TODO: For performance, cache these objects so we don't
                    // keep
                    // calling parseJSON
                    if (keyFrameAfter == -1) {
                      fabricObject.set(jQuery
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
                  }
                  fabricObject.setCoords();

                } else {
                  if (actor.id in $scope.objectIdMap) {
                    console.log("REMOVING OBJECT");
                    console.log(actor);
                    canvas.remove($scope.objectIdMap[actor.id]);
                    delete $scope.objectIdMap[actor.id];
                  }
                }
              }
            }

            canvas.renderAll();
            canvas.calcOffset();            
          });
}

PaletteController.$inject = [ '$scope', '$routeParams', '$cookies', '$http',
    '$location', '$rootScope', '$timeout', 'tokenValidator' ];
