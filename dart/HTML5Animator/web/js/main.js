DEBUG = true;
SERVER = "";

transport = new Thrift.Transport(SERVER + "animator.servlet");
protocol = new Thrift.Protocol(transport);
client = new AnimatorRpcClient(protocol, protocol);

LAST_ERROR_REPORT_TIME = 0;
window.onerror = function(message, url, lineNumber) {
  console.log("GOT AN ERROR: " + message + " " + url + " " + lineNumber);
  if (LAST_ERROR_REPORT_TIME == Math.floor(new Date().getTime() / 1000 / 60)) {
    console.log("Not reporting, already reported within the last minute");
    return;
  }
  if (DEBUG) {
    return;
  }
  LAST_ERROR_REPORT_TIME = Math.floor(new Date().getTime() / 1000 / 60);
  client.sendClientError(new ClientErrorInfo({
    'browser' : navigator.appVersion,
    'version' : VERSION,
    'message' : message,
    'url' : url,
    'lineNumber' : lineNumber
  }));
  // save error and send to server for example.
  return true;
};

app = angular.module('animator', [ 'ngCookies', 'ui.bootstrap' ]);

app
    .config(function($routeProvider, $locationProvider) {
      // configure html5 to get links working
      // If you don't do this, you URLs will be base.com/#/home rather than
      // base.com/home
      //$locationProvider.html5Mode(true);
      $routeProvider.when('/login/signin', {
        templateUrl : 'partials/loginInternal.html',
        controller : LoginCtrl
      }).when('/login/create', {
        templateUrl : 'partials/loginInternalCreate.html',
        controller : LoginCtrl
      }).when('/login/forgotpassword', {
        templateUrl : 'partials/loginInternalForgotPassword.html',
        controller : LoginCtrl
      }).when('/login', {
        templateUrl : 'partials/login.html',
        controller : LoginCtrl
      }).when('/edit', {
        templateUrl : 'partials/edit.html',
        controller : EditCtrl
      }).when('/comic/:comicId/:comicPageId', {
        templateUrl : 'partials/comicPage.html',
        controller : ComicPageCtrl
      }).when('/help', {
        templateUrl : 'partials/help.html',
        controller : HelpPageCtrl
      }).otherwise({
        redirectTo : '/edit'
      });
    })
    .run(
        function($rootScope, $cookies, Navigation) {
          if ('token' in $cookies) {
            console.log("GOT TOKEN");
          } else {
            console.log("NO TOKEN");
            $cookies.token = "web" + randomString();
          }
          console.log($cookies.token);

          $rootScope.showBottomBar = true;
          $rootScope.resizeImage = false;
          $rootScope.Navigation = Navigation;
          $rootScope.alerts = [];
          $rootScope.modals = [];
        });

app.service('Navigation', function($location) {
  return {
    transition : 'forwardTransition',
  };
});

app
    .directive(
        'smoothTransitions',
        function($http, $templateCache, $route, $anchorScroll, $compile,
            $controller, Navigation) {
          return {
            restrict : 'ECA',
            terminal : true,
            link : function(scope, parentElm, attr) {
              var partials = [], inClass = "in", outClass = "out", currentPartial, lastPartial;

              scope.$on('$routeChangeSuccess', update);
              update();

              // Create just an element for a partial
              function createPartial(template) {
                console.log("CREATING PARTIAL");
                console.log(Navigation.transition);
                // Create it this way because some templates give error
                // when you just do angular.element(template) (unknown reason)
                var d = document.createElement("div");
                d.innerHTML = template;
                $('.content', d).addClass(Navigation.transition);
                $('.content', d).addClass("in");
                return {
                  element : angular.element(d.children[0]),
                  // Store a reference to controller, but don'r create it yet
                  controller : $route.current && $route.current.controller,
                  locals : $route.current && $route.current.locals
                };
              }

              // 'Angularize' a partial: Create scope/controller, $compile
              // element, insert into dom
              function setupPartial(partial) {
                var cur = $route.current;
                partial.scope = cur.locals.$scope = scope.$new();
                // partial.controller contains a reference to the
                // controller constructor at first
                // Now we actually instantiate it
                if (partial.controller) {
                  partial.controller = $controller(partial.controller,
                      partial.locals);
                  partial.element.contents().data('$ngControllerController',
                      partial.controller);
                  $compile(partial.element.contents())(partial.scope);
                }
                parentElm.append(partial.element);
                partial.scope.$emit('$viewContentLoaded');
              }

              function destroyPartial(partial) {
                console.log("DESTROYING PARTIAL");
                partial.scope.$destroy();
                partial.element.remove();
                partial = null;
              }

              function transition(inPartial, outPartial) {
                console.log("GOT TRANSITION ");
                console.log(Navigation.transition);
                var currentTransition = Navigation.transition;
                if (currentTransition == 'noTransition') {
                  updatePartialQueue();
                  if (outPartial) {
                    destroyPartial(outPartial);
                  }
                } else {
                  inPartial.element.removeClass(function(index, classes) {
                    return classes;
                  });
                  inPartial.element.addClass(currentTransition);
                  inPartial.element.addClass("in");

                  // Do a timeout so the initial class for the
                  // element has time to 'take effect'
                  setTimeout(function() {
                    if (outPartial) {
                      outPartial.element.removeClass(function(index, classes) {
                        return classes;
                      });
                      outPartial.element.addClass(currentTransition);
                      outPartial.element.addClass("out");
                    }

                    // removeClass() with no arguments doesn't work for some
                    // reason.
                    inPartial.element.removeClass(function(index, classes) {
                      return classes;
                    });
                    inPartial.element.addClass(currentTransition);
                    inPartial.element.addClass("done");
                    setTimeout(updatePartialQueue, 3000);
                    if (outPartial) {
                      setTimeout(function() {
                        destroyPartial(outPartial);
                      }, 3000);
                    }
                  });
                }
              }

              function updatePartialQueue() {
                // Bring in a new partial if it exists
                if (partials.length > 0) {
                  var newPartial = partials.pop();
                  setupPartial(newPartial);
                  transition(newPartial, currentPartial);
                  currentPartial = newPartial;
                }
              }

              function update() {
                if ($route.current && $route.current.locals.$template) {
                  partials
                      .unshift(createPartial($route.current.locals.$template));
                  updatePartialQueue();
                }
              }
            }
          };
        });

