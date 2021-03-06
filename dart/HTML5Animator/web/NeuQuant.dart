part of html5animator;


/*
* NeuQuant Neural-Net Quantization Algorithm
* ------------------------------------------
* 
* Copyright (c) 1994 Anthony Dekker
* 
* NEUQUANT Neural-Net quantization algorithm by Anthony Dekker, 1994. See
* "Kohonen neural networks for optimal colour quantization" in "Network:
* Computation in Neural Systems" Vol. 5 (1994) pp 351-367. for a discussion of
* the algorithm.
* 
* Any party obtaining a copy of these files from the author, directly or
* indirectly, is granted, free of charge, a full and unrestricted irrevocable,
* world-wide, paid up, royalty-free, nonexclusive right and license to deal in
* this software and documentation files (the "Software"), including without
* limitation the rights to use, copy, modify, merge, publish, distribute,
* sublicense, and/or sell copies of the Software, and to permit persons who
* receive copies from any such party to do so, with the only requirement being
* that this copyright notice remain intact.
*/
 
  //import flash.utils.ByteArray;
  
  class NeuQuant
  {
    /*private_static*/ static int netsize/*int*/ = 256; /* number of colours used */
    
    /* four primes near 500 - assume no image has a length so large */
    /* that it is divisible by all four primes */
    
    /*private_static*/ static int prime1/*int*/ = 499;
    /*private_static*/ static int prime2/*int*/ = 491;
    /*private_static*/ static int prime3/*int*/ = 487;
    /*private_static*/ static int prime4/*int*/ = 503;
    /*private_static*/ static int minpicturebytes/*int*/ = (3 * prime4);
    
    /* minimum size for input image */
    /*
    * Program Skeleton ---------------- [select samplefac in range 1..30] [read
    * image from input file] pic = (unsigned char*) malloc(3*width*height);
    * initnet(pic,3*width*height,samplefac); learn(); unbiasnet(); [write output
    * image header, using writecolourmap(f)] inxbuild(); write output image using
    * inxsearch(b,g,r)
    */

    /*
    * Network Definitions -------------------
    */
    
    /*private_static*/ static int maxnetpos/*int*/ = (netsize - 1);
    /*private_static*/ static int netbiasshift/*int*/ = 4; /* bias for colour values */
    /*private_static*/ static int ncycles/*int*/ = 100; /* no. of learning cycles */
    
    /* defs for freq and bias */
    /*private_static*/ static int intbiasshift/*int*/ = 16; /* bias for fractions */
    /*private_static*/ static int intbias/*int*/ = (1 << intbiasshift);
    /*private_static*/ static int gammashift/*int*/ = 10; /* gamma = 1024 */
    /*private_static*/ static int gamma/*int*/ = (1 << gammashift);
    /*private_static*/ static int betashift/*int*/ = 10;
    /*private_static*/ static int beta/*int*/ = (intbias >> betashift); /* beta = 1/1024 */
    /*private_static*/ static int betagamma/*int*/ = (intbias << (gammashift - betashift));
    
    /* defs for decreasing radius factor */
    /*private_static*/ static int initrad/*int*/ = (netsize >> 3); /*
                                                           * for 256 cols, radius
                                                           * starts
                                                           */
                               
    /*private_static*/ static int radiusbiasshift/*int*/ = 6; /* at 32.0 biased by 6 bits */
    /*private_static*/ static int radiusbias/*int*/ = (1 << radiusbiasshift);
    /*private_static*/ static int initradius/*int*/ = (initrad * radiusbias); /*
                                                                     * and
                                                                     * decreases
                                                                     * by a
                                                                     */
                                     
    /*private_static*/ static int radiusdec/*int*/ = 30; /* factor of 1/30 each cycle */
    
    /* defs for decreasing alpha factor */
    /*private_static*/ static int alphabiasshift/*int*/ = 10; /* alpha starts at 1.0 */
    /*private_static*/ static int initalpha/*int*/ = (1 << alphabiasshift);
    /*private*/ int alphadec/*int*/; /* biased by 10 bits */
    
    /* radbias and alpharadbias used for radpower calculation */
    /*private_static*/ static int radbiasshift/*int*/ = 8;
    /*private_static*/ static int radbias/*int*/ = (1 << radbiasshift);
    /*private_static*/ static int alpharadbshift/*int*/ = (alphabiasshift + radbiasshift);
    
    /*private_static*/ static int alpharadbias/*int*/ = (1 << alpharadbshift);
    
    /*
    * Types and Global Variables --------------------------
    */
    
    /*private*/ List<int> thepicture/*ByteArray*/;/* the input image itself */
    /*private*/ int lengthcount/*int*/; /* lengthcount = H*W*3 */
    /*private*/ int samplefac/*int*/; /* sampling factor 1..30 */
    
    // typedef int pixel[4]; /* BGRc */
    /*private*/ List<List<num>> network/*Array*/; /* the network itself - [netsize][4] */
    /*protected*/ var netindex/*Array*/ = new List();
    
    /* for network lookup - really 256 */
    /*private*/ var bias/*Array*/ = new List();
    
    /* bias and freq arrays for learning */
    /*private*/ var freq/*Array*/ = new List();
    /*private*/ var radpower/*Array*/ = new List<int>();
    
    NeuQuant(List<int> thepic/*ByteArray*/, num len/*int*/, num sample/*int*/)
    {
      
      int i/*int*/;
      var p/*Array*/;
      
      thepicture = thepic;
      lengthcount = len;
      samplefac = sample;
      
      network = new List(netsize);
      
      for (i = 0; i < netsize; i++)
      {
        
        network[i] = new List<num>(4);
        p = network[i];
        p[0] = p[1] = p[2] = ((i << (netbiasshift + 8)) / netsize);
        int newfreq = (intbias / netsize).floor();
        freq.add(newfreq); /* 1/netsize */
        bias.add(0);
      }
    }
    
    List<int> colorMap()/*ByteArray*/
    {
      List<int> map/*ByteArray*/ = [];
        List<int> index/*Array*/ = new List<int>(netsize);
        for (int i/*int*/ = 0; i < netsize; i++)
          index[network[i][3].floor()] = i;
        for (int l/*int*/ = 0; l < netsize; l++) {
          int j/*int*/ = index[l];
          map.add(network[j][0].floor());
          map.add(network[j][1].floor());
          map.add(network[j][2].floor());
        }

        return map;
      
    }
    
    /*
     * Insertion sort of network and building of netindex[0..255] (to do after
     * unbias)
     * -------------------------------------------------------------------------------
     */
     
     void inxbuild()/*void*/
     {
       
      int i/*int*/;
      int j/*int*/;
      int smallpos/*int*/;
      int smallval/*int*/;
      var p/*Array*/;
      var q/*Array*/;
      int previouscol;/*int*/
      int startpos;/*int*/
      
      previouscol = 0;
      startpos = 0;
      netindex = new List(1024*1024);
      
      for (i = 0; i < netsize; i++)
      {
        
        p = network[i];
        smallpos = i;
        smallval = p[1].floor(); /* index on g */
        /* find smallest in i..netsize-1 */
        for (j = i + 1; j < netsize; j++)
        {
          q = network[j];
          if (q[1].floor() < smallval)
          { /* index on g */
          
          smallpos = j;
          smallval = q[1].floor(); /* index on g */
        }
        }
        
        q = network[smallpos];
        /* swap p (i) and q (smallpos) entries */
        
        if (i != smallpos)
        {
          
          j = q[0].floor();
          q[0] = p[0];
          p[0] = j;
          j = q[1].floor();
          q[1] = p[1];
          p[1] = j;
          j = q[2].floor();
          q[2] = p[2];
          p[2] = j;
          j = q[3].floor();
          q[3] = p[3];
          p[3] = j;
          
        }
        
        /* smallval entry is now in position i */
        
        if (smallval != previouscol)
        
        {
          
        netindex[previouscol] = (startpos + i) >> 1;
          
        for (j = previouscol + 1; j < smallval; j++) {
          netindex[j] = i;
        }
          
        previouscol = smallval;
        startpos = i;
        
        }
        
      }
      
      netindex[previouscol] = (startpos + maxnetpos) >> 1;
      for (j = previouscol + 1; j < 256; j++) netindex[j] = maxnetpos; /* really 256 */
      
     }
     
     /*
     * Main Learning Loop ------------------
     */
     
     void learn()/*void*/ 
     
     {
       
       int i/*int*/;
       int j/*int*/;
       int b/*int*/;
       int g/*int*/;
       int r/*int*/;
       int radius/*int*/;
       int rad/*int*/;
       int alpha/*int*/;
       int step/*int*/;
       int delta/*int*/;
       int samplepixels/*int*/;
       List<int> p/*ByteArray*/;
       int pix/*int*/;
       int lim/*int*/;
       
       if (lengthcount < minpicturebytes) samplefac = 1;
       
       alphadec = 30 + ((samplefac - 1) / 3).floor();
       p = thepicture;
       pix = 0;
       lim = lengthcount;
       samplepixels = (lengthcount / (3 * samplefac)).floor();
       delta = (samplepixels / ncycles).floor();
       alpha = initalpha;
       radius = initradius;
       
       rad = radius >> radiusbiasshift;
       if (rad <= 1) rad = 0;
       
       radpower.clear();
       for (i = 0; i < rad; i++) radpower.add( (alpha * (((rad * rad - i * i) * radbias) / (rad * rad))).floor() );
       
       
       if (lengthcount < minpicturebytes) step = 3;
       
       else if ((lengthcount % prime1) != 0) step = 3 * prime1;
       
       else
       
       {
         
         if ((lengthcount % prime2) != 0) step = 3 * prime2;
         
         else
         
         {
           
           if ((lengthcount % prime3) != 0) step = 3 * prime3;
           
           else step = 3 * prime4;
           
         }
         
       }
       
       print("BEGIN LEARN");
       i = 0;
       
       while (i < samplepixels)
       
       {
         
         b = (p[pix + 0] & 0xff) << netbiasshift;
         g = (p[pix + 1] & 0xff) << netbiasshift;
         r = (p[pix + 2] & 0xff) << netbiasshift;
         j = contest(b, g, r);
         
         altersingle(alpha, j, b, g, r);
         if (rad != 0) alterneigh(rad, j, b, g, r); /* alter neighbours */
         
         pix += step;
         
         if (pix >= lim) pix -= lengthcount;
         
         i++;
         
         if (delta == 0) delta = 1;
         
         if (i % delta == 0)
         
         {
           
           alpha -= (alpha / alphadec).floor();
           radius -= (radius / radiusdec).floor();
           rad = radius >> radiusbiasshift;
           
           if (rad <= 1) rad = 0;
           
           for (j = 0; j < rad; j++) radpower[j] = (alpha * (((rad * rad - j * j) * radbias) / (rad * rad))).floor();
           
         }
         
       }
       print("END LEARN");
       
     }
     
     /*
     ** Search for BGR values 0..255 (after net is unbiased) and return colour
     * index
     * ----------------------------------------------------------------------------
     */
     
     int map(int b/*int*/, int g/*int*/, int r/*int*/)/*int*/
    
     {
       
       int i/*int*/;
       int j/*int*/;
       int dist/*int*/;
       int a/*int*/;
       int bestd/*int*/;
       var p/*Array*/;
       int best/*int*/;
       
       bestd = 1000; /* biggest possible dist is 256*3 */
       best = -1;
       i = netindex[g]; /* index on g */
       j = i - 1; /* start at netindex[g] and work outwards */
  
      while ((i < netsize) || (j >= 0))
    
    {
      
      if (i < netsize)
      
      {
        
        p = network[i];
        
        dist = p[1] - g; /* inx key */
        
        if (dist >= bestd) i = netsize; /* stop iter */
        
        else
        
        {
          
          i++;
          
          if (dist < 0) dist = -dist;
          
          a = p[0] - b;
          
          if (a < 0) a = -a;
          
          dist += a;
          
          if (dist < bestd)
          
          {
            
            a = p[2] - r;
            
            if (a < 0) a = -a;
            
            dist += a;
            
            if (dist < bestd)
            
            {
              
              bestd = dist;
              best = p[3];
              
            }
            
          }
          
        }
        
      }
      
        if (j >= 0)
      {
        
        p = network[j];
        
        dist = g - p[1]; /* inx key - reverse dif */
        
        if (dist >= bestd) j = -1; /* stop iter */
        
        else 
        {
          
          j--;
          if (dist < 0) dist = -dist;
          a = p[0] - b;
          if (a < 0) a = -a;
          dist += a;
          
          if (dist < bestd)
          
          {
            
            a = p[2] - r;
            if (a < 0)a = -a;
            dist += a;
            if (dist < bestd)
            {
              bestd = dist;
              best = p[3];
            }
            
          }
          
        }
        
      }
      
    }
    
      return (best);
    
    }
    
    List<int> process()/*ByteArray*/
    {
     
      print("BEGIN PIXELS");
      learn();
      print("END PIXELS");
      unbiasnet();
      inxbuild();
      return colorMap();
    
    }
    
    /*
    * Unbias network to give byte values 0..255 and record position i to prepare
    * for sort
    * -----------------------------------------------------------------------------------
    */
    
    void unbiasnet()/*void*/
    
    {
  
      int i/*int*/;
      int j/*int*/;
  
      for (i = 0; i < netsize; i++)
    {
        network[i][0] = (network[i][0].floor() >> netbiasshift);
        network[i][1] = (network[i][1].floor() >> netbiasshift);
        network[i][2] = (network[i][2].floor() >> netbiasshift);
        network[i][3] = i; /* record colour no */

    }
    
    }
    
    /*
    * Move adjacent neurons by precomputed alpha*(1-((i-j)^2/[r]^2)) in
    * radpower[|i-j|]
    * ---------------------------------------------------------------------------------
    */
    
    void alterneigh(int rad/*int*/, int i/*int*/, int b/*int*/, int g/*int*/, int r/*int*/)/*void*/
    
    {
      
      int j/*int*/;
      int k/*int*/;
      int lo/*int*/;
      int hi/*int*/;
      int a/*int*/;
      int m/*int*/;
      
      var p/*Array*/;
      
      lo = i - rad;
      if (lo < -1) lo = -1;
      
      hi = i + rad;
      
      if (hi > netsize) hi = netsize;
      
      j = i + 1;
      k = i - 1;
      m = 1;
      
      while ((j < hi) || (k > lo))
      
      {
        
        a = radpower[m++];
        
        if (j < hi)
        
        {
          
          p = network[j++];
          
          try {
            
            p[0] -= (a * (p[0] - b)) / alpharadbias;
            p[1] -= (a * (p[1] - g)) / alpharadbias;
            p[2] -= (a * (p[2] - r)) / alpharadbias;
            
            } catch (e/*Error*/) {print("GOT ERROR");} // prevents 1.3 miscompilation
            
        }
        
        if (k > lo)
        
        {
          
          p = network[k--];
          
          try
          {
            
            p[0] -= (a * (p[0] - b)) / alpharadbias;
            p[1] -= (a * (p[1] - g)) / alpharadbias;
            p[2] -= (a * (p[2] - r)) / alpharadbias;
            
          } catch (e/*Error*/) {print("GOT ERROR");}
          
        }
        
      }
      
    }
    
    /*
    * Move neuron i towards biased (b,g,r) by factor alpha
    * ----------------------------------------------------
    */
    
    void altersingle(int alpha/*int*/, int i/*int*/, int b/*int*/, int g/*int*/, int r/*int*/)/*void*/ 
    {
      
      /* alter hit neuron */
      var n/*Array*/ = network[i];
      n[0] -= (alpha * (n[0] - b)) / initalpha;
      n[1] -= (alpha * (n[1] - g)) / initalpha;
      n[2] -= (alpha * (n[2] - r)) / initalpha;
    
    }
    
    /*
    * Search for biased BGR values ----------------------------
    */
    
    int contest(int b/*int*/, int g/*int*/, int r/*int*/)/*int*/
    {
      
      /* finds closest neuron (min dist) and updates freq */
      /* finds best neuron (min dist-bias) and returns position */
      /* for frequently chosen neurons, freq[i] is high and bias[i] is negative */
      /* bias[i] = gamma*((1/netsize)-freq[i]) */
      
      int i/*int*/;
      int dist/*int*/;
      int a/*int*/;
      int biasdist/*int*/;
      int betafreq/*int*/;
      int bestpos/*int*/;
      int bestbiaspos/*int*/;
      int bestd/*int*/;
      int bestbiasd/*int*/;
      var n/*Array*/;
      
      bestd = 10000000;
      bestbiasd = bestd;
      bestpos = -1;
      bestbiaspos = bestpos;
      
      for (i = 0; i < netsize; i++)
      
      {
        
        n = network[i];
        dist = n[0].floor() - b;
        
        if (dist < 0) dist = -dist;
        
        a = n[1].floor() - g;
        
        if (a < 0) a = -a;
        
        dist += a;
        
        a = n[2].floor() - r;
        
        if (a < 0) a = -a;
        
        dist += a;
        
        if (dist < bestd)
        
        {
          
          bestd = dist;
          bestpos = i;
          
        }
        
        biasdist = dist - ((bias[i]) >> (intbiasshift - netbiasshift));
        
        if (biasdist < bestbiasd)
        
        {
          
          bestbiasd = biasdist;
          bestbiaspos = i;
          
        }
        
        betafreq = (freq[i] >> betashift);
        freq[i] -= betafreq;
        bias[i] += (betafreq << gammashift);
        
      }
      
      freq[bestpos] += beta;
      bias[bestpos] -= betagamma;
      return (bestbiaspos);
      
    }
    
  }
