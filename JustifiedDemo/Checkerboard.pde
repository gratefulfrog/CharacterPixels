class Checkerboard{
  PImage img;
  int pDim;
  
  Checkerboard (PImage iimg, int dimension,boolean animate){
    pDim = dimension;
    img = iimg;   
    img.loadPixels();
    for (int i=0; i<height;i++){
      for (int j = 0; j<width;j++){
        img.pixels[j+width*i] = animate ? getCol(i,j) : white;    
      }
    }
    img.updatePixels();
  }
  
  color getCol(int y, int x){
    int cx =0,
        cy =0;
     final float w =  (width/pDim),
                 h =  (height/pDim);
    for (int i= 0;i<pDim;i++){
      if (x<w*(i+1)){
        cx = i%2;
        break;
      }
    }
    for (int i= 0;i<pDim;i++){
      if (y<h*(i+1)){
        cy = i%2;
        break;
      }
    }
    return  (cx==cy) ? black: white;
  }
  void display(){
    image(img,0,0);
  }
}