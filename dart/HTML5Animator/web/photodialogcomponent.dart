library photodialog;

import 'dart:html';
import 'html5animator.dart';
import 'modaldialogcomponent.dart';
import 'package:web_ui/web_ui.dart';


/** Upload photo dialog. */
class PhotoDialogComponent extends WebComponent {
  void created() {
    _root.query('#photoDialog').xtag.onCloseFn = handleClose;
  }
  
  handleClose() => movieState.isPhotoDialogShowing = false;
}
