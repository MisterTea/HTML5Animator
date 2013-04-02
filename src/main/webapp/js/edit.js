function EditPanelController($scope, $routeParams, $cookies, $http, $location,
    $rootScope, $timeout, tokenValidator) {

  $scope.frame = function() {
    return globals.frame;
  };
  $scope.prevFrame = function() {
    globals.frame = Math.max(0, globals.frame - 1);
    updateAnimation();
  };
  $scope.nextFrame = function() {
    globals.frame = Math.min(100, globals.frame + 1);
    updateAnimation();
  };
  $scope.addBox = function() {
  };
  $scope.play = function() {
    globals.frame = 0;
    $rootScope.animationStartTime = Date.now();
    $rootScope.playing = true;
    setTimeout(animloop, 0);
  };
  $scope.stop = function() {
    $rootScope.playing = false;
    globals.frame = 0;
    updateAnimation();
  };
  $scope.save = function() {
    client.saveMovie(globals.movie);
  };
  $scope.load = function() {
    globals.movie = client.loadMovie("Movie");
  };
  $scope.makeGif = function() {
    globals.canvas.setWidth(640);
    globals.canvas.setHeight(360);
    globals.padding = 0;
    globals.canvas.remove(globals.guidelines);
    updateAnimation();
    var encoder = new GIFEncoder();
    encoder.setRepeat(0); // auto-loop
    encoder.setDelay(10);
    console.log("***");
    console.log(encoder.start());
    for (globals.frame = 0; globals.frame < 100; globals.frame++) {
      updateAnimation();
      console.log("***");
      console.log(encoder.addFrame(document.getElementById('palette')
          .getContext('2d')));
    }
    encoder.finish();
    document.getElementById('gifImage').src = 'data:image/gif;base64,'
        + encode64(encoder.stream().getData());
    console.log(document.getElementById('gifImage').src);
    globals.canvas.add(globals.guidelines);
    globals.canvas.setWidth(840);
    globals.canvas.setHeight(560);
    globals.padding = 100;
    updateAnimation();
  };

  function animloop(timestamp) {
    console.log(Date.now() - $rootScope.animationStartTime);
    if ($rootScope.playing == false) {
      console.log("NOT PLAYING");
      return;
    }
    requestAnimFrame(animloop);

    // Render
    globals.frame = (Date.now() - $rootScope.animationStartTime) / 100;
    updateAnimation();
    $rootScope.$apply();
  }
  ;
}

EditPanelController.$inject = [ '$scope', '$routeParams', '$cookies', '$http',
    '$location', '$rootScope', '$timeout', 'tokenValidator' ];

function EditObjectController($scope, $routeParams, $cookies, $http, $location,
    $rootScope, $timeout, tokenValidator) {
  $scope.getEditObject = function() {
    return globals.objectIdMap[globals.selectedObjectId];
  };
  $scope.getEditObjectType = function() {
    return globals.selectedObjectId in globals.objectIdMap ? globals.objectIdMap[globals.selectedObjectId].type : "none";
  };
  $scope.updateText = function() {
    updateAllRenderables($scope.getEditObject().id, {text:$scope.selectedText});
    updateAnimation();
  };
  $scope.selectedText = $scope.getEditObjectType()=='text'?$scope.getEditObject().text:"";

  $scope.eraseObject = function() {
    var actor = getActorFromId(globals.movie, globals.selectedObjectId);
    var keyFrame = upsertKeyFrame(actor, objectIdMap[globals.selectedObjectId],
        globals.frame);
    keyFrame.destroy = true;
    while (actor.keyFrameRenderables[actor.keyFrameRenderables.length - 1].keyFrame != globals.frame) {
      actor.keyFrameRenderables.splice(actor.keyFrameRenderables.length - 1);
    }
    updateAnimation();
  };

  $scope.deleteObject = function() {
    var layer = getLayerWithActorId(globals.movie, globals.selectedObjectId);
    layer.actors.splice(getActorIndexWithActorId(globals.movie,
        globals.selectedObjectId), 1);
    canvas.remove(objectIdMap[globals.selectedObjectId]);
    delete objectIdMap[globals.selectedObjectId];
    updateAnimation();
    globals.selectedObjectId = null;
  };
}

EditObjectController.$inject = [ '$scope', '$routeParams', '$cookies', '$http',
    '$location', '$rootScope', '$timeout', 'tokenValidator' ];

function AddObjectController($scope, $routeParams, $cookies, $http, $location,
    $rootScope, $timeout, tokenValidator) {
  $scope.addImage = function() {
    var imageUrl = $scope.newImageUrl;
    console.log(imageUrl);
    fabric.Image.fromURL(imageUrl, function(oImg) {
      oImg.left = oImg.width / 2;
      oImg.top = oImg.height / 2;

      var layer = new Layer();
      globals.movie.layers.push(layer);

      var actor = new Actor();
      layer.actors.push(actor);

      actor.id = "image" + randomString();

      var renderable = new Renderable();
      actor.keyFrameRenderables.push(renderable);

      renderable.fabricJson = JSON.stringify(oImg.toObject());
      console.log(renderable.fabricJson);
      renderable.keyFrame = globals.frame;
      // $rootScope.canvas.add(oImg);

      updateAnimation();
    });
  };

  $scope.addText = function() {
    var text = new fabric.Text('Dart Rocks!', {
      left : 100,
      top : 100,
    });

    var layer = new Layer();
    globals.movie.layers.push(layer);

    var actor = new Actor();
    layer.actors.push(actor);

    actor.id = "text" + randomString();

    var renderable = new Renderable();
    actor.keyFrameRenderables.push(renderable);

    renderable.fabricJson = JSON.stringify(text.toObject());
    console.log(renderable.fabricJson);
    renderable.keyFrame = globals.frame;
    // $rootScope.canvas.add(oImg);

    updateAnimation();
  };
}

AddObjectController.$inject = [ '$scope', '$routeParams', '$cookies', '$http',
    '$location', '$rootScope', '$timeout', 'tokenValidator' ];
