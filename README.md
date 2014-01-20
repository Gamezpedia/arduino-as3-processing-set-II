My set to test connection between Flash and Arduino via processing socket based delegate.

This test was built to determine on wich cases a delegate coded using processing would be better that using the Arduino ANE to communicate data to the Arduino Board.

I started conecting my servo rig directy to my simple Adobe AIR app, when user dragged a dot aroudn the screen the servo rig should follow those movements as fast as possible. Then I coded a simple socket server on a processing app with some serial commands to control the rig, again I set a draggable control in it to test response speed, the results astonished me, was a lot faster tha using the AIr app by itself.

So as a last test I removed all the ANE related code on my AIR app and connected the app to my processing delegate app sending position data from the first one to the second, and that combination was surprisingly fast and accurate using it as web based flash app and also as a desktop app (ios was not tested). I also connected a leap motion to the Adobe AIR app and moved the rig with it.

//on SocketAS3.pde you should change this line according to your serial port: arduino = new Serial(this, Serial.list()[13], 9600);

// on socketClient.as you should set your socket IP and port: private const _socketPort:Number = 5208; private const _socketURL:String = "192.168.1.37";

Client.fla is the client that connect to processing app.
