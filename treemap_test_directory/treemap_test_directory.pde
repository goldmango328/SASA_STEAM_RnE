import treemap.*;

FolderItem rootItem;
PFont font;

public void setup(){
  size(1024, 768);
  rectMode(CORNERS);
  
  font = createFont("Sanserif", 13);
  setRoot(new File("/Users/지명금/Desktop/treemap_test_directory")); // 보고 싶은 파일의 경로를 직접 지정해줘야 한다
}

void setRoot(File folder){
  FolderItem tm = new FolderItem(null,folder,0,0);
  tm.setBounds(0,0, width-1, height-1);
  tm.contentsVisible = true;
  rootItem = tm;
}

void draw(){
  background(255);
  textFont(font);
  
  if (rootItem != null){
    rootItem.draw();
  }
}
