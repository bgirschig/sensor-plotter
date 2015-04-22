#include <CapacitiveSensor.h>
#include "RunningAverage.h"

#define VALUESCOUNT 2
#define AVGSIZE 3

int toBeSent[VALUESCOUNT];

void setup() {
	Serial.begin(9600);
	delay(500);
}

void loop() {
  for(int i=0;i<VALUESCOUNT;i++){
  	toBeSent[i] = analogRead(i);
  }

  sendVals();
  delay(2);
}
void sendVals(){
  // header
  Serial.write(255); Serial.write(255);

  // values
  for(int i=0;i<VALUESCOUNT;i++){ Serial.write(toBeSent[i]); Serial.write(toBeSent[i]>>8);}
}