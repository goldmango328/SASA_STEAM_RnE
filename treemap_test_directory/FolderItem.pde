class FolderItem extends FileItem implements MapModel {
  MapLayout algorithm = new PivotBySplitSize();
  Mappable[] items;
  boolean contentsVisible;
  boolean layoutValid;
  
  public FolderItem(FolderItem parent, File folder, int level, int order){
    super(parent, folder, level, order);
    
    String[] contents = folder.list();
    if (contents != null){
      contents = sort(contents);
      items = new Mappable[contents.length];
      int count = 0;
      for (int i = 0; i < contents.length ; i++){
        if (contents[i].equals(".") || contents[i].equals("..")){
          continue;
        }
        File fileItem = new File(folder, contents[i]);
        try{
          String absolutePath = fileItem.getAbsolutePath();
          String canonicalPath = fileItem.getCanonicalPath();
          if (!absolutePath.equals(canonicalPath)){
            continue;
          }
        }catch (IOException e){ }
        
        FileItem newItem = null;
        if (fileItem.isDirectory()){
          newItem = new FolderItem(this, fileItem, level+1, count);
        } else {
          newItem = new FileItem(this, fileItem, level+1, count);
        }
        items[count++] = newItem;
        size += newItem.getSize();
      }
      if (count != items.length){
        items = (Mappable[]) subset(items, 0, count);
      }
    } else {
      // 더미 배열을 생성한다
      items = new Mappable[0];
    }
  }
  
  void checkLayout(){
    if (!layoutValid){
      if (getItemCount() != 0){
        algorithm.layout(this, bounds);
      }
      layoutValid = true;
    }
  }
  
  void draw(){
    checkLayout();
    calcBox();
    if (contentsVisible){
      for (int i=0 ; i < items.length ; i++){
        items[i].draw();
      }
    } else {
      super.draw();
    }
  }
  
  Mappable[] getItems(){
    return items;
  }
  int getItemCount() {
    return items.length;
  }
}
