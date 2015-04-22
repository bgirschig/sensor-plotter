Graph graph;
File saveFile = null;

void setup() {
  size(1280, 750);
  communicationSetup(2);

  graph = new Graph(this, 50, 50, 950, 650);
  graph.addPlot("A0", #ff0000); // will be first value sent by arduino
  graph.addPlot("A1", #00f0ff); // will be second value sent by arduino

  // graph.hide(0);
  // graph.hide(1);
}

void draw() {
  graph.draw();
  readSerial();
}
void onValue(int ValueIndex, int value) {
  graph.addPointTo(ValueIndex, value);
  // if(drawDelta && ValueIndex==1) graph.addPointTo(delta, graph.getLastPt(0)-graph.getLastPt(1));
}

// select saveFile
void askSaveFile() {
  if (saveFile != null) selectOutput("save as:", "saveFile", saveFile);
  else selectOutput("save file to:", "saveFile");
}

// save
void saveFile(File selection) {
  if (selection == null) {
    println("cancelled file save");
  } else {
    saveFile = new File(selection.getAbsolutePath().replace(".csv", "")+".csv"); //ensure only one .csv extension
    String[] saveArray = {
      graph.getCsv(), ""
    };
    saveStrings(saveFile, saveArray);
  }
}

void loadAsk(){selectInput("Select a csv file to load", "loadGraph");graph.pauseBtn.setState(true);}
void loadGraph(File selection){
  if(selection!=null){
    graph.clear();
    String[] lines = loadStrings(selection.getAbsolutePath());
    int l = lines.length;
    for(int i=0;i<l;i++){
      String[] cols = lines[i].split("\t");
      for(int j=0; j<cols.length; j++){
        if(i==0){ graph.addPlot("plot"+(j+1), #0f0ff0); }
        else graph.addPointTo(j, int(cols[j]));
      }
    }
    graph.update();
  }
}

void keyPressed() {
  graph.onKey();
}
void mousePressed() { graph.startDrag(); }
void mouseDragged() { graph.drag(); }
void mouseReleased() { graph.stopDrag(); }

