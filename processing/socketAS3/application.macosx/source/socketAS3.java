import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.net.*; 
import processing.serial.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class socketAS3 extends PApplet {


int bgLevel = 0;
int port = 5208;
Server server;
String flashDomainPolicy = "<?xml version=\"1.0\"?>"
+"<cross-domain-policy xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:noNamespaceSchemaLocation=\"http://www.adobe.com/xml/schemas/PolicyFileSocket.xsd\">"
+"<allow-access-from domain=\"*\" to-ports=\"*\" secure=\"false\" />"
+"<site-control permitted-cross-domain-policies=\"all\" />"
+"</cross-domain-policy>";

        

int spos=90;
int wpos= 90;

Serial arduino;  

public void setup (){
    size(720, 720);
    server = new Server(this, port);
    
      colorMode(RGB, 1.0f);
      noStroke();
      rectMode(CENTER);
      frameRate(30);
    
      //select second com-port from the list
      arduino = new Serial(this, Serial.list()[10], 9600); 
}
public void draw (){
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
            update(PApplet.parseInt(coords[0]), PApplet.parseInt(coords[1])); 
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
public void sendFlashPolicy(Server socketServer){
    socketServer.write(flashDomainPolicy+PApplet.parseChar(0));
    System.out.println("Sending Flash policy file");
}

public void update(int x, int y) 
{
  //Calculate servo postion from mouseX
  spos =  (y/4);
  wpos = 180 - (x/4);
  float realm = map(spos, 90, 180, 0, 180);
  //Output the servo position ( from 0 to 180)
  
  arduino.write("s"+spos);
  arduino.write("w"+wpos); 

}
//- See more at: http://karoshiethos.com/2010/03/26/serving-a-flash-socket-policy-file-from-processing-org/#sthash.0H3hR3xD.dpuf
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "socketAS3" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
