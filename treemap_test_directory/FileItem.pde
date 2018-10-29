class FileItem extends SimpleMapItem {
  FolderItem parent;
  File file;
  String name;
  int level;
  
  float textPadding = 8;
  
  float boxLeft, boxTop;
  float boxRight, boxBottom;
  
  FileItem(FolderItem parent, File file, int level, int order){
    this.parent = parent;
    this.file = file;
    this.order = order;
    this.level = level;
    
    name = file.getName();
    size = file.length();
  }
  
  void calcBox(){
    boxLeft = x;
    boxTop = y;
    boxRight = x + w;
    boxBottom = y + h;
  }
  
  void draw(){
    calcBox();
    fill(255);
    rect(boxLeft, boxTop, boxRight, boxBottom);
  
    if(textFits()){
      drawTitle();
    }
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
}
