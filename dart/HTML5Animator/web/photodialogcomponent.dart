library photodialog;

import 'dart:async'
import 'dart:html';
import 'html5animator.dart';
import 'imagePalette.dart';
import 'modaldialogcomponent.dart';
import 'package:web_ui/web_ui.dart';


/** Upload photo dialog. */
class PhotoDialogComponent extends WebComponent {
  void created() {
    // Workarount web_ui bug passing function as template param...
    _root.query('#photoDialog').xtag.onCloseFn = handleClose;
    _root.query('#photoDialog').onDrop.listen(handleDrop);
  }
  
  handleClose() => movieState.isPhotoDialogShowing = false;
  
  void handleDrop(MouseEvent e) {
    onDropFn(e);
    closeAfterDelay();
  }
  
  addPhoto() {
    InputElement inputEl = query('#photoUrlInput');
    addUnsafeUrlImageToPalette(inputEl.value);
    closeAfterDelay();
  }
  
  void closeAfterDelay() {
    new Timer(const Duration(milliseconds: 500),
        () => _root.query('#photoDialog').xtag.handleClose());
  }
}
