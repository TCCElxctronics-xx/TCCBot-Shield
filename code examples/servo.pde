// Sweep
// This example will sweep 180 degrees. 
// As it is sweeping it prints the value to 
// serial via the USB.
// Pins 5 & 6 are servo ready pins.

#include <Servo.h> 
 
Servo myservo;  // create servo object to control a servo 
 
int pos = 0;    // variable to store the servo position 
 
void setup() 
{ 
	myservo.attach(5);  // attaches the servo on pin 5 to the servo object 

 
	Serial.begin(9600);	//usb debug  
} 
 
 
void loop() 
{ 
	for(pos = 0; pos < 180; pos += 1)  // goes from 0 degrees to 180 degrees 
  	{                                  // in steps of 1 degree 
    		myservo.write(pos);        // tell servo to go to position
		Serial.println("pos");	   // send the value of variable "pos" to usb
    		delay(15);                 // waits 15ms
  	}
 
  	for(pos = 180; pos>=1; pos-=1)     // goes from 180 degrees to 0 degrees 
 	{                                
    		myservo.write(pos);        // tell servo to go to position
		Serial.println("pos");	   // send the value of variable "pos" to usb
    		delay(15);                 // waits 15ms
  	} 
}
