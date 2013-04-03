library imagepalette;
import 'package:web_ui/web_ui.dart';
import 'dart:html';
import 'dart:uri';


class ImagePalette extends WebComponent {
  
  List<SafeUri> image_urls = new List<SafeUri>();
  String input_value = "";
  


  void addEntry() {
    image_urls.add(new SafeUri.unsafe(input_value));
    input_value = "";
  }
}


void addImageToPalette(String url){
  var palette = query("#image-palette");
  if (palette != null && palette.xtag != null){
    SafeUri uri = new SafeUri.unsafe(url);
    palette.xtag.image_urls.add(uri);
  }
}