app.factory('tokenValidator', function($rootScope, $cookies) {
  console.log("COOKIES 2");
  console.log($cookies);
  var tokenValidator = {};
  tokenValidator.validate = function() {
    console.log("VALIDATING");
    if (!('token' in $cookies)) {
      $rootScope.addAlert({
        type : "error",
        msg : "ERROR: You must have cookies enabled to access this site"
      });
      console.log("COOKIE ERROR");
      return false;
    }
    console.log($cookies.token);
    if ($cookies.token.length > 0) {
      if (client.validateToken($cookies.token)) {
        console.log("TOKEN VALIDATED");
        return true;
      }
    }
    console.log("VALIDATING");
    return false;
  };
  return tokenValidator; // returning this is very important
});

FACEBOOK_APP_ID = "535653579801438";
FACEBOOK_SCOPE = "user_about_me,friends_about_me,email";

function LoginForm($scope, $http, $location, $cookies, $rootScope,
    tokenValidator) {
  $scope.loginInternalAccount = function() {
    if ($scope.email == undefined) {
      $rootScope.addAlert({
        type : "error",
        msg : "Login failed: invalid email address"
      });
      return;
    }
    console.log("COOKIES " + $cookies.token);
    console.log($cookies);
    var result = client.login($cookies.token, $scope.email, $scope.password);
    if (result.length == 0) {
      $rootScope.Navigation.transition = 'forwardTransition';
      $location.path('/comics');
    } else {
      $rootScope.addAlert({
        type : "error",
        msg : "Login failed: " + result
      });
    }
  };

  if (tokenValidator.validate()) {
    $rootScope.Navigation.transition = 'forwardTransition';
    $location.path('/comics');
  }
}

LoginForm.$inject = [ '$scope', '$http', '$location', '$cookies', '$rootScope',
    'tokenValidator' ];

function ForgotPasswordForm($scope, $http, $location, $cookies, $rootScope,
    tokenValidator) {
  $scope.emailInternalPassword = function() {
    var result = client.emailPassword($scope.email);
    if (result) {
      $rootScope.addAlert({
        type : "success",
        msg : "Password Emailed to " + $scope.email
      });
    } else {
      $rootScope.addAlert({
        type : "error",
        msg : "Error: Could not find account with email " + $scope.email
      });
    }
  };
}

ForgotPasswordForm.$inject = [ '$scope', '$http', '$location', '$cookies',
    '$rootScope', 'tokenValidator' ];

function CreateAccountForm($scope, $rootScope, $http, $location, $cookies) {
  $scope.createInternalAccount = function() {
    if ($scope.email == undefined) {
      $rootScope.addAlert({
        type : "error",
        msg : "Please enter a valid email address"
      });
      return;
    }
    console.log($scope.email);
    console.log($scope.name);
    console.log($scope.password);
    var result = client.createAccount($cookies.token, $scope.email,
        $scope.name, $scope.password);
    if (result.length == 0) {
      $rootScope.Navigation.transition = 'forwardTransition';
      $location.path('/comics');
    } else {
      $rootScope.addAlert({
        type : "error",
        msg : "New Account failed: " + result
      });
    }
  };
}

