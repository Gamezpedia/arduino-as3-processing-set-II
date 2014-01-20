import processing.net.*;
int bgLevel = 0;
int port = 5208;
Server server;
String flashDomainPolicy = "<?xml version=\"1.0\"?>"
+"<cross-domain-policy xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:noNamespaceSchemaLocation=\"http://www.adobe.com/xml/schemas/PolicyFileSocket.xsd\">"
+"<allow-access-from domain=\"*\" to-ports=\"*\" secure=\"false\" />"
+"<site-control permitted-cross-domain-policies=\"all\" />"
+"</cross-domain-policy>";

import processing.serial.*;        

int spos=90;
int wpos= 90;

Serial arduino;  

void setup (){
    size(720, 720);
    server = new Server(this, port);
    
      colorMode(RGB, 1.0);
      noStroke();
      rectMode(CENTER);
      frameRate(30);
    
      //select second com-port from the list
      arduino = new Serial(this, Serial.list()[13], 9600); 
}
void draw (){
    background(0);
    color(233, 64, 56);
    Client client = server.available();
    if (client !=null){
    String message = trim(client.readString());
    if (message != null){
        if (match(message,"policy-file-request") != null){
          sendFlashPolicy(server);
        }else{
            //server.write(message);
           
            String[] coords = split(message, '|');
            updateAngles(int(coords[0]), int(coords[1])); 
            // Change the background color to indicate message activity
            bgLevel = 255;
        }
      }
    }
  // Fade to black
  if (bgLevel>1){
      bgLevel-=2;
      background(bgLevel);
  }
}
void sendFlashPolicy(Server socketServer){
    socketServer.write(flashDomainPolicy+char(0));
    System.out.println("Sending Flash policy file");
}

void update(int x, int y) {
  //Calculate servo postion from mouseX
  spos =  (y/4);
  wpos = 180 - (x/4);
  //Output the servo position ( from 0 to 180)
  
  arduino.write("s"+spos);
  arduino.write("w"+wpos); 

}

void updateAngles(int pitch, int roll) {
  arduino.write("s"+pitch);
  arduino.write("w"+(180-roll)); 
}
