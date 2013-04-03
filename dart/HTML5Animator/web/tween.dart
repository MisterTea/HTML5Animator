part of html5animator;

/* Variables:
 * 
 * t = current time
 * b = start value
 * c = change in value
 * d = duration
 * 
 */

/**
 * Linear easing in
 */
num easeInLinear(t, b, c, d) {
  return c*t/d + b;
}

/**
 * Quadratic easing in and out
 * 
 * @method easeInOutQuad
 * @memberOf fabric.util.ease
 */
num easeInOutQuad(t, b, c, d) {
  t /= (d / 2);
  if (t < 1)
    return c / 2 * t * t + b;
  return -c / 2 * ((--t) * (t - 2) - 1) + b;
}

var EasingFns = {
   "linear" : easeInLinear,
   "quadratic" : easeInOutQuad,
};

Map tween(currentTime, duration, from, to, easing) {
  var tweened = {};
  for (var key in to.keys) {
    if (!from.containsKey(key)) {
      window.console.debug("WARNING: Trying to tween two objects that do not have the same keys: " + key);
    } else {
      if (to[key] is num) {
        // Tween the number
        tweened[key] = EasingFns[easing](currentTime, from[key], to[key] - from[key], duration);
      } else {
        // Copy the value.  TODO: HANDLE COLORS
        tweened[key] = to[key];
      }
    }
  }
  return tweened;
}

