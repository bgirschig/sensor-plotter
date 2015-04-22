void rollArray(int[] array, int val){
  for(int i=0;i<array.length-1;i++) array[i] = array[i+1];
  array[array.length-1] = val;
}