library maintoolpane;

import 'dart:html';
import 'html5animator.dart' as animator;
import 'package:web_ui/web_ui.dart';


/** Main panel of tool buttons and images. */
class MainToolPaneComponent extends WebComponent {
  addImage() => animator.addImage();
  addText() => animator.addText();
  addLine() => animator.addLine();
  addBox() => animator.addBox();
  addEllipse() => animator.addEllipse();
  addTriangle() => animator.addTriangle();
}
