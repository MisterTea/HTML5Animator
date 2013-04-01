function EditPanelController($scope, $routeParams, $cookies, $http, $location,
    $rootScope, $timeout, tokenValidator) {

  $scope.frame = function() {
    return $rootScope.frame;
  };
  $scope.prevFrame = function() {
    $rootScope.frame = Math.max(0, $rootScope.frame - 1);
  };
  $scope.nextFrame = function() {
    $rootScope.frame = Math.min(100, $rootScope.frame + 1);
  };
  $scope.addBox = function() {
  };
  $scope.play = function() {
    $rootScope.frame = 0;
    $rootScope.animationStartTime = Date.now();
    $rootScope.playing = true;
    setTimeout(animloop,0);
  };
  $scope.stop = function() {
    $rootScope.playing = false;
    $rootScope.frame = 0;
  };
  $scope.save = function() {
    client.saveMovie($rootScope.movie);
  };
  $scope.load = function() {
    $rootScope.movie = client.loadMovie("Movie");
  };

  function animloop(timestamp){
    console.log(Date.now() - $rootScope.animationStartTime);
    if ($rootScope.playing == false) {
      return;
    }
    requestAnimFrame(animloop);

    // Render
    $rootScope.frame = (Date.now() - $rootScope.animationStartTime) / 100;
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

}

EditObjectController.$inject = [ '$scope', '$routeParams', '$cookies', '$http',
    '$location', '$rootScope', '$timeout', 'tokenValidator' ];


