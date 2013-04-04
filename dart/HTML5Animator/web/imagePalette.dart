library imagepalette;

import 'package:web_ui/web_ui.dart';
import 'dart:html';
import 'dart:uri';


@observable
class ImagePalette extends WebComponent {
  List<String> image_uris = new ObservableList<String>();
}


void addUnsafeUrlImageToPalette(String url) {
  String proxyUrl = "http://" + window.location.host + "/out/___IMAGE___" + url;
  window.console.debug("Adding url " + url + " (" + proxyUrl + ")");
  addImageToPalette(proxyUrl);
}


void addImageToPalette(String url){
  var palette = query("#image-palette");
  if (palette != null && palette.xtag != null){
    palette.xtag.image_uris.add(url);
  }
}

