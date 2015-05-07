int SENSCOUNT = 2;
color[] colors = {#ff0000,#00ff00,#0000ff,#ffff00,#00ffff,#ff00ff};
Graph graph;
File saveFile = null;
Plot[] rawSignalPlots;
// Plot[] analysedPlots;

void setup() {
  size(1280, 750);
  communicationSetup(2);
  initAnalysis();
  graph = new Graph(this, 50, 50, 950, 650);
  
  rawSignalPlots = new Plot[SENSCOUNT];
  // analysedPlots = new Plot[SENSCOUNT];
  for (int i = 0; i < SENSCOUNT; ++i) {
    rawSignalPlots [i] = graph.addPlot("Raw A"+i, colors[i]); 
    // analysedPlots[i] = graph.addPlot("Analysed A"+i, colors[i]);
  }
}

void draw() {
  graph.draw();
  readSerial();
}

// called by graph 'communiation.pde' when a value is recieved.
void onValue(int ValueIndex, int value) {
  analyse(ValueIndex, value);
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

