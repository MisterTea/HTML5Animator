library imagepalette;
import 'package:web_ui/web_ui.dart';


class ImagePalette extends WebComponent {
  
  List<String> image_urls = new List<String>();
  String input_value = "";

  void addEntry() {
    image_urls.add(input_value);
    input_value = "";
  }
}

