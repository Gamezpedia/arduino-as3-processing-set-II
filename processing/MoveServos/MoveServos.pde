
/**
 * Servocontrol (derived from processing Mouse 1D example.) 
 * 
 * Updated 24 November 2007
 */


// Use the included processing code serial library
import processing.serial.*;        

int spos=90;
int wpos= 90;

Serial port;                         // The serial port

void setup() 
{
  size(720, 720);
  colorMode(RGB, 1.0);
  noStroke();
  rectMode(CENTER);
  frameRate(30);
  println( Serial.list());
  //select second com-port from the list
  port = new Serial(this, Serial.list()[13], 9600); 
}

void draw() 
{
  background(0);
  color(233, 64, 56);
  rect(mouseX, mouseY, 128, 128);
  update(mouseX, mouseY); 
 
}

void update(int x, int y) 
{
  //Calculate servo postion from mouseX
  spos =  (y/4);
  wpos = 180 - (x/4);
  float realm = map(spos, 90, 180, 0, 180);
  //Output the servo position ( from 0 to 180)
  
  port.write("s"+spos); 
  port.write("w"+wpos); 

}

