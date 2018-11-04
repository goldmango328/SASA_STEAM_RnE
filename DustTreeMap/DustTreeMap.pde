import treemap.*;
// processing 내부 data 파일에 저장되어 있는 형태의 파일들(csv)에 대해서
// Andorid Studio로 같이 넘어가는지? 
// CODE STACK OVERFLOW

DoShi_Item rootItem;
DoShi_Item taggedItem;
EupMyeunDong_Item rolloverItem; // Treemap_test_directory에서 확인한 후에 옮겨올 것

PFont font;

Table DustTable = new Table(); // 미세먼지 측정 데이터

int selectedYear = 2001; // 사용자가 선택한 연도
int selectedMonth = 1; // 사용자가 선택한 달
int selected_fileNum = 1; // 사용자의 선택이 들어있는 파일

void setup(){
  // size(768, 1280); // Nexus 4 display size 768 * 1280
  size(1024, 768); // 헤헤
  
  DustTable=loadTable(selectedYear+"_"+selected_fileNum+"_edit.csv","header");
  
  for(int i=1 ; i<=4 ; i++){
     if(selectedMonth <= 3*i){
       selected_fileNum = i;
       break;
     }
  }
  
  rectMode(CORNERS);
  
  //smooth();
  //noStroke();
  
  font = createFont("Sanserif",13); 
  setRoot(); // csv파일에서 받아와서 도.시를 root로 지정
}

void setRoot(){ //어떤 식으로 내부를 지정..?
  DoShi_Item tm = new DoShi_Item(null, DustTable,"basic", 0,0);
  tm.setBounds(0,0,width,height);
  tm.contentVisible = true;
  rootItem = tm;
  
  // rootItem.updateColors();
}

void draw(){
  background(255);
  textFont(font);
  
  rolloverItem = null;
  
  if(rootItem != null){
    rootItem.draw();
  }
  if(rolloverItem != null){
    rolloverItem.drawTitle();
  }
}

void mousePressed(){
  if (rootItem != null){
    rootItem.mousePressed();
  }
}


  
