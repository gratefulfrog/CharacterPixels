class DisplayText{
  String word = new String("AbCd ");
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
    for (int i=0; i< theText.length();i++){
      char c = theText.charAt(i);
      if (c != '\n'){
        float cw = textWidth(c);
        float centerY =  (y+(textAscent()+textDescent())/2.0),
              centerX = x+cw/2.0;
        color fillC = avgCol(round(centerX),round(centerY));
        fill(fillC);
        text(c,x,y);
        x += cw;
      }
      else{ // new line
        y+= textAscent()+textDescent();
        x=0;
      }
    }
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