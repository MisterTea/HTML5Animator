library timeline;

import 'dart:html';
import 'dart:math' as math;
import 'html5animator.dart';
import 'package:web_ui/watcher.dart' as watcher;
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
    
    // Listen for changes to movie state and redraw.
    watcher.watch(() => movie.maxFrames, (_) => redrawFrames());
    watcher.watch(() => movieState.frame, (_) => redrawFrames());
    watcher.watch(() => movieState.keyFrames, (_) => redrawFrames());
  }
  
  void redrawFrames() {
    // Update canvas width to accomodate number of frames + padding.
    var width = movie.maxFrames * FRAME_WIDTH_PX + 2 * SIDE_PADDING_PX;
    framesContainer.style.width = width.toString() + 'px';
    framesCanvas.width = width;
    var height = framesCanvas.height;
    
    CanvasRenderingContext2D context = framesCanvas.getContext('2d');
    var startX = getFrameStartX();
    var endX = getFrameEndX();
    
    // Highlight the current frame.
    context.fillStyle = '#aac';
    context.fillRect(startX + movieState.frame * FRAME_WIDTH_PX, 0, 
        FRAME_WIDTH_PX, height);
    maybeScrollIntoView();
    
    // Draw vertical lines for each frame.
    context.beginPath();
    for (int i = 0; i < movie.maxFrames + 1; i++) {
      var x = startX + i * FRAME_WIDTH_PX;
      context.moveTo(x, 0);
      context.lineTo(x, height);
    }
    context.strokeStyle = '#999';
    context.stroke();

    // Draw circles for any keyframes.
    for (int keyFrame in movieState.keyFrames) {
      var x = startX + keyFrame * FRAME_WIDTH_PX + FRAME_WIDTH_PX / 2;
      
      context.beginPath();
      context.arc(x, height / 2, 3, 0, 2 * math.PI, false);
      context.closePath();
      context.fillStyle = '#333';
      context.fill();
    }
    
    // Draw top and bottom border lines.
    context.beginPath();
    context.moveTo(startX, 0.5);
    context.lineTo(endX, 0.5);
    context.moveTo(startX, height - 0.5);
    context.lineTo(endX, height - 0.5);
    context.strokeStyle = '2px #000';
    context.stroke();
  }
  
  void maybeScrollIntoView() {
    int minXInView = getScrollLeft();
    double maxXInView = minXInView + getViewableWidth();
    
    double frameStartX = getFrameStartX() + movieState.frame * FRAME_WIDTH_PX;
    double frameEndX = frameStartX + FRAME_WIDTH_PX;
    
    if (frameStartX < minXInView) {
      setScrollLeft(frameStartX - SIDE_PADDING_PX);
    } else if (maxXInView < frameEndX) {
      setScrollLeft(frameEndX + SIDE_PADDING_PX - getViewableWidth());
    }
  }
  
  int getScrollLeft() {
    return framesContainer.parent.scrollLeft;
  }
  
  void setScrollLeft(double scrollLeft) {
    framesContainer.parent.scrollLeft = scrollLeft.floor();
  }
  
  num getViewableWidth() {
    return framesContainer.parent.getBoundingClientRect().width;
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
        screenPoint.x + getScrollLeft() - framesCanvas.offsetLeft,
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
