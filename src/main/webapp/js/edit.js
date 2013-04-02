function EditPanelController($scope, $routeParams, $cookies, $http, $location,
    $rootScope, $timeout, tokenValidator) {

  $scope.frame = function() {
    return frame;
  };
  $scope.prevFrame = function() {
    frame = Math.max(0, frame - 1);
  };
  $scope.nextFrame = function() {
    frame = Math.min(100, frame + 1);
  };
  $scope.addBox = function() {
  };
  $scope.play = function() {
    frame = 0;
    $rootScope.animationStartTime = Date.now();
    $rootScope.playing = true;
    setTimeout(animloop,0);
  };
  $scope.stop = function() {
    $rootScope.playing = false;
    frame = 0;
  };
  $scope.save = function() {
    client.saveMovie(movie);
  };
  $scope.load = function() {
    movie = client.loadMovie("Movie");
  };

  function animloop(timestamp){
    console.log(Date.now() - $rootScope.animationStartTime);
    if ($rootScope.playing == false) {
      return;
    }
    requestAnimFrame(animloop);

    // Render
    frame = (Date.now() - $rootScope.animationStartTime) / 100;
    $rootScope.$apply();
  };
}

EditPanelController.$inject = [ '$scope', '$routeParams', '$cookies', '$http',
    '$location', '$rootScope', '$timeout', 'tokenValidator' ];

function EditObjectController($scope, $routeParams, $cookies, $http, $location,
    $rootScope, $timeout, tokenValidator) {
  $rootScope.selectedObjectId = null;

  $scope.getEditObject = function() {
    return $rootScope.selectedObjectId;
  };
  
  $scope.eraseObject = function() {
    var actor = getActorFromId(movie, $rootScope.selectedObjectId);
    var keyFrame = upsertKeyFrame(actor, objectIdMap[$rootScope.selectedObjectId], frame);
    keyFrame.destroy = true;
    while (actor.keyFrameRenderables[actor.keyFrameRenderables.length - 1].keyFrame != frame) {
      actor.keyFrameRenderables.splice(actor.keyFrameRenderables.length - 1);
    }
    updateAnimation();
  };

  $scope.deleteObject = function() {
    var layer = getLayerWithActorId(movie, $rootScope.selectedObjectId);
    layer.actors.splice(getActorIndexWithActorId(movie, $rootScope.selectedObjectId), 1);
    canvas.remove(objectIdMap[$rootScope.selectedObjectId]);
    delete objectIdMap[$rootScope.selectedObjectId];
    updateAnimation();
    $rootScope.selectedObjectId = null;
  };
  
  $scope.addImage = function() {
    var imageUrl = $scope.newImageUrl;
    console.log(imageUrl);
    fabric.Image.fromURL(imageUrl, function(oImg) {
      oImg.left = oImg.width/2 + 100;
      oImg.top = oImg.height/2 + 100;
      
      var layer = new Layer();
      movie.layers.push(layer);

      var actor = new Actor();
      layer.actors.push(actor);

      actor.id = "image"+randomString();

      var renderable = new Renderable();
      actor.keyFrameRenderables.push(renderable);

      renderable.fabricJson = JSON.stringify(oImg.toObject());
      console.log(renderable.fabricJson);
      renderable.keyFrame = frame;
      //$rootScope.canvas.add(oImg);
      
      updateAnimation();
    });
  };
}

EditObjectController.$inject = [ '$scope', '$routeParams', '$cookies', '$http',
    '$location', '$rootScope', '$timeout', 'tokenValidator' ];


