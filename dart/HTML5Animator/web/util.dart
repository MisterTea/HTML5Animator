part of html5animator;

String randomString() {
  var rng = new Math.Random();
  String chars = "123456789qwertyuiopasdfghjklzxcvbnm";
  int string_length = 16;
  String randomstring = '';
  for ( var i = 0; i < string_length; i++) {
    int rnum = (rng.nextDouble() * chars.length).floor();
    randomstring += chars.substring(rnum, rnum + 1);
  }
  return randomstring;
}


