part of html5animator;

/**
* This class handles LZW encoding
* Adapted from Jef Poskanzer's Java port by way of J. M. G. Elliott.
* @author Kevin Weiner (original Java version - kweiner@fmsware.com)
* @author Thibault Imbert (AS3 version - bytearray.org)
* @version 0.1 AS3 implementation
*/

  //import flash.utils.ByteArray;
  
  class LZWEncoder
  {
    /*private_static*/ int EOF/*int*/ = -1;
    /*private*/ int imgW/*int*/;
    /*private*/ int imgH/*int*/;
    /*private*/ var pixAry/*ByteArray*/;
    /*private*/ int initCodeSize/*int*/;
    /*private*/ int remaining/*int*/;
    /*private*/ int curPixel/*int*/;
    
    // GIFCOMPR.C - GIF Image compression routines
    // Lempel-Ziv compression based on 'compress'. GIF modifications by
    // David Rowley (mgardi@watdcsu.waterloo.edu)
    // General DEFINEs
    
    /*private_static*/ static int BITS/*int*/ = 12;
    /*private_static*/ static int HSIZE/*int*/ = 5003; // 80% occupancy
    
    // GIF Image compression - modified 'compress'
    // Based on: compress.c - File compression ala IEEE Computer, June 1984.
    // By Authors: Spencer W. Thomas (decvax!harpo!utah-cs!utah-gr!thomas)
    // Jim McKie (decvax!mcvax!jim)
    // Steve Davies (decvax!vax135!petsd!peora!srd)
    // Ken Turkowski (decvax!decwrl!turtlevax!ken)
    // James A. Woods (decvax!ihnp4!ames!jaw)
    // Joe Orost (decvax!vax135!petsd!joe)
    
    /*private*/ int n_bits/*int*/; // number of bits/code
    /*private*/ int maxbits/*int*/ = BITS; // user settable max # bits/code
    /*private*/ int maxcode/*int*/; // maximum code, given n_bits
    /*private*/ int maxmaxcode/*int*/ = 1 << BITS; // should NEVER generate this code
    /*private*/ var htab/*Array*/ = new List();
    /*private*/ var codetab/*Array*/ = new List(256*1024);
    /*private*/ int hsize/*int*/ = HSIZE; // for dynamic table sizing
    /*private*/ int free_ent/*int*/ = 0; // first unused entry
    
    // block compression parameters -- after all codes are used up,
    // and compression rate changes, start over.
    
    /*private*/ bool clear_flg/*Boolean*/ = false;
    
    // Algorithm: use open addressing double hashing (no chaining) on the
    // prefix code / next character combination. We do a variant of Knuth's
    // algorithm D (vol. 3, sec. 6.4) along with G. Knott's relatively-prime
    // secondary probe. Here, the modular division first probe is gives way
    // to a faster exclusive-or manipulation. Also do block compression with
    // an adaptive reset, whereby the code table is cleared when the compression
    // ratio decreases, but after the table fills. The variable-length output
    // codes are re-sized at this point, and a special CLEAR code is generated
    // for the decompressor. Late addition: construct the table according to
    // file size for noticeable speed improvement on small files. Please direct
    // questions about this implementation to ames!jaw.
    
    /*private*/ int g_init_bits/*int*/;
    /*private*/ int ClearCode/*int*/;
    /*private*/ int EOFCode/*int*/;
    
    // output
    // Output the given code.
    // Inputs:
    // code: A n_bits-bit integer. If == -1, then EOF. This assumes
    // that n_bits =< wordsize - 1.
    // Outputs:
    // Outputs code to the file.
    // Assumptions:
    // Chars are 8 bits long.
    // Algorithm:
    // Maintain a BITS character long buffer (so that 8 codes will
    // fit in it exactly). Use the VAX insv instruction to insert each
    // code in turn. When the buffer fills up empty it and start over.
    
    /*private*/ int cur_accum/*int*/ = 0;
    /*private*/ int cur_bits/*int*/ = 0;
    /*private*/ List<int> masks/*Array*/ = [ 0x0000, 0x0001, 0x0003, 0x0007, 0x000F, 0x001F, 0x003F, 0x007F, 0x00FF, 0x01FF, 0x03FF, 0x07FF, 0x0FFF, 0x1FFF, 0x3FFF, 0x7FFF, 0xFFFF ];
    
    // Number of characters so far in this 'packet'
    /*private*/ int a_count/*int*/;
    
    // Define the storage for the packet accumulator
    /*private*/ var accum/*ByteArray*/ = new List(256*1024);
    
    LZWEncoder(int width/*int*/, int height/*int*/, var pixels/*ByteArray*/, int color_depth/*int*/)
    {
      
      imgW = width;
      imgH = height;
      pixAry = pixels;
      initCodeSize = Math.max(2, color_depth);
      
    }
    
    // Add a character to the end of the current packet, and if it is 254
    // characters, flush the packet to disk.
    void char_out(num c/*Number*/, ByteArray outs/*ByteArray*/)/*void*/
    {
      accum[a_count++] = c;
      if (a_count >= 254) flush_char(outs);
      
    }
    
    // Clear out the hash table
    // table clear for block compress
    
    void cl_block(ByteArray outs/*ByteArray*/)/*void*/
    {
      
      cl_hash(hsize);
      free_ent = ClearCode + 2;
      clear_flg = true;
      output(ClearCode, outs);
      
    }
    
    // reset code table
    void cl_hash(num hsize/*int*/)/*void*/
    {
      htab.clear();
      for (var i/*int*/ = 0; i < hsize; ++i) htab.add(-1);
      
    }
    
    void compress(int init_bits/*int*/, ByteArray outs/*ByteArray*/)/*void*/
    
    {
      int fcode/*int*/;
      int i/*int*/ /* = 0 */;
      int c/*int*/;
      int ent/*int*/;
      int disp/*int*/;
      int hsize_reg/*int*/;
      int hshift/*int*/;
      
      // Set up the globals: g_init_bits - initial number of bits
      g_init_bits = init_bits;
      
      // Set up the necessary values
      clear_flg = false;
      n_bits = g_init_bits;
      maxcode = MAXCODE(n_bits);
  
      ClearCode = 1 << (init_bits - 1);
      EOFCode = ClearCode + 1;
      free_ent = ClearCode + 2;
  
      a_count = 0; // clear packet
    
      ent = nextPixel();
  
      hshift = 0;
      for (fcode = hsize; fcode < 65536; fcode *= 2)
        ++hshift;
      hshift = 8 - hshift; // set hash code range bound
  
      hsize_reg = hsize;
      cl_hash(hsize_reg); // clear hash table
    
      output(ClearCode, outs);
    
      outer_loop: while ((c = nextPixel()) != EOF)
      
      {
        
        fcode = (c << maxbits) + ent;
        i = (c << hshift) ^ ent; // xor hashing
  
        if (htab[i] == fcode)
        {
        ent = codetab[i];
        continue;
        } else if (htab[i] >= 0) // non-empty slot
        {
          disp = hsize_reg - i; // secondary hash (after G. Knott)
          if (i == 0)
          disp = 1;
          do 
          {
            
            if ((i -= disp) < 0) i += hsize_reg;
  
            if (htab[i] == fcode)
            {
            ent = codetab[i];
            continue outer_loop;
            }
          } while (htab[i] >= 0);
        }
        
        output(ent, outs);
        ent = c;
        if (free_ent < maxmaxcode)
        {
          codetab[i] = free_ent++; // code -> hashtable
          htab[i] = fcode;
        } else cl_block(outs);
      }
      
      // Put out the final code.
      output(ent, outs);
      output(EOFCode, outs);
      
    }
    
    // ----------------------------------------------------------------------------
    void encode(ByteArray os/*ByteArray*/)/*void*/
    {
      os.writeByte(initCodeSize); // write "initial code size" byte
      remaining = imgW * imgH; // reset navigation variables
      curPixel = 0;
      compress(initCodeSize + 1, os); // compress and write the pixel data
      os.writeByte(0); // write block terminator
      
    }
    
    // Flush the packet to disk, and reset the accumulator
    void flush_char(ByteArray outs/*ByteArray*/)/*void*/
    {
      print('FLUSHING BYTES');
      print(a_count);
      if (a_count > 0)
      {
        outs.writeByte(a_count);
        outs.writeBytes(accum, 0, a_count);
        a_count = 0;
      }
      
    }
    
    num MAXCODE(num n_bits/*int*/)/*int*/
    {
      
      return (1 << n_bits) - 1;
      
    }
    
    // ----------------------------------------------------------------------------
    // Return the next pixel from the image
    // ----------------------------------------------------------------------------
    
    num nextPixel()/*int*/
    {
      
      if (remaining == 0) return EOF;
      
      --remaining;
      
      var pix/*Number*/ = pixAry[curPixel++];
      
      return pix & 0xff;
      
    }
    
    void output(int code/*int*/, ByteArray outs/*ByteArray*/)/*void*/
    
    {
      cur_accum &= masks[cur_bits];
      
      if (cur_bits > 0) cur_accum |= (code << cur_bits);
      else cur_accum = code;
      
      cur_bits += n_bits;
      
      while (cur_bits >= 8)
      
      {
        
        char_out((cur_accum & 0xff), outs);
        cur_accum >>= 8;
        cur_bits -= 8;
        
      }
      
      // If the next entry is going to be too big for the code size,
      // then increase it, if possible.
      
      if (free_ent > maxcode || clear_flg)
      {
        
        if (clear_flg)
        {
          
          maxcode = MAXCODE(n_bits = g_init_bits);
          clear_flg = false;
          
        } else
        {
          
          ++n_bits;
          
          if (n_bits == maxbits) maxcode = maxmaxcode;
          
          else maxcode = MAXCODE(n_bits);
          
        }
        
      }
      
      if (code == EOFCode) 
      {
        
        // At EOF, write the rest of the buffer.
        while (cur_bits > 0) 
        {
          
          char_out((cur_accum & 0xff), outs);
          cur_accum >>= 8;
          cur_bits -= 8;
        }
        
        
        flush_char(outs);
        
      }
      
    }
  }
  


