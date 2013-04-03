part of html5animator;

String encode64(String input) {
  String output = "";
  int i = 0;
  int l = input.length;
  String key = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
  int chr1, chr2, chr3, enc1, enc2, enc3, enc4;
  while (i < l) {
    chr1 = input.codeUnits[i++];
    chr2 = input.length>i ? input.codeUnits[i++] : -999;
    chr3 = input.length>i ? input.codeUnits[i++] : -999;
    enc1 = chr1 >> 2;
    enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
    enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
    enc4 = chr3 & 63;
    if (chr2 == -999) {
      enc2 = ((chr1 & 3) << 4);
      enc3 = enc4 = 64;
    } else if (chr3 == -999) {
      enc3 = ((chr2 & 15) << 2);
      enc4 = 64;
    }
    output = output + key[enc1] + key[enc2] + key[enc3] + key[enc4];
  }
  return output;
}


