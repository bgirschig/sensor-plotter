class Plot {
  ArrayList<Float> points;
  ArrayList<Tag> tags;
  color col;
  int startIndex;
  int endIndex;
  String name;
  Graph parent;
  boolean show;
  
  Plot(Graph _parent, color _col, String _name) {
    points = new ArrayList<Float>();
    tags = new ArrayList<Tag>();
    col = _col;
    parent = _parent;
    name = _name;
    show = true;
  }
  void addPoint(float val) {
    points.add(val);
    update();
  }
  void addPoint(int val) { addPoint((float)val); }
  void addTag(int pos, String name){ tags.add(new Tag(pos, name)); println(tags);}

  void update(){
    startIndex = int(max(points.size()-parent.wPt-parent.offsetX, 1));
    endIndex = int(min(startIndex+parent.wPt, points.size()));
    parent.originX = -(startIndex-1)*parent.scaleXBtn.getValue();
  }
  
  void reset(){points = new ArrayList<Float>();update();}
  void draw() {
    if(show){
      stroke(col);
      for (int i=startIndex; i<endIndex; i++){
        line((i-1)*parent.scaleXBtn.getValue(), -points.get(i-1)*parent.scaleY, i*parent.scaleXBtn.getValue(), -points.get(i)*parent.scaleY);
      }
    }
  }
  Float getPoint(int index){
    return points.get(constrain(index, 0, points.size()));
  }
  Float getPoint(float index){
    if(points.size()==0) return 0f;
    return points.get(constrain(int(index),0,points.size()-1));
  }
  String toString(){
    String result = "";
    for (int i=0; i<points.size(); i++) result += points.get(i);
    return result+",";
  }
}