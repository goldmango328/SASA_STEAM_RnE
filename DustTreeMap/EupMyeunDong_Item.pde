class EupMyeunDong_Item extends SimpleMapItem{ //extends -> 상속의 느낌?
  DoShi_Item parent;
  Table info;
  String name;
  int level;
  
  float textPadding = 8;
  
  float boxLeft, boxTop;
  float boxRight, boxBottom;
  
  // Info의 형태 (name,value)
  //             (이름,value)
  public EupMyeunDong_Item(DoShi_Item parent,Table info,String Name, int level, int order){
    this.parent = parent;
    this.info = info;
    this.order = order;
    this.level = level;
    
    
    name = Name; // 읍면동의 이름을 가져온다 
    if(info.getRowCount()!=0){
      for(TableRow row: info.rows()){
        if(row.getInt("측정월") == selectedMonth){ // ERROR: This table has no column named '측정월'
          if(row.getFloat("avPM10") != -999.0){
            size += row.getFloat("avPM10");
          }
        }
      }
    }
  }
  
  void calcBox(){
    // print("calcBox! name:"+name);
    boxLeft = x;
    boxTop = y;
    boxRight = x + w;
    boxBottom = y + h;
    // print(boxLeft, boxTop, boxRight, boxBottom+"\n"); // ->이게 NaN이었음!!
  }
  
  void draw(){
    calcBox();
    fill(255);
    rect(boxLeft, boxTop, boxRight, boxBottom);
    
    if(textFits()){
      drawTitle();
    } else if (mouseInside()){ // 모바일 어플리케이셔에서 이를 어떻게 표현?
      rolloverItem = this;
    }
  }
  
  boolean mouseInside(){
    return (mouseX > boxLeft && mouseX < boxRight &&
            mouseY > boxTop && mouseY < boxBottom);
  }
  
  void drawTitle(){
    fill(0);
    textAlign(LEFT);
    text(name, boxLeft + textPadding, boxBottom - textPadding);
  }
  
  boolean textFits(){
    float wide = textWidth(name) + textPadding*2;
    float high = textAscent() + textDescent() + textPadding*2;
    return (boxRight - boxLeft > wide) && (boxBottom - boxTop > high);
  }
  
  boolean mousePressed(){
    if (mouseInside()){
      if (mouseButton == RIGHT){
        parent.hideContents();
        return true;
      }
    }
    return false;
  }
  /*
  void updateColors(){
    if(parent != null){
      hue = map(order, 0, parent.getItemLength(), 0, 360);
    }
    brightness = random(20,80);
    
    colorMode(HSB, 360, 100, 100); // colorMode 에서 HSB 와 RGB의 차이?
    if(parent == rootItem){
      c = color(hue, 80, 80);
    } else if(parent != null){
      c = color(parent.hue, 80, brightness);
    }
    colorMode(RGB, 255);
  }
  */
}
  
