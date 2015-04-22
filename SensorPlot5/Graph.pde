import java.util.Map;
import controlP5.*;

class Graph{
  int x,y,w,h,maxOffset;
  float scaleY, originX, originY, minima=0, maxima=0,wPt;
  ArrayList<Plot> plots;
  boolean cursor = false;
  int PTime;
  long pointsCount;
  long totalTime;
  float timeScale;
  boolean drag = false;
  
  int startDragX, startOffsetX, offsetX = 0;
  
// controls
  ControlP5 cp5;
  Toggle pauseBtn;
  Button resetBtn;
  Button saveBtn;
  Slider scaleXBtn;
  RadioButton refPlot;
  PApplet parent;
  ArrayList<Toggle> toggles;

  Graph(PApplet parent, int _x, int _y, int _w, int _h){
    x = _x; y = _y; w = _w; h = _h;
    
    toggles = new ArrayList<Toggle>();
    plots = new ArrayList<Plot>();
    initControls(parent);
    PTime = millis();
    parent = parent;
  }
  Plot addPlot(String name, color col){
    Plot p = new Plot(this, col, name);
    int index = plots.size();
    plots.add(p);
    refPlot.addItem("_"+name, index);
    toggles.add(cp5.addToggle(name).setColorActive(col).setPosition(x+w+10,y+120+15*index).setSize(10,10).setColorLabel(0).plugTo(this).setValue(true));
    toggles.get(index).captionLabel().style().marginTop = -13;
    toggles.get(index).captionLabel().style().marginLeft = 15;
    update();
    return p;
  }
  Plot addPlot(int name, color col){return addPlot(str(name), col);}
  
  void addPointTo(Plot plot, float value){
    if(!pauseBtn.getState()){
      plot.addPoint(value);
      if(value<minima || value>maxima){
        minima = (value<minima)?value:minima;
        maxima = (value>maxima)?value:maxima;
        scaleY = h/(maxima-minima);
        originY = maxima*scaleY;
      }
      totalTime+=(millis()-PTime);
      PTime = millis();
      maxOffset = int(plots.get(0).points.size()-(w/scaleXBtn.getValue()));
    }
  }
  void addPointTo(Plot plot, int value){ addPointTo(plot, float(value)); }
  void addPointTo(int plotId, float value){ addPointTo(plots.get(constrain(plotId, 0,plots.size()-1)), value); }
  void addPointTo(int plotId, int value){ addPointTo(plots.get(constrain(plotId, 0,plots.size()-1)), float(value)); }
  
  float getLastPt(Plot plot){
    if(plot.points.size()<=0) return 0;
    return plot.points.get(max(plot.points.size()-1, 0));
  }
  float getLastPt(int plotId){
    return getLastPt(plots.get(plotId));
  }
  
  void draw(){
    background(240);
    
    noStroke();fill(255);rect(x-2,y-2,w+4,h+4); stroke(0); // background
    line(x, y+originY, x+w, y+originY);                    // horizontal axis
                                                           // Draw curves
    pushMatrix();                                          // -----------
    translate(x+originX,y+originY);                        //      |
    for (int i=0; i<plots.size(); i++){                    //      |
      if(toggles.get(i).getState()) plots.get(i).draw();   //      |
    }                                                      //      v
    popMatrix();                                           // -----------
    
    // cursor   
    if(refPlot.getValue()>=0){
      stroke(255,0,255,100);
      float index = round((mouseX-x-originX)/scaleXBtn.getValue());
      float val = plots.get(int(refPlot.getValue())).getPoint(index);
      float cursorX = constrain(mouseX,x,x+w);
      float cursorY = constrain(y+originY-val*scaleY,y, y+h);
      fill(0);
      // text(originY+"\n"+scaleY, 10, 10);
      
      line(cursorX,y,cursorX,y+h);
      line(x,cursorY,x+w,cursorY);
      text(int(val),x-30, cursorY);
      
      
      text(index*((float)totalTime/plots.get(int(refPlot.getValue())).points.size())/1000, cursorX, y-5);//FIXME
    }
  }
  void hide(int plotId){ plots.get(plotId).show = false; }
  
  void update(){
    for (int i=0; i<plots.size(); i++) plots.get(i).update();
    wPt = w/scaleXBtn.value();
  }
  void reset(){
    PTime = millis();
    scaleY = 0;minima=0;maxima=0;totalTime=0;offsetX=0;
    for (int i=0; i<plots.size(); i++) plots.get(i).reset();
  }
  void clear(){
    plots = new ArrayList<Plot>();
    reset();
  }

  String getCsv(){
    String result="";
    int l = plots.get(0).points.size();
    
    for (int i=0; i<l; i++){
      for(int j=0;j<plots.size();j++){
        result += plots.get(j).points.get(i)+"\t";
      }
      result+="\n";
    }
    return result;
  }
  
  void initControls(PApplet parent){
    cp5 = new ControlP5(parent);
    pauseBtn = cp5.addToggle("pause").setPosition(x+w+10,y).setColorLabel(0).plugTo(this);
    resetBtn = cp5.addButton("reset").setValue(0).setPosition(x+w+60,y).setSize(40,19).plugTo(this);
    saveBtn = cp5.addButton("save").setValue(0).setPosition(x+w+110,y).setSize(40,19).plugTo(this);
    cp5.addTextlabel("label").setText("Cursor:").setPosition(x+w+7,y+40).setColorValue(0);
    refPlot = cp5.addRadioButton("refPlot").setPosition(x+w+50,y+40).setColorLabel(0).addItem("off", plots.size()-1).activate(0).setNoneSelectedAllowed(false);
    scaleXBtn = cp5.addSlider("scale X").setPosition(x+w+10,y+90).setRange(0.1,15).setSize(160,20).setColorLabel(0).setValue(2).plugTo(this);
  }
  void controlEvent(ControlEvent theEvent) {
    if(theEvent.isFrom("reset")) reset();
    else if(theEvent.isFrom(scaleXBtn)) update();
  }
  void startDrag(){
    if(mouseX>x && mouseX<x+w && mouseY>y && mouseY<y+h){
      startDragX = mouseX; startOffsetX = int(offsetX*scaleXBtn.getValue());
      drag = true;  
    }
  }
  void drag(){
    if(drag){
      offsetX = int(constrain((startOffsetX+mouseX-startDragX)/scaleXBtn.getValue(),0,maxOffset));
      update();
    }
  }
  void stopDrag(){drag = false;}
  void onKey(){
    if(keyCode==32) pauseBtn.toggle();                 // space -> pause
    else if(key == 'c') nextRef();                     // c -> cursor on/off
    else if(key == 'r') resetBtn.setValue(1);          // r     -> reset
    else if(key == 's') askSaveFile();                 // s     -> save
    else if(key == 'i') loadAsk();                     // i     -> import
    else if(keyCode==DOWN) nextRef();
    else if(keyCode==UP){
      int val = int(refPlot.value());
      if(val<0) val = plots.size();
      refPlot.activate(int(val));
    }
  }
  void nextRef(){
    refPlot.activate(int(refPlot.value()+2)%(plots.size()+1));
  }
}