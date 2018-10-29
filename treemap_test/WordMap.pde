class WorldMap extends SimpleMapModel {
  HashMap words;
  
  WorldMap() {
    words = new HashMap();
  }
  
  void addWord(String word) {
    WordItem item = (WordItem) words.get(word);
    if (item == null) {
      item = new WordItem(word);
      words.put(word, item);
    }
    item.incrementSize();
  }
  
  void finishAdd() {
    items = new WordItem[words.size()];
    words.values().toArray(items);
  }
}