CreateAccountForm.$inject = [ '$scope', '$rootScope', '$http', '$location',
    '$cookies' ];

function LoginCtrl($scope, $http, $location, $rootScope, $cookies,
    tokenValidator) {
  if (tokenValidator.validate()) {
    $rootScope.Navigation.transition = 'forwardTransition';
    $location.path('/comics');
  }

  $scope.facebookLogin = function() {
    $rootScope.pushModal({
      header : "Logging in through facebook",
      body : "Please wait while we log you in...",
      canClose : false,
    });

    FB
        .login(
            function(response) {
              $scope
                  .$apply(function() {
                    if (response.authResponse) {
                      console.log('Welcome!  Fetching your information.... ');
                      var access_token = FB.getAuthResponse()['accessToken'];
                      var expiresIn = FB.getAuthResponse()['expiresIn'];
                      console.log('Access Token = ' + access_token);
                      FB.api('/me', function(response) {
                        console.log('Good to see you, ' + response.name + '.');
                      });
                      if ($cookies.token == undefined) {
                        $cookies.token = "web" + randomString();
                      }
                      console.log($cookies.token);
                      $http
                          .get(
                              SERVER + 'facebooklogin.servlet?state='
                                  + $cookies.token + '&accessToken='
                                  + access_token + '&expiresIn=' + expiresIn)
                          .success(
                              function(data, status, headers, config) {
                                console.log("SERVER FACEBOOK LOGIN SUCCESS");
                                $rootScope.popModal(); // Pop the "logging
                                // in..." modal
                                $rootScope.Navigation.transition = 'forwardTransition';
                                $location.path('/comics');
                              })
                          .error(
                              function(data, status, headers, config) {
                                console.log("SERVER FACEBOOK LOGIN FAIL");
                                $rootScope.popModal(); // Pop the "logging
                                // in..." modal
                                $rootScope
                                    .pushModal({
                                      header : "Facebook Login Error",
                                      body : "The server could not authorize your facebook login.  Please try again.",
                                      canClose : true,
                                    });
                                $rootScope
                                    .runAfterModals(function() {
                                      $rootScope.Navigation.transition = 'backwardTransition';
                                      $location.path('/');
                                    });
                              });
                    } else {
                      $rootScope.popModal(); // Pop the "logging in..." modal
                      console
                          .log('User cancelled login or did not fully authorize.');
                    }
                  });
            }, {
              scope : FACEBOOK_SCOPE
            });
  };

  $scope.gotoRootLogin = function() {
    $rootScope.Navigation.transition = 'backwardTransition';
    $location.path('/login');
  };

  $scope.gotoCreateAccount = function() {
    $rootScope.Navigation.transition = 'forwardTransition';
    $location.path('/login/create');
  };

  $scope.gotoForgotPassword = function() {
    $rootScope.Navigation.transition = 'forwardTransition';
    $location.path('/login/forgotpassword');
  };

  $scope.gotoSignin = function(transition) {
    console.log("GOING TO SIGNIN");
    $rootScope.Navigation.transition = transition;
    $location.path('/login/signin');
  };
}

LoginCtrl.$inject = [ '$scope', '$http', '$location', '$rootScope', '$cookies',
    'tokenValidator' ];

function EditCtrl($scope, $http, $cookies, $location, $rootScope,
    tokenValidator) {
  /*
   * console.log("LOADING COMIC CONTROL"); delete $rootScope.comicPage;
   * $scope.showRequestComic = false; $scope.comicRequested = false;
   * $scope.comics = [ { name : "Loading", id : -1, lastPageId : -1 } ];
   * client.getComicList(function(comicList) { if (comicList == null ||
   * comicList.length == 0) { $rootScope.Navigation.transition =
   * 'backwardTransition'; $location.path("/"); } else {
   * console.log($cookies.token); client.getMyData($cookies.token,
   * function(userData) { $scope.comics = comicList; if (userData.id == null) {
   * console.log("NO USERDATA"); $scope.userData = null; } else {
   * console.log("GOT USERDATA"); $scope.userData = userData; } $scope.$apply();
   * }); } });
   * 
   * $scope.getPreferredComicPage = function(comic) { if ($scope.userData !=
   * null) { if ($scope.userData.lastVisited[comic.id] != null) { return
   * $scope.userData.lastVisited[comic.id]; } } return comic.lastPageId; };
   * 
   * $scope.enterComic = function($event, comic) { $event.preventDefault();
   * $rootScope.Navigation.transition = 'forwardTransition';
   * $location.path('/comic/' + comic.id + '/' +
   * $scope.getPreferredComicPage(comic)); };
   * 
   * $scope.submitRequestComic = function() { console.log("REQUESTING COMIC");
   * client.requestComic($cookies.token, new ComicRequest({ name :
   * $scope.requestComicName, url : $scope.requestComicUrl }));
   * console.log("REQUEST FINISHED"); $rootScope.alerts .push({ type :
   * "success", msg : "Your comic request has been submitted. You should be
   * notified within a few days if the comic will be added." });
   * $scope.comicRequested = true; };
   * 
   * if (!tokenValidator.validate()) { console.log("INVALID TOKEN");
   * $location.path('/'); }
   */
}

