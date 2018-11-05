import treemap.*;

Treemap map;
Table dustInfo;

int selected_month = 1;
int selected_year = 2001;
int file_num = 1;

float min = 987654321;
float max = 0;

PFont font;

int boxHeight = 50;
int textPadding = 8;

void setup(){
  //size(1024, 768);
  //size(768, 1280); // Nexas 4 display 
  size(384,640);
  
  smooth();
  strokeWeight(0.25f);
  font = createFont("Sanserif", 15);
  textFont(font);
}

void draw(){
  background(255);
  getmapData();
  map.draw();
  drawTitle();
}

void getmapData(){
   DoshiMap mapData = new DoshiMap();
  
  dustInfo = loadTable(str(selected_year)+"_"+str(file_num)+"_doshi_edit.csv","header");
  
  for (TableRow row : dustInfo.findRows(str(selected_month),"측정월")){
    String name = row.getString("지역");
    float value = row.getFloat("avPM10");
    mapData.addDoshi(name,value);
    
    if(value < min){
      min = value;
    } 
    if(value > max){
      max = value;
    }
  }
  mapData.finishAdd();
  
  for (TableRow row : dustInfo.findRows(str(selected_month),"측정월")){
    String name = row.getString("지역");
    mapData.updateColor(name);
  }
  map = new Treemap(mapData, 0, boxHeight, width, height-boxHeight);
}

void drawTitle(){
  textAlign(LEFT,CENTER);
  text(str(selected_year)+"/"+str(selected_month)+"", textPadding,boxHeight/2);
}

void keyPressed(){
  if(key == 'u' || key =='U'){
    selected_year += 1;
    if(selected_year >= 2017){
      selected_year= 2017;
    }
    dustInfo = loadTable(str(selected_year)+"_"+str(file_num)+"_doshi_edit.csv","header");
  }
  else if(key == 'd' || key == 'D'){
    selected_year -= 1;
    if(selected_year <= 2001){
      selected_year = 2001;
    }
  }
}
