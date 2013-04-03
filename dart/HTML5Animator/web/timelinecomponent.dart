library timeline;

import 'dart:html';
import 'html5animator.dart';
import 'package:web_ui/web_ui.dart';

/** Timeline to navigate between frames and show keyframes. */
class TimelineComponent extends WebComponent {
  final int FRAME_WIDTH_PX = 12;
  final int SIDE_PADDING_PX = 6;
  
  DivElement framesContainer;
  CanvasElement framesCanvas;
  
  /** Called once this component enters the DOM. */
  void inserted() {
    framesContainer = query('#framesContainer');
    framesCanvas = query('#frames');
    redrawFrames();
  }
  
  void redrawFrames() {
    // Update canvas width to accomodate number of frames + padding.
    var width = movie.maxFrames * FRAME_WIDTH_PX + 2 * SIDE_PADDING_PX;
    framesContainer.style.width = width.toString() + 'px';
    framesCanvas.width = width;
    var height = framesCanvas.height;
    
    CanvasRenderingContext2D context = framesCanvas.getContext('2d');

    // Note: Half-pixel align for crisper lines.
    var startX = getFrameStartX();
    var endX = getFrameEndX();
    
    // Highlight the current frame.
    context.fillStyle = '#aac';
    context.fillRect(startX + movieState.frame * FRAME_WIDTH_PX, 0, 
        FRAME_WIDTH_PX, height);
    
    // Draw vertical lines for each frame.
    context.beginPath();
    for (var x = startX; x <= endX; x += FRAME_WIDTH_PX) {
      context.moveTo(x, 0);
      context.lineTo(x, height);
    }
    context.strokeStyle = '#999';
    context.stroke();
    
    // Draw top and bottom border lines.
    context.beginPath();
    context.moveTo(startX, 0.5);
    context.lineTo(endX, 0.5);
    context.moveTo(startX, height - 0.5);
    context.lineTo(endX, height - 0.5);
    context.strokeStyle = '2px #000';
    context.stroke();
  }
  
  void handleClick(MouseEvent e) {
    int frameIndex = getFrameIndexUnder(toCanvasCoordinates(e.page));
    
    if (frameIndex != null && frameIndex != movieState.frame) {
      switchToFrame(frameIndex);
    }
  }
  
  void switchToFrame(int frameIndex) {
    if (frameIndex != movieState.frame) {
      movieState.frame = frameIndex;
      redrawFrames();
    }
  }
  
  double getFrameStartX() {
    // Note: Half-pixel align for crisper lines.
    return SIDE_PADDING_PX - 0.5;
  }
  
  double getFrameEndX() {
    return getFrameStartX() + movie.maxFrames * FRAME_WIDTH_PX;
  }
  
  Point toCanvasCoordinates(Point screenPoint) {
    return new Point(
        screenPoint.x + framesContainer.parent.scrollLeft
            - framesCanvas.offsetLeft,
        screenPoint.y - framesCanvas.offsetTop);
  }
  
  int getFrameIndexUnder(Point p) {
    if (p.y < 0 || framesCanvas.height < p.y
        || p.x < getFrameStartX() || getFrameEndX() < p.x) {
      return null;
    }
    
    double frameIndex = (p.x - getFrameStartX()) / FRAME_WIDTH_PX;
    return frameIndex.floor();
  }
}
