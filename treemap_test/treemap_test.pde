import treemap.*;

Treemap map;

void setup(){
  size(1024, 768);
  
  smooth();
  strokeWeight(0.25f);
  PFont font = createFont("Serif", 13);
  textFont(font);
  
  WorldMap mapdata = new WorldMap();
  
  String[] lines = loadStrings("equator.txt");
  for (int i = 0 ; i < lines.length ; i++){
    mapData.addWord(lines[i]);
  }
  mapData.finishAdd();
  
  map = new Treemap(mapData, 0, 0, width, height);
  
  noLoop();
}

void draw(){
  background(255);
  map.draw();
}
