class DoshiItem extends SimpleMapItem{
  String name;
  float value;
  
  float hue;
  color c;
  float brightness;
  
  DoshiItem(String name, float value){
    this.name = name;
    this.value = value;
    
    size = value;
  }
  
  void updateColor(){
    // update Color 컬러 팔레트를 어떻게 설정할 것인지?
    c = color(map(value,min,max,100,200));
  }
  
  void draw(){
    fill(c);
    rect(x,y,w,h);
    
    strokeWeight(5);
    stroke(255);
    
    fill(0);
    if (w > textWidth(name + 6)) {
      if (h > textAscent() + 6) {
        textAlign(CENTER,CENTER);
        text(name, x+w/2, y+h/2);
      }
    }
  }
}
