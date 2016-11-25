
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
  
  DisplayText(){
    final int wordWidth    = round(textWidth(word)),
              textHeight   =  round(textAscent()+textDescent());
    int horizPixels  = 0,
        vertPixels   = textHeight;
    
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
    final float ch = textAscent()+textDescent(),
                cu =  textAscent();
    for (int i=0; i< theText.length();i++){
      char c = theText.charAt(i);
      if (c != '\n'){
        float cw = textWidth(c);
        color fillC =  boxAvg(x,y,cw,isDescender(c) ? ch : cu);
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
        color c = img.get(x+wi,y+hi);
        r += red(c);
        g += green(c);
        b += blue(c);
      }
    }
    return color(round(r/(wh)),round(g/(wh)),round(b/(wh)));
  }
}