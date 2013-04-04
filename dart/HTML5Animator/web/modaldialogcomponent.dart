library modaldialog;

import 'dart:html';
import 'package:web_ui/web_ui.dart';


/** Basic modal dialog. */
class ModalDialogComponent extends WebComponent {
  final String OVERLAY_MASK_ID = 'dialogoverlay';
  
  /** Called once this component enters the DOM. */
  void inserted() {
    if (getOverlayMaskEl() != null) {
      return;
    }
    
    // Add overlay mask.
    var overlayMaskEl = new DivElement();
    overlayMaskEl.classes.add('modalDialogOverlayMask');
    overlayMaskEl.id = OVERLAY_MASK_ID;
    document.body.children.add(overlayMaskEl);
  }
  
  /** Called when this component is removed from the DOM. */
  void removed() {
    Element overlayMaskEl = getOverlayMaskEl();
    if (overlayMaskEl != null) {
      overlayMaskEl.remove();
    }
  }
  
  Element getOverlayMaskEl() {
    return document.query('#' + OVERLAY_MASK_ID);
  }
  
  void handleClose() {
    removed();  // Make sure to cleanup overlay.
    remove();
  }
}
