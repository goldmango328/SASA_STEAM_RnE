class DoshiMap extends SimpleMapModel{
  HashMap Doshi;
  
  DoshiMap(){
    Doshi = new HashMap();
  }
  
  void addDoshi(String name,float value) {
    DoshiItem item = new DoshiItem(name,value);
    Doshi.put(name,item);
  }
  
  void finishAdd() {
    items = new DoshiItem[Doshi.size()];
    Doshi.values().toArray(items);
  }
  
  void updateColor(String name){
    DoshiItem item = (DoshiItem) Doshi.get(name);
    item.updateColor();
  } 
}
