import processing.svg.*;

// must be in the sketch data directory!
final String g_fontFamily = "data/Ingeborg-New-f-Regular.otf";

final int g_fontSize = 24;

final String g_DisplayText = "abQgy";



PFont   g_font;
boolean g_doRec = true;

void settings(){
  size(5*g_fontSize,4*g_fontSize);
}

void setup(){
  g_font = createFont(g_fontFamily,g_fontSize,true);
}

void draw(){
  if (g_doRec){
    beginRecord(SVG,"output.svg");
  }
  background(#000000);
  fill(#FFFFFF);
  textFont(g_font);
  textAlign(LEFT,TOP);
  text(g_DisplayText,textWidth('A'), textAscent()+textDescent());
  endRecord();
  if (g_doRec){
    saveFrame("output.png");
  }
  g_doRec =false;
}

void keyPressed(){
  exit();
}
  