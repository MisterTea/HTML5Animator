library imagepalette;
import 'package:web_ui/web_ui.dart';
import 'dart:html';
import 'dart:uri';


class ImagePalette extends WebComponent {
  
  @observable
  List<String> image_uris = toObservable(new List<String>());
  @observable
  String input_value = "";

  void addEntry() {
    window.console.debug("Adding url "+input_value);
    image_uris.add(input_value);
    input_value = "";
  }
}


void addImageToPalette(String url){
  var palette = query("#image-palette");
  if (palette != null && palette.xtag != null){
    palette.xtag.image_uris.add(url);
  }
}

