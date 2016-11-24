
boolean isDescender(char c){
  final char[] descenders = {'g', 'j','p','q','y'};
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
  final int offset = 0,  // nb of pixels to offset from cetner when averaging color values...
            nbPixels = (offset*2)+1,
            nbSq = nbPixels*nbPixels;
        
  DisplayText(){
    int wordWidth = round(textWidth(word));
    int textHeight =  round(textAscent()+textDescent());
    int horizPixels = 0;
    int vertPixels =textHeight;
    
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
  
  void display(){  
    float x = 0,
          y = 0;
    textAlign(LEFT,TOP);
    float ch = textAscent()+textDescent();
    for (int i=0; i< theText.length();i++){
      char c = theText.charAt(i);
      if (c != '\n'){
        float cw = textWidth(c);
        color fillC =  boxAvg(x,y,cw,isDescender(c) ? ch : textAscent());
        /*
        float centerY =  (y+(textAscent()+textDescent())/2.0),
              centerX = x+cw/2.0;
        color fillC = avgCol(x,y,cw, round(centerX),round(centerY));
        */
        fill(fillC);
        text(c,x,y);
        x += cw;
      }
      else{ // new line
        y+= ch;
        x=0;
      }
    }
  }
  color boxAvg(float xx, float yy, float ww, float hh){
    int x = round(xx),
        y = round(yy),
        w = round(ww),
        h = round(hh),
        r = 0,
        g = 0,
        b = 0;
    for (int hi = 0;hi<h;hi++){
      for (int wi = 0;wi<w;wi++){
        color c = img.get(x+wi,y+hi);
        r += red(c);
        g += green(c);
        b += blue(c);
      }
    }
    return color(round(r/(w*h)),round(g/(w*h)),round(b/(w*h)));
  }
  
  color avgCol(int x, int y){
    int xx = x -offset,
        yy = y - offset;
    int r = 0,
        g = 0,
        b = 0;
    for (int i = 0;i<nbPixels;i++){
      for (int j = 0;i<nbPixels;i++){
        color c = img.get(xx+i,yy+j);
        r += red(c);
        g += green(c);
        b += blue(c);
      }
    }
    return color(round(r/nbSq),round(g/nbSq),round(b/nbSq));
  }
}