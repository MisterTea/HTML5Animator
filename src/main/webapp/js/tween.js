function tween(currentTime, duration, from, to, easing) {
  //console.log("EASING");
  //console.log(easing);
  //console.log(EasingFns[easing]);
  var tweened = {};
  for (var key in to) {
    if (!key in from) {
      console.log("WARNING: Trying to tween two objects that do not have the same keys: " + from + " " + to);
    } else {
      if (typeof(to[key]) == 'number') {
        // Tween the number
        tweened[key] = EasingFns[easing](currentTime, from[key], to[key] - from[key], duration);
      } else {
        // Copy the value.  TODO: HANDLE COLORS
        tweened[key] = to[key];
      }
    }
  }
  //console.log("TWEEN");
  //console.log(from);
  //console.log(to);
  //console.log(tweened);
  return tweened;
}