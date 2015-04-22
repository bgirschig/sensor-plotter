import processing.serial.*;
Serial myPort;
byte[] buffer;

boolean halfHeader = false;
int transmitIndex = 0;
int tempVal;
int valuesCount = 2;

void communicationSetup(int port){
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[port], 9600);
}


// reads the available serial data.
// typical message:  255,255,203,100,0,100
// deconstruction: header-> 2x'255' bytes. 2 bytes per value: low byte first.
void readSerial(){
  while (myPort.available() > 0) {
    int inByte = myPort.read();
    if(inByte==255 && halfHeader){
      halfHeader=false; transmitIndex = 0;                    // means previous and current byte are 255 -> header
    }
    else{
      if(inByte==255) halfHeader = true;                      // first element of a header (might not be one)
      else if(halfHeader) halfHeader = false;                 // if current is not 255, then previous was not a header 
      if(transmitIndex%2==0) tempVal = inByte;                // if transmitIndex is 2, keep tempoarily (this is low byte)
      else onValue(min((transmitIndex-1)/2,valuesCount-1), (inByte<<8)+tempVal); // else, this is the last byte of the value. combine with tempVal and 'send'
      transmitIndex++;
    }
  }
}
