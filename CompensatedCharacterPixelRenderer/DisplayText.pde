float textWidth(char c, BoundingBoxMap bm, PFont f, int fs){
  BoundingBox b = bm.get(c);
  pushStyle();
  textFont(f,fs);
  float rawWidth  = (c=='\n' ? 0 :textWidth(c));
  popStyle();
  return rawWidth + b.leftCompensation + b.rightCompensation;
}
float textWidth(String s, BoundingBoxMap bm, PFont f, int fs){
  float ret = 0;
  for (int i=0;i<s.length();i++){
    ret += textWidth(s.charAt(i),bm, f, fs);
  }
  return ret;
}

class Justifier{
  float [] spaceDeltaVec;
  float lineDelta;
  
  Justifier(String[] lineVec, PFont f, int fs,BoundingBoxMap bm, int lineWidthPixels, int screenH){
    spaceDeltaVec = new float[lineVec.length];
    pushStyle();
    textFont(f,fs);
    float ch = textAscent() + textDescent();
    lineDelta = (screenH - lineVec.length*ch)/(lineVec.length-1);  // -1 for last \n
    
    for (int i=0; i<lineVec.length;i++){
      lineVec[i]+='\n';  // because reading from file does not add a \n to each line!
      float delta =  lineWidthPixels -(useCompensatedWidth ? textWidth(lineVec[i],bm,f,fs) :textWidth(lineVec[i]));
      //println("Uncompensated lenght\t", textWidth(lineVec[i]), "\tCompensated width\t", textWidth(lineVec[i],bm,f,fs));
      String [] wordVec = split(lineVec[i],' ');
      spaceDeltaVec[i] = delta/(wordVec.length-1);  // -1 for the \n at the end!
      //println(spaceDeltaVec[i]);
    }
    popStyle();
   } 
}

class DisplayText{
  BoundingBoxMap bm;
  PGraphics pgr;
  PFont font;
  int fontSize;
  String [] textLines;// = loadStrings(screen1LinesFile);
  Justifier just;
  
  DisplayText(BoundingBoxMap bbm,PGraphics ppg, PFont f, int fs, int lineWidth,int screenH, String textFileName){
    pgr = ppg;
    font  = f;
    fontSize =  fs;
    bm = bbm;
    textLines = loadStrings(textFileName); 
    just = new Justifier(textLines, font, fontSize, bm, lineWidth-2*pixelBorder,screenH-2*pixelBorder);
  }
  
  void display(){  
    float x = pixelBorder,
          y = pixelBorder;
    textAlign(LEFT,TOP);
    textFont(font,fontSize);
    final float ch = textAscent()+textDescent(),
                cu =  textAscent();
    for (int lineIndex = 0; lineIndex< textLines.length;   lineIndex++){
      String[] wordVec = split(textLines[lineIndex],' ');
      int nbWords = wordVec.length;
      for (int wordIndex=0;wordIndex<nbWords;wordIndex++){
        int wordLength =  wordVec[wordIndex].length();
        for (int charIndex = 0; charIndex< wordLength;charIndex++){
          char c = wordVec[wordIndex].charAt(charIndex);
          if (c != '\n'){
            float cw ;
            if (useCompensatedWidth){
              x+= bm.get(c).leftCompensation;
              cw = textWidth(c) + bm.get(c).rightCompensation;
            }
            else{
              cw = textWidth(c);
            }
            fill(trueBoxAvg(x,y,c));
            text(c,x,y);
            x += cw;
          }
          else{ // new line
            y+= ch+just.lineDelta;
          }   
        }
        x += textWidth(' ')+ just.spaceDeltaVec[lineIndex];
        //println("spacing\t:",textWidth(' ')+ just.spaceDeltaVec[lineIndex]);
      }
      x=pixelBorder;
    }
  }
  
  color trueBoxAvg(float xx, float yy, char cc){
    final int x = round(xx),
              y = round(yy);
    Character c = cc;
    BoundingBox bx = bm.get(c);
    int left   = bx.left,
        right  = bx.right,
        top    = bx.top,
        bottom = bx.bottom,
        surface = (right-left)*(bottom-top);
        if(surface==0){ // the character ' ' space, has no measurable bounding box, use the stnd one.
          left  = 0;
          top   = 0;
          right = round(textWidth(c));
          bottom = round(textAscent());
          surface = (right-left)*(bottom-top);
        }
    int r = 0,
        g = 0,
        b = 0;
    for (int hi = top;hi<bottom;hi++){
      for (int wi = left;wi<right;wi++){
        color col = pgr.get(x+wi,y+hi);
        r += red(col);
        g += green(col);
        b += blue(col);
      }
    }
    return color(round(r/surface),round(g/surface),round(b/surface));
  }
  
  color stdBoxAvg(float xx, float yy, float ww, float hh){
    final int x = round(xx),
              y = round(yy),
              w = round(ww),
              h = round(hh),
              wh = w*h;
    int r = 0,
        g = 0,
        b = 0;
    for (int hi = 0;hi<h;hi++){
      for (int wi = 0;wi<w;wi++){
        color c = pgr.get(x+wi,y+hi);
        r += red(c);
        g += green(c);
        b += blue(c);
      }
    }
    return color(round(r/(wh)),round(g/(wh)),round(b/(wh)));
  }
}

boolean isDescender(char c){
  final char[] descenders = {'g','j','p','q','y'};
  for (int i = 0; i<descenders.length;i++){
    if (c==descenders[i]){
      return true;
    }
  }
  return false;
}