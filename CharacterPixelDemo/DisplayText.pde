
boolean isDescender(char c){
  final char[] descenders = {'g','j','p','q','y'};
  for (int i = 0; i<descenders.length;i++){
    if (c==descenders[i]){
      return true;
    }
  }
  return false;
}

class DisplayText{
  final String word = new String("AbCdefg ");
  String theText = new String("");
  BoundingBoxMap bm;
  PGraphics pgr;
  
  DisplayText(BoundingBoxMap bbm,PGraphics ppg){
    pgr = ppg;
    final int wordWidth    = round(textWidth(word)),
              textHeight   =  round(textAscent()+textDescent());
    int horizPixels  = 0,
        vertPixels   = textHeight;
    bm = bbm;
    
    while (true){
     if ((horizPixels+ wordWidth) < width){
       theText += word;
       horizPixels += wordWidth;
     }
     else if(vertPixels + textHeight < height){
       theText += '\n';
       horizPixels=0;
       vertPixels += textHeight;
     }
     else{
       break;
     }
    }
  }
  
  void display(boolean trueBox, boolean rectFillForSpace){  
    float x = 0,
          y = 0;
    textAlign(LEFT,TOP);
    final float ch = textAscent()+textDescent(),
                cu =  textAscent();
    for (int i=0; i< theText.length();i++){
      char c = theText.charAt(i);
      if (c != '\n'){
        float cw = textWidth(c);
        color fillC;
        if (trueBox){
          fillC =  trueBoxAvg(x,y,c);
        }
        else{
          fillC = stdBoxAvg(x,y,cw,isDescender(c) ? ch : cu);
        }
        fill(fillC);
        if (c ==' ' && rectFillForSpace){
          noStroke();
          rect(x,y,cw,ch);
        }
        else{ // draw a little rect
          text(c,x,y);
        }
        x += cw;
      }
      else{ // new line
        y+= ch;
        x=0;
      }
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