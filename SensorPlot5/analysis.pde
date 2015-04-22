int[][] prevValues;
float[] averages;

void initAnalysis(){
	prevValues = new int[2][30];
	averages = new float[2];
	println(movingAvg(prevValues[0], 0));
}
void analyse(int valueIndex, int value){
	averages[valueIndex] = movingAvg(prevValues[valueIndex], value);
	
	graph.addPointTo(analysedPlots[valueIndex], abs(averages[valueIndex]-value));
	graph.addPointTo(rawSignalPlots[valueIndex], value);
}

float movingAvg(int[] array, int val){
	int total = 0;
	for(int i=0;i<array.length-1;i++){
		array[i] = array[i+1];
		total+=array[i];
	}
	array[array.length-1] = val;
	total+=array[array.length-1];
	return total/array.length;
}
void rollArray(int[] array, int val){
  for(int i=0;i<array.length-1;i++) array[i] = array[i+1];
  array[array.length-1] = val;
}
float avg(int[] array){
	int total = 0;
	for(int i=0; i<array.length; i++) total+=array[i];
	return total/array.length;
}