library imagepalette;
import 'package:web_ui/web_ui.dart';
import 'dart:html';
import 'dart:uri';


@observable
class ImagePalette extends WebComponent {
  
  List<String> image_uris = new ObservableList<String>();
  String input_value = "";

  void addEntry() {
    String final_url = "http://" + window.location.host + "/out/___IMAGE___" + input_value;
    window.console.debug("Adding url "+input_value + " (" + final_url + ")");
    image_uris.add(final_url);
    input_value = "";
  }
}


void addImageToPalette(String url){
  var palette = query("#image-palette");
  if (palette != null && palette.xtag != null){
    palette.xtag.image_uris.add(url);
  }
}

