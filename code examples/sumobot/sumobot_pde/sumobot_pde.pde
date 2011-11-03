//Initiate motors/////////////////////////////////////////////////////////////////
int dirA=12;                        //high(1) is forward, low(0) is reverse
int dirB=13;                        //high(1) is forward, low(0) is reverse
int speedA=10;                      //8 bit pwm 0-255
int speedB=11;                      //8 bit pwm 0-255


//Initiate linePin///////////////////////////////////////////////////////////////
int linePinR = 8;                  //rear line sesor belongs on digital pin8
int linePinF = 9;                  //front line sesor belongs on digital pin9


//Initiate irPin for distance finder/////////////////////////////////////////////
float irPin = 1;                   //distance sensor on analog pin1        


//Initiate pingPin, create variable & array for processing for sonar/////////////
//	int pingPin = 3;          //Parralex Ping belongs on pin3
//	float pingVal[10];	 // array to store first 10 values coming from the sensor
//	float pingValSum=0;	 // sum of first 10 readings
//	float pingValAvg=0;	 // average of the first 10 readings


//setup//////////////////////////////////////////////////////////////////////////
void setup() 
{

//5 sec delay in microseconds//////////////////////////////////////////////////// 
delay(5000);

//usb debug//////////////////////////////////////////////////////////////////////   
Serial.begin(9600);


// set the motor pins as outputs////////////////////////////////////////////////
pinMode(dirA, OUTPUT);
pinMode(dirB, OUTPUT);
pinMode(speedA, OUTPUT);
pinMode(speedB, OUTPUT);
}


//logic///////////////////////////////////////////////////////////////////////////
void loop(){ 

  
//line detector//////////////////////////////////////////////////////////////////
int qreValueR = readQD1();
int qreValueF = readQD2();


//send line sensor to debugger///////////////////////////////////////////////////////
//Serial.println(qreValueR);
//Serial.println(qreValueF);


//IR distance sensor/////////////////////////////////////////////////////////////
float irValue = readIR();


//begin sonar emit ping//////////////////////////////////////////////////////////
//	pinMode(pingPin, OUTPUT);
//  		digitalWrite(pingPin, LOW);
// 		delayMicroseconds(2);
// 		digitalWrite(pingPin, HIGH);
//		delayMicroseconds(5);
//  		digitalWrite(pingPin, LOW); 


//read sonar return ping////////////////////////////////////////////////////////  
// 	 pinMode(pingPin, INPUT);
//  		pingValAvg = pulseIn(pingPin, HIGH);


//send sonar to debugger///////////////////////////////////////////////////////
//  	Serial.println("Ping Distance");				
//  	Serial.println(pingValAvg);


//Ping detection Attack or Hunt///////////////////////////////////////////////
if (irValue <=70 && qreValueR > 200 && qreValueF > 200){ 
  goAttack();
  Serial.println("Attack");
}


else if (qreValueR <= 200){ 
  surviveR();
  Serial.println("SurviveR");
} 

else if (qreValueF <= 200){ 
  surviveF();
  Serial.println("SurviveF");
} 
else{ 
  goHunt();
  Serial.println("Hunt");  
}

}

//Attack Mode//////////////////////////////////////////////////////////////////
void goAttack()
{
  digitalWrite(dirA, HIGH);
  digitalWrite(dirB, HIGH);
  analogWrite(speedA, 255);
  analogWrite(speedB, 255);
}


//Hunt Mode///////////////////////////////////////////////////////////////////
void goHunt()
{
  digitalWrite(dirA, LOW);
  digitalWrite(dirB, HIGH);
  analogWrite(speedA, 200);
  analogWrite(speedB, 200);
  delayMicroseconds(200);
  digitalWrite(dirA, HIGH);
  digitalWrite(dirB, HIGH);
  analogWrite(speedA, 200);
  analogWrite(speedB, 200);   
}


//Survive Mode///////////////////////////////////////////////////////////////
void surviveR()
{
  digitalWrite(dirA, HIGH);
  digitalWrite(dirB, HIGH);
  analogWrite(speedA, 255);
  analogWrite(speedB, 255);
  delayMicroseconds(100);
  digitalWrite(dirA, LOW);
  digitalWrite(dirB, HIGH);
  analogWrite(speedA, 200);
  analogWrite(speedB, 200);
  delayMicroseconds(100);
}


void surviveF()
{
  digitalWrite(dirA, LOW);
  digitalWrite(dirB, LOW);
  analogWrite(speedA, 255);
  analogWrite(speedB, 255);
  delayMicroseconds(100);
  digitalWrite(dirA, LOW);
  digitalWrite(dirB, HIGH);
  analogWrite(speedA, 200);
  analogWrite(speedB, 200);
  delayMicroseconds(100);
}
 

//get line value Rear///////////////////////////////////////////////////////  
int readQD1(){
	pinMode(linePinR, OUTPUT);                                        //set ir as output
    	digitalWrite(linePinR, HIGH);                                     //turn on ir led
    	delayMicroseconds(10);                                            //leave on for 10 seconds

    	pinMode(linePinR, INPUT);                                         //set ir as input
    	long time = micros();                                             //turn on ir led
    	while (digitalRead(linePinR) == HIGH && micros() - time < 3000);  //read cap discharge in micros
    	int diff = (micros() - time)/10;                                       //compare time and micros assign difference to diff
return diff;                                                              //return diff to the calling function
}


//get line value Front///////////////////////////////////////////////////////
int readQD2(){
	pinMode(linePinF, OUTPUT);                                        //set ir as output
    	digitalWrite(linePinF, HIGH);                                     //turn on ir led
    	delayMicroseconds(10);                                            //leave on for 10 seconds

    	pinMode(linePinF, INPUT);                                         //set ir as input
    	long time = micros();                                             //create local variable time 
    	while (digitalRead(linePinF) == HIGH && micros() - time < 3000);  //read cap discharge in micros
    	int diff = (micros() - time)/10;                                       //compare time and micros assign difference to diff
return diff;	                                                          //return diff to the calling function
}    


//IR distance Sensor //////////////////////////////////////////
float readIR(){
      float volts = analogRead(irPin)*0.0048828125;   // value from sensor * (5/1024) - if running 3.3.volts then change 5 to 3.3
      float distance = 27*pow(volts, -1.10);          // worked out from datasheet 27 = theretical distance / (1/Volts)
//      Serial.println(distance);                       // print the distance should return value of 1-80cm 
return distance;
 }

