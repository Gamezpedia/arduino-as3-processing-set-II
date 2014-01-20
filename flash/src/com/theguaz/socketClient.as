package com.theguaz{	import flash.display.*;	import flash.events.*;	import flash.net.*;	import flash.utils.ByteArray;
	
	import flash.utils.*;	
	/*import com.leapmotion.leap.*;
	import com.leapmotion.leap.events.*;
	import com.leapmotion.leap.util.*;
	*/	public class socketClient extends MovieClip {		private var _dataSocket:Socket;		private const _socketPort:Number = 5208;        private const _socketURL:String = "192.168.1.37";		private var _myTime:Timer;
		private var coords:Object;
		
		private var _isHandAvailable:Boolean;
		
		private var controller:Controller;
				public function socketClient() {			createSocketConnection()		}		private function createSocketConnection():void {
			
			_myTime = new Timer(1500);
			
			coords = {};
			coords.x = 0; coords.y = 0;
						_dataSocket = new Socket();			_dataSocket.addEventListener(Event.CONNECT, connectedToServer);			_dataSocket.addEventListener(ProgressEvent.SOCKET_DATA, receiveData);			_dataSocket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);			_dataSocket.addEventListener(Event.CLOSE, closeSocket);			//pass to connect method the server IP and the port to comunicate;			_dataSocket.connect(_socketURL, _socketPort);		}		protected function receiveData(event:ProgressEvent):void {			trace("recibo")			// here you can read all the packets sent from the server		}		protected function ioErrorHandler(event:IOErrorEvent):void {			trace("ioErrorHandler: " + event);		}		private function connectedToServer(e:Event):void {			//yes! you are connected to the socket server
			trace("i'm connected.");
			
			dot_mc.buttonMode = true;
			dot_mc.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			//setLeapMotion();		}
		
		private function onMouseDownHandler(e:MouseEvent):void{
			dot_mc.startDrag();
			addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			dot_mc.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUPHandler);
		}
		
		private function onMouseUPHandler(e:MouseEvent):void{
			dot_mc.stopDrag();
			removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUPHandler);
			dot_mc.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
		}
		
		private function onEnterFrameHandler(e:Event):void{
			_dataSocket.writeUTF(String(dot_mc.x + "|" + dot_mc.y));
			_dataSocket.flush();
		}
		
				private function closeSocket(e:Event):void {			//your socket connection is closed		}
		
		//LEAP MOTION CODE
		
		private function setLeapMotion():void{
			controller = new Controller();
			controller.addEventListener( LeapEvent.LEAPMOTION_INIT, onInit );
			controller.addEventListener( LeapEvent.LEAPMOTION_CONNECTED, onConnect );
			controller.addEventListener( LeapEvent.LEAPMOTION_DISCONNECTED, onDisconnect );
			controller.addEventListener( LeapEvent.LEAPMOTION_EXIT, onExit );
			controller.addEventListener( LeapEvent.LEAPMOTION_FRAME, onFrame );
		}
		
		 private function onInit( event:LeapEvent ):void
                {
                        trace_txt.text = String( "Initialized" );
                }

                private function onConnect( event:LeapEvent ):void
                {
                        trace_txt.text = String( "Connected" );
                        controller.enableGesture( Gesture.TYPE_SWIPE );
                        controller.enableGesture( Gesture.TYPE_CIRCLE );
                        controller.enableGesture( Gesture.TYPE_SCREEN_TAP );
                        controller.enableGesture( Gesture.TYPE_KEY_TAP );
                        controller.setPolicyFlags( Controller.POLICY_BACKGROUND_FRAMES );
                }

                private function onDisconnect( event:LeapEvent ):void
                {
                        trace_txt.text = String( "Disconnected" );
                }

                private function onExit( event:LeapEvent ):void
                {
                        trace_txt.text = String( "Exited" );
                }

                private function onFrame( event:LeapEvent ):void
                {
                        // Get the most recent frame and report some basic information
                        var frame:Frame = event.frame;
                        trace_txt.text = String( "Frame id: " + frame.id + ", timestamp: " + frame.timestamp + ", hands: " + frame.hands.length + ", fingers: " + frame.fingers.length);// + ", tools: " + frame.tools.length + ", gestures: " + frame.gestures().length );

                        if ( frame.hands.length > 0 ){
                                // Get the first hand
                                var hand:Hand = frame.hands[ 0 ];
								
                                // Check if the hand has any fingers
                                var fingers:Vector.<Finger> = hand.fingers;
                                if ( !fingers.length == 0 )
                                {
                                        // Calculate the hand's average finger tip position
										
                                        var avgPos:Vector3 = Vector3.zero();
                                        for each ( var finger:Finger in fingers ){
                                                avgPos = avgPos.plus( finger.tipPosition );
										}

                                        avgPos = avgPos.divide( fingers.length );
                                       // trace_txt.text = String( "Hand has " + fingers.length + " fingers, average finger tip position: " + avgPos );
                                }

                                // Get the hand's sphere radius and palm position
                                //trace_txt.text = String( "Hand sphere radius: " + hand.sphereRadius + " mm, palm position: " + hand.palmPosition );

                                // Get the hand's normal vector and direction
                                var normal:Vector3 = hand.palmNormal;
                                var direction:Vector3 = hand.direction;
								
								adjustServo(direction);

                                // Calculate the hand's pitch, roll, and yaw angles
                                trace_txt.text = String( "Hand pitch: " + LeapUtil.toDegrees( direction.pitch ) + " degrees, " + "roll: " + LeapUtil.toDegrees( normal.roll ) + " degrees, " + "yaw: " + LeapUtil.toDegrees( direction.yaw ) + " degrees\n" );
                        }

                        
                }
				
				private function adjustServo(vec:Vector3):void{
					var realPitch:Number = LeapUtil.toDegrees(vec.pitch); 
					var realYaw:Number = LeapUtil.toDegrees(vec.yaw); 
					dot_mc.rotationX = realPitch;
					dot_mc.rotationZ = realYaw;
					_dataSocket.writeUTF(String((90 + realPitch) + "|" + (realYaw)));
					_dataSocket.flush();
				}		////////// END OF CLASS	}}