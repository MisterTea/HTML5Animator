part of html5animator;

var chr = [];

class ByteArray {
    List<int> bin = [];
    
    List<int> getData() {
      return bin;
    }
    
    void writeByte(int byte) {
      bin.add(byte);
    }

    void writeUTFBytes(String string){
      for(var l = string.length, i = 0; i < l; i++)
        this.writeByte(string.codeUnits[i]);
    }
    
    void writeBytes(List<int> array, int offset, int length){
      if (offset == null) {
        offset = 0;
      }
      if (length == null) {
        length = array.length;
      }
      for(int i = offset; i < length; i++)
        this.writeByte(array[i]);
    }
}

  class GIFEncoder
  {
    
    
    GIFEncoder() {
      if (chr.length == 0) {
        for(num i = 0; i < 256; i++)
          chr.add(new String.fromCharCode(i));
      }
    }
        
    /*private*/ int width/*int*/; // image size
      /*private*/ int height/*int*/;
      /*private*/ var transparent/***/ = null; // transparent color if given
      /*private*/ int transIndex/*int*/; // transparent index in color table
      /*private*/ int repeat/*int*/ = -1; // no repeat
      /*private*/ int delay/*int*/ = 0; // frame delay (hundredths)
      /*private*/ bool started/*Boolean*/ = false; // ready to output frames
      /*private*/ var out/*ByteArray*/;
      /*private*/ var image/*Bitmap*/; // current frame
      /*private*/ List<int> pixels/*ByteArray*/; // BGR byte array from frame
      /*private*/ var indexedPixels/*ByteArray*/; // converted frame indexed to palette
      /*private*/ int colorDepth/*int*/; // number of bit planes
      /*private*/ List<int> colorTab/*ByteArray*/; // RGB palette
      /*private*/ var usedEntry/*Array*/ = new List(256*1024); // active palette entries
      /*private*/ int palSize/*int*/ = 7; // color table size (bits-1)
      /*private*/ int dispose/*int*/ = -1; // disposal code (-1 = use default)
      /*private*/ bool closeStream/*Boolean*/ = false; // close stream when finished
      /*private*/ bool firstFrame/*Boolean*/ = true;
      /*private*/ bool sizeSet/*Boolean*/ = false; // if false, get size from first frame
      /*private*/ int sample/*int*/ = 10; // default sample interval for quantizer
    
    /**
    * Sets the delay time between each frame, or changes it for subsequent frames
    * (applies to last frame added)
    * int delay time in milliseconds
    * @param ms
    */
    
    void setDelay(int ms)
    {
      delay = (ms / 10).round();
    }
    
    /**
    * Sets the GIF frame disposal code for the last added frame and any
    * 
    * subsequent frames. Default is 0 if no transparent color has been set,
    * otherwise 2.
    * @param code
    * int disposal code.
    */
    
    void setDispose(int code/*int*/)/*void*/ 
    {
      
      if (code >= 0) dispose = code;
      
    }
    
    /**
    * Sets the number of times the set of GIF frames should be played. Default is
    * 1; 0 means play indefinitely. Must be invoked before the first image is
    * added.
    * 
    * @param iter
    * int number of iterations.
    * @return
    */
    
    void setRepeat(int iter/*int*/)/*void*/ 
    {
      
      if (iter >= 0) repeat = iter;
      
    }
    
    /**
    * Sets the transparent color for the last added frame and any subsequent
    * frames. Since all colors are subject to modification in the quantization
    * process, the color in the final palette for each frame closest to the given
    * color becomes the transparent color for that frame. May be set to null to
    * indicate no transparent color.
    * @param
    * Color to be treated as transparent on display.
    */
    
    void setTransparent(num c/*Number*/)/*void*/
    {
      
      transparent = c;
      
    }
    
    /**
    * The addFrame method takes an incoming BitmapData object to create each frames
    * @param
    * BitmapData object to be treated as a GIF's frame
    */
    bool addFrameFromId(String id/*string*/) {
      return addFrame(document.query('#'+id).getContext('2d'), false);
    }
    
    bool addFrame(var im/*BitmapData*/, bool is_imageData)/*Boolean*/
    {
      
      if ((im == null) || !started || out == null) 
      {
        throw new Exception("Please call start method before calling addFrame");
        return false;
      }
      
        var ok/*Boolean*/ = true;
      
        if(!is_imageData){
          image = im.getImageData(0,0, im.canvas.width, im.canvas.height).data;
          if (!sizeSet) setSize(im.canvas.width, im.canvas.height);
        }else{
          image = im;
        }
        getImagePixels(); // convert to correct format if necessary
        print("START PIXELS");
        analyzePixels(); // build color table & map pixels
        print("END PIXELS");
        
        if (firstFrame) 
        {
          writeLSD(); // logical screen descriptior
          writePalette(); // global color table
          if (repeat >= 0) 
          {
            // use NS app extension to indicate reps
            writeNetscapeExt();
          }
          }
        
        writeGraphicCtrlExt(); // write graphic control extension
          writeImageDesc(); // image descriptor
          if (!firstFrame) writePalette(); // local color table
          writePixels(); // encode and write pixel data
          firstFrame = false;
        
      return ok;
      
    }
    
    /**
    * Adds final trailer to the GIF stream, if you don't call the finish method
    * the GIF stream will not be valid.
    */
    
    bool finish()/*Boolean*/
    {
        if (!started) return false;
        var ok/*Boolean*/ = true;
        started = false;
        try {
          out.writeByte(0x3b); // gif trailer
        } catch (e/*Error*/) {
          ok = false;
        }
  
        return ok;
      
    }
    
    /**
    * Resets some members so that a new stream can be started.
    * This method is actually called by the start method
    */
    
    void reset ( )/*void*/
    {
      
      // reset for subsequent use
      transIndex = 0;
      image = null;
        pixels = null;
        indexedPixels = null;
        colorTab = null;
        closeStream = false;
        firstFrame = true;
      
    }

    /**
    * * Sets frame rate in frames per second. Equivalent to
    * <code>setDelay(1000/fps)</code>.
    * @param fps
    * float frame rate (frames per second)         
    */
    
    void setFrameRate(num fps/*Number*/)/*void*/ 
    {
      
      if (fps != 0xf) delay = (100/fps).round();
      
    }
    
    /**
    * Sets quality of color quantization (conversion of images to the maximum 256
    * colors allowed by the GIF specification). Lower values (minimum = 1)
    * produce better colors, but slow processing significantly. 10 is the
    * default, and produces good color mapping at reasonable speeds. Values
    * greater than 20 do not yield significant improvements in speed.
    * @param quality
    * int greater than 0.
    * @return
    */
    
    void setQuality(int quality/*int*/)/*void*/
    {
      
        if (quality < 1) quality = 1;
        sample = quality;
      
    }
    
    /**
    * Sets the GIF frame size. The default size is the size of the first frame
    * added if this method is not invoked.
    * @param w
    * int frame width.
    * @param h
    * int frame width.
    */
    
    void setSize(int w/*int*/, int h/*int*/)/*void*/
    {
      
      if (started && !firstFrame) return;
        width = w;
        height = h;
        if (width < 1)width = 320;
        if (height < 1)height = 240;
        sizeSet = true;
      
    }
    
    /**
    * Initiates GIF file creation on the given stream.
    * @param os
    * OutputStream on which GIF images are written.
    * @return false if initial write failed.
    * 
    */
    
    bool start()/*Boolean*/
    {
      
      reset(); 
        bool ok = true;
        closeStream = false;
        out = new ByteArray(); 
        out.writeUTFBytes("GIF89a"); // header
      
        return started = ok;
      
    }
    
    bool cont()/*Boolean*/
    {
      
        reset(); 
        var ok/*Boolean*/ = true;
        closeStream = false;
        out = new ByteArray();
      
        return started = ok;
      
    }
    
    /**
    * Analyzes image colors and creates color map.
    */
    
    void analyzePixels()/*void*/
    {
        
      int len/*int*/ = pixels.length;
      int nPix/*int*/ = (len / 3).floor();
        indexedPixels = [];
        NeuQuant nq/*NeuQuant*/ = new NeuQuant(pixels, len, sample);
        // initialize quantizer
        colorTab = nq.process(); // create reduced palette
        // map image pixels to new palette
        int k/*int*/ = 0;
        for (int j/*int*/ = 0; j < nPix; j++) {
          int index/*int*/ = nq.map(pixels[k++] & 0xff, pixels[k++] & 0xff, pixels[k++] & 0xff);
          usedEntry[index] = true;
          indexedPixels.add(index);
        }
        pixels = null;
        colorDepth = 8;
        palSize = 7;
        // get closest match to transparent color if specified
        if (transparent != null) {
          transIndex = findClosest(transparent);
        }
    }
    
    /**
    * Returns index of palette color closest to c
    *
    */
    
    num findClosest(int c/*Number*/)/*int*/
    {
      
      if (colorTab == null) return -1;
        var r/*int*/ = (c & 0xFF0000) >> 16;
        var g/*int*/ = (c & 0x00FF00) >> 8;
        var b/*int*/ = (c & 0x0000FF);
        var minpos/*int*/ = 0;
        var dmin/*int*/ = 256 * 256 * 256;
        var len/*int*/ = colorTab.length;
      
        for (var i/*int*/ = 0; i < len;) {
          var dr/*int*/ = r - (colorTab[i++] & 0xff);
          var dg/*int*/ = g - (colorTab[i++] & 0xff);
          var db/*int*/ = b - (colorTab[i] & 0xff);
          var d/*int*/ = dr * dr + dg * dg + db * db;
          var index/*int*/ = i / 3;
          if (usedEntry[index] && (d < dmin)) {
            dmin = d;
            minpos = index;
          }
          i++;
        }
        return minpos;
      
    }
    
    /**
    * Extracts image pixels into byte array "pixels
    */
    
    void getImagePixels()/*void*/
    {
        
        int w/*int*/ = width;
        int h/*int*/ = height;
        pixels = new List<int>(h*w*3);
        var data = image;
        
        int x=0;
        for ( int i/*int*/ = 0; i < h; i++ )
        {
          
          for (int j/*int*/ = 0; j < w; j++ )
          {
            
            int b = (i*w*4)+j*4;
              pixels[x++] = (data[b]);
              pixels[x++] = (data[b+1]);
              pixels[x++] = (data[b+2]);
            
          }
          
        }
        
    }
    
    /**
    * Writes Graphic Control Extension
    */
    
    void writeGraphicCtrlExt()/*void*/
    {
      out.writeByte(0x21); // extension introducer
        out.writeByte(0xf9); // GCE label
        out.writeByte(4); // data block size
        var transp/*int*/;
        var disp/*int*/;
        if (transparent == null) {
          transp = 0;
          disp = 0; // dispose = no action
        } else {
          transp = 1;
          disp = 2; // force clear if using transparent color
        }
        if (dispose >= 0) {
          disp = dispose & 7; // user override
        }
        disp <<= 2;
        // packed fields
        out.writeByte(0 | // 1:3 reserved
            disp | // 4:6 disposal
            0 | // 7 user input - 0 = none
            transp); // 8 transparency flag
    
        WriteShort(delay); // delay x 1/100 sec
        out.writeByte(transIndex); // transparent color index
        out.writeByte(0); // block terminator
      
    }
      
    /**
    * Writes Image Descriptor
    */
    
    void writeImageDesc()/*void*/
    {
        
        out.writeByte(0x2c); // image separator
        WriteShort(0); // image position x,y = 0,0
        WriteShort(0);
        WriteShort(width); // image size
        WriteShort(height);

        // packed fields
        if (firstFrame) {
          // no LCT - GCT is used for first (or only) frame
          out.writeByte(0);
        } else {
          // specify normal LCT
          out.writeByte(0x80 | // 1 local color table 1=yes
              0 | // 2 interlace - 0=no
              0 | // 3 sorted - 0=no
              0 | // 4-5 reserved
              palSize); // 6-8 size of color table
        }
    }
    
    /**
    * Writes Logical Screen Descriptor
    */
    
    void writeLSD()/*void*/
    {
      
      // logical screen size
        WriteShort(width);
        WriteShort(height);
        // packed fields
        out.writeByte((0x80 | // 1 : global color table flag = 1 (gct used)
            0x70 | // 2-4 : color resolution = 7
            0x00 | // 5 : gct sort flag = 0
            palSize)); // 6-8 : gct size
    
        out.writeByte(0); // background color index
        out.writeByte(0); // pixel aspect ratio - assume 1:1
      
    }
    
    /**
    * Writes Netscape application extension to define repeat count.
    */
    
    void writeNetscapeExt()/*void*/
    {
      
        out.writeByte(0x21); // extension introducer
        out.writeByte(0xff); // app extension label
        out.writeByte(11); // block size
        out.writeUTFBytes("NETSCAPE" + "2.0"); // app id + auth code
        out.writeByte(3); // sub-block size
        out.writeByte(1); // loop sub-block id
        WriteShort(repeat); // loop count (extra iterations, 0=repeat forever)
        out.writeByte(0); // block terminator
    
    }
    
    /**
    * Writes color table
    */
    
    void writePalette()/*void*/
    {
        out.writeBytes(colorTab, 0, colorTab.length);
        var n/*int*/ = (3 * 256) - colorTab.length;
        for (var i/*int*/ = 0; i < n; i++) out.writeByte(0);
      
    }
    
    void WriteShort (int pValue/*int*/)/*void*/
    {   
      
        out.writeByte( pValue & 0xFF );
        out.writeByte( (pValue >> 8) & 0xFF);
      
    }
    
    /**
    * Encodes and writes pixel data
    */
    
    void writePixels()/*void*/
    {
      
      LZWEncoder myencoder/*LZWEncoder*/ = new LZWEncoder(width, height, indexedPixels, colorDepth);
        myencoder.encode(out);
      
    }
    
    /**
    * retrieves the GIF stream
    */
    ByteArray stream ( )/*ByteArray*/
    {
      
      return out; 
      
    }
    
    void setProperties(var has_start, var is_first){
      started = has_start;
      firstFrame = is_first;
      //out = new ByteArray; //??
    }
      
  }


