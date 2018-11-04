class DoShi_Item extends EupMyeunDong_Item implements MapModel{ //implements..? 
  MapLayout algorithm = new PivotBySplitSize(); // 보여지는 형태를 결정 ex) 정사각형 등..
  Mappable[] items;
  boolean contentVisible;
  boolean layoutValid;
  
  public DoShi_Item(DoShi_Item parent,Table info,String name, int level, int order){ // PM10 과 Table을 넘겨준다
    super(parent,info,name,level, order);
    
    if(info.getRowCount() != 0){
      if(level == 0){ // 도시를 포괄하고 있는 아이템을 만들어야 함
        String[] DoShi_Name = getDoShiName(info);
        Table[] DoShi = new Table[DoShi_Name.length];
        items = new Mappable[DoShi_Name.length]; // 우리 데이터에 제주 없음??
        
        for( int i = 0 ; i<DoShi_Name.length ; i++){
          DoShi[i] = new Table();
          DoShi[i].addColumn("지역");
          DoShi[i].addColumn("측정소명");
          DoShi[i].addColumn("측정월",Table.INT);
          DoShi[i].addColumn("avPM10",Table.FLOAT);
        }
        
        int count = 0;
        for( int i = 0 ; i<DoShi_Name.length ; i++){
          for( TableRow row : info.rows()){
            int month = row.getInt("측정월");
            if (month != selectedMonth){
              continue;
            }
            String areaName = row.getString("지역");
            areaName = str(areaName.charAt(0))+str(areaName.charAt(1));
            
            if( areaName.equals(DoShi_Name[i])){
              TableRow newRow = DoShi[i].addRow();
              newRow.setString("지역", areaName);
              newRow.setString("측정소명",row.getString("측정소명"));
              newRow.setInt("측정월",row.getInt("측정월"));
              newRow.setFloat("avPM10",row.getFloat("avPM10"));
            }
          }
        }
        
        for( int i = 0 ; i<DoShi_Name.length ; i++){
          saveTable(DoShi[i],"DoShi["+i+"].csv");
          DoShi_Item newItem = new DoShi_Item(this, DoShi[i], DoShi_Name[i], level+1, count);
          items[count++] = newItem;
          size += newItem.getSize();
        }
      } else { // 이제 읍면동을 불러야하는 경우에
        int count = 0;
        // print("name:"+name+"|items.count:"+info.getRowCount()+"\n"); //여기서에서 info=0 왜?
        items = new Mappable[info.getRowCount()];
        for(TableRow row : info.rows()){
          Table newInfo = EupMyeunDong_Table(row.getString("측정소명"),row.getFloat("avPM10"));
          EupMyeunDong_Item newItem = new EupMyeunDong_Item(this, newInfo ,row.getString("측정소명"), level+1, count);
          items[count++] = newItem;
          size += newItem.getSize(); // basic을 비롯한 몇몇 카테고리가 음수로 나타남
        }
      }
    } else {
      items = new Mappable[0];
    }
  }
  
  String[] getDoShiName(Table table){
    Table nameTable = new Table();
    nameTable.addColumn("name");
    
    for(TableRow row : table.rows()){
      String name = row.getString("지역");
      name = str(name.charAt(0))+str(name.charAt(1));
      boolean flag = true;
      
      for(TableRow nameRow : nameTable.rows()){
        String origin_name = nameRow.getString("name");
        if(name.equals(origin_name)){
          flag = false;
          break;
        }
      }
      if(flag == true){
        TableRow newRow = nameTable.addRow();
        newRow.setString("name",name);
      }
    }
    
    String[] DoShiName = new String[nameTable.getRowCount()];
    for(int i=0 ; i<nameTable.getRowCount() ; i++){
      DoShiName[i] = nameTable.getRow(i).getString("name");
    }
    
    return DoShiName;
  } 
      
  Table EupMyeunDong_Table(String name, float value){
    Table table = new Table();
    table.addColumn("측정소명");
    table.addColumn("avPM10",Table.FLOAT);
    
    TableRow row = table.addRow();
    row.setString("측정소명",name);
    row.setFloat("avPM10",value);
    
    return table;
  }
  
  void checkLayout(){
    if (!layoutValid){
      if(info.getRowCount() != 0){
        algorithm.layout(this, bounds);
      }
      layoutValid = true;
    }
  }
  
  Mappable[] getItems(){
    return items;
  }
  
  int getItemLength(){
    return items.length;
  }
  
  void draw(){
    checkLayout();
    calcBox();
    if (contentVisible){
      for(int i=0 ; i < items.length ; i++){
        items[i].draw();
      }
    } else {
      super.draw();
    }
    
    if (contentVisible){
      if (mouseInside()){ // 클릭하는 즉시 바뀌는 기능만 넣어도 ok
        taggedItem = this;
      }
    }
    if (parent == rootItem){
      colorMode(RGB,255);
      fill(0);
      rect(boxLeft,boxTop,boxRight,boxBottom);
    }
  }
    
   void showContents(){
     contentVisible = true;
   }
   void hideContents(){      
     contentVisible = false;
   }
   
   boolean mousePressed(){
     if(mouseInside()){
       if(contentVisible){
         for (int i = 0 ; i <items.length ; i++){
          EupMyeunDong_Item area = (EupMyeunDong_Item) items[i];
          if (area.mousePressed()){
            return true;
          }
        }
      } else {
        if(mouseButton == LEFT){
          showContents();
        } else if(mouseButton == RIGHT){
          parent.hideContents();
        }
      }
      return true;
    }
  return false;
  }
  
  /*
  void updateColors(){
    super.updateColors(); 
    
    for (int i=0 ; i<items.length ;i++){
      EupMyeunDong_Item area = (EupMyeunDong_Item) items[i];
      area.updateColors();
    }
  }
  */
}