EditCtrl.$inject = [ '$scope', '$http', '$cookies', '$location', '$rootScope',
    'tokenValidator' ];

function ComicPageCtrl($scope, $routeParams, $cookies, $http, $location,
    $rootScope, $timeout, tokenValidator) {
  client.getComic($routeParams.comicId, function(comic) {
    if (comic == null) {
      $location.path("/");
    }
    $rootScope.comic = $scope.comic = comic;
    $rootScope.$apply();
    $scope.$apply();
  });

  $scope.comicPage = {
    title : "Loading..."
  };
  client.getComicPage($cookies.token, $routeParams.comicPageId, function(
      comicPage) {
    if (comicPage == null || comicPage.id == null || comicPage.id.length == 0) {
      $rootScope.Navigation.transition = 'backwardTransition';
      $location.path("/comics");
    }
    // Preload comic page.
    (new Image()).src = comicPage.imageUrl;
    $rootScope.comicPage = $scope.comicPage = comicPage;
    $rootScope.$apply();
    $scope.$apply();
  });

  $rootScope.showNews = false;
  $scope.naturalImageHeight = 999999; // infinite
  $scope.naturalImageWidth = 999999; // infinite
  $rootScope.showMagnifier = true;

  $scope.getNewImageHeight = function() {
    var fullPageHeight = $(window).height() - 180;
    if (!$rootScope.showBottomBar) {
      fullPageHeight += 100; // We have more room without the bottom bar.
    }
    var fullPageWidth = $(window).width() - 20;
    if (false && $scope.naturalImageHeight < fullPageHeight
        && $scope.naturalImageWidth < fullPageWidth) {
      $rootScope.showMagnifier = false;
      return $scope.naturalImageHeight;
    } else {
      $rootScope.showMagnifier = true;
    }
    if ($rootScope.resizeImage || $rootScope.showBottomBar == false) {
      var naturalAspectRatio = $scope.naturalImageWidth
          / $scope.naturalImageHeight;
      var actualAspectRatio = fullPageWidth / fullPageHeight;
      if (naturalAspectRatio > actualAspectRatio) {
        // If the image aspect ratio is bigger, shrink to match the widths
        return {
          width : fullPageWidth,
          height : Math.floor(fullPageWidth / naturalAspectRatio)
        };
      } else {
        // Else shrink to match heights
        return {
          width : Math.floor(fullPageHeight * naturalAspectRatio),
          height : fullPageHeight
        };
      }
    } else {
      return {
        width : -1,
        height : -1
      };
    }
  };

  $scope.$watch($scope.getNewImageHeight, function(newVal, oldVal) {
    if (newVal.height == -1) {
      $(".comic-image").last().css("width", "auto");
      $(".comic-image").last().css("height", "auto");
    } else {
      $(".comic-image").last().width(newVal.width);
      $(".comic-image").last().height(newVal.height);
    }
  }, true); // The 3rd argument means to compare by equality instead of
  // reference.

  window.onresize = function() {
    $scope.$apply();
  };

  $timeout(function() { // document ready
    // $rootScope.Navigation.transition = 'noTransition'; // When switching
    // between
    // comics, don't transition

    console.log("CREATING IMAGE HANDLER");
    $(".comic-image").last().load(function() {
      console.log("COMIC IMAGE LOADED");
      $scope.naturalImageHeight = $(this)[0].naturalHeight;
      $scope.naturalImageWidth = $(this)[0].naturalWidth;
      $scope.$apply();
    });

    $scope.mousedown = {};
    $scope.mouseup = {};
    var handleMouseDown = function(e) {
      $scope.$apply(function() {
        $scope.mousedown = {
          x : e.pageX,
          y : e.pageY,
          time : new Date().getTime()
        };
        console.log($scope.mousedown);
      });
    };
    $(".comic-image").last().mousedown(function(e) {
      e.preventDefault();
      handleMouseDown(e);
    });
    $(".comic-image").last().bind('touchstart', function(e) {
      e.preventDefault();
      handleMouseDown(e.originalEvent.changedTouches[0]);
    });
    var handleMouseMove = function(e) {
      $scope.$apply(function() {
        var mousedown = $scope.mousedown;
        if (!('time' in mousedown)) {
          // Not dragging
          return;
        }
        var mousepos = {
          x : e.pageX,
          y : e.pageY,
          time : new Date().getTime()
        };
        if ($rootScope.showBottomBar == false) {
          $(".comic-image-container").last().css('-webkit-transform',
              'translateX(' + (mousepos.x - mousedown.x) + 'px)');
        }
      });
    };
    $(".comic-image").last().bind('touchmove', function(e) {
      if ($rootScope.showBottomBar) {
        return;
      }
      e.preventDefault();
      handleMouseMove(e.originalEvent.changedTouches[0]);
    });
    $(".comic-image").last().mousemove(function(e) {
      if ($rootScope.showBottomBar) {
        return;
      }
      e.preventDefault();
      handleMouseMove(e);
    });
    mouseUpFn = function(e) {
      $scope.$apply(function() {
        $scope.mouseup = {
          x : e.pageX,
          y : e.pageY,
          time : new Date().getTime()
        };
        var mousedown = $scope.mousedown;
        $scope.mousedown = {};
        var mouseup = $scope.mouseup;

        if (mouseup.time == mousedown.time) {
          // Clicked too fast, don't do anything special
          $(".comic-image-container").last().removeAttr('style');
          return;
        }
        var horizDistance = Math.abs(mouseup.x - mousedown.x);
        if (horizDistance > 50) {
          if ($rootScope.showBottomBar == false) {
            if (mouseup.x < mousedown.x) {
              // Treat as a 'next'
              if ($rootScope.comicPage.nextId) {
                $rootScope.Navigation.transition = 'forwardTransition';
                $location.path("/comic/" + $rootScope.comic.id + "/"
                    + $rootScope.comicPage.nextId);
              }
            } else {
              // Treat as 'back'
              if ($rootScope.comicPage.previousId) {
                $rootScope.Navigation.transition = 'backwardTransition';
                $location.path("/comic/" + $rootScope.comic.id + "/"
                    + $rootScope.comicPage.previousId);
              }
            }
          }
        } else {
          console.log("GOT CLICK IN IMAGE");
          $(".comic-image-container").last().removeAttr('style');
          $rootScope.showBottomBar = !$rootScope.showBottomBar;
        }
      });
    };
    $(".comic-image").last().mouseleave(function(e) {
      e.preventDefault();
      console.log("MOUSE LEAVE");
      if ('time' in $scope.mousedown) {
        mouseUpFn(e);
      }
    });
    $(".comic-image").last().mouseup(function(e) {
      e.preventDefault();
      console.log("MOUSE UP");
      if ('time' in $scope.mousedown) {
        mouseUpFn(e);
      }
    });
    $(".comic-image").last().bind('touchend', function(e) {
      e.preventDefault();
      console.log("MOUSE UP");
      if ('time' in $scope.mousedown) {
        mouseUpFn(e.originalEvent.changedTouches[0]);
      }
    });
  }, 0); // Putting timeout (even with 0) allows angular to catch up.

  if (!tokenValidator.validate()) {
    $rootScope.Navigation.transition = 'backwardTransition';
    $location.path('/');
  }
}

ComicPageCtrl.$inject = [ '$scope', '$routeParams', '$cookies', '$http',
    '$location', '$rootScope', '$timeout', 'tokenValidator' ];

function HelpPageCtrl($scope, $routeParams, $cookies, $http, $location,
    $rootScope, $timeout, tokenValidator) {
  $scope.currentTopic = "general";
  $scope.topicNames = {
    'general' : 'Main Menu',
    'signin' : 'Signing in',
    'choosecomic' : 'Choosing a Comic to Browser',
    'viewcomic' : 'Browsing a Comic',
  };
  $scope.topicLinks = {
    'general' : [ 'signin', 'choosecomic', 'viewcomic' ],
    'signin' : [ 'general' ],
    'choosecomic' : [ 'general' ],
    'viewcomic' : [ 'general' ],
  };

  $scope.updateTopicName = function(newName) {
    $scope.currentTopic = newName;
  };
}

HelpPageCtrl.$inject = [ '$scope', '$routeParams', '$cookies', '$http',
    '$location', '$rootScope', '$timeout', 'tokenValidator' ];
