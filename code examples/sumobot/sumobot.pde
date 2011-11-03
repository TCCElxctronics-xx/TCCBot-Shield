//Initiate motors/////////////////////////////////////////////////////////////////
	int dirA=12;
	int dirB=13;
	int speedA=10;
	int speedB=11;


//Initiate linePin, create variable & array for processing////////////////////////
	int linePin1 = 8;
	int linePin2 = 9;

//Initiate pingPin, create variable & array for processing////////////////////////
	int pingPin = 3;
	float pingVal[10];	 // array to store first 10 values coming from the sensor
	float pingValSum=0;	 // sum of first 10 readings
	float pingValAvg=0;	 // average of the first 10 readings


//begin process////////////////////////////////////////////////////////////////
void setup() 
{

//5 sec delay in microseconds 
	delay(5000);

//usb debug   
	Serial.begin(9600);

// set the motor pins as outputs///////////////////////////////////////////////
	pinMode(dirA, OUTPUT);
	pinMode(dirB, OUTPUT);
  	pinMode(speedA, OUTPUT);
  	pinMode(speedB, OUTPUT);
}


//logic//////////////////////////////////////////////////////////////////////////
void loop(){ 

//line detector//////////////////////////////////////////
	int QRE_Value1 = readQD1();
	int QRE_Value2 = readQD2();

//begin emit ping////////////////////////////////////////
	pinMode(pingPin, OUTPUT);
  		digitalWrite(pingPin, LOW);
  		delayMicroseconds(5);
  		digitalWrite(pingPin, HIGH);
 		delayMicroseconds(10);
  		digitalWrite(pingPin, LOW); 
  		delayMicroseconds(5); 

//read return ping  
 	 pinMode(pingPin, INPUT);
  		pingValAvg = pulseIn(pingPin, HIGH);

//send to debugger///////////////////////////////////////
  	Serial.println("Ping Distance");				
  	Serial.println(pingValAvg);

//Ping detection Attack or Hunt//////////////////////////
  	if (pingValAvg <=4000 && QRE_Value1 <= 100)
{ 
    	goAttack();
    	Serial.println("Attack");
}

  		else if (pingValAvg >4001 && QRE_Value1 <= 100)
  		{ 
    			goHunt();
    			Serial.println("Hunt");  
  		}

  			else if (QRE_Value1 > 101)
  			{ 
    			survive();
    			Serial.println("Survive");
  			} 

  	Serial.println("line_value");
  	Serial.println(QRE_Value1);
}

//Attack Mode///////////////////////////////////////////
void goAttack()
{
  	digitalWrite(dirA, HIGH);
  	digitalWrite(dirB, HIGH);
  	analogWrite(speedA, 255);
  	analogWrite(speedB, 255);
}

//Hunt Mode/////////////////////////////////////////////
void goHunt()
{
  	digitalWrite(dirA, LOW);
  	digitalWrite(dirB, HIGH);
  	analogWrite(speedA, 200);
  	analogWrite(speedB, 200);
}

//Survive Mode//////////////////////////////////////////
void survive()
{
  digitalWrite(dirA, LOW);
  digitalWrite(dirB, LOW);
  analogWrite(speedA, 255);
  analogWrite(speedB, 255);
  delayMicroseconds(100);
}
  
int readQD1(){
	pinMode(linePin1, OUTPUT);
    	digitalWrite(linePin1, HIGH);
    	delayMicroseconds(10);

//read line value
    	pinMode(linePin1, INPUT);
    	long time = micros();
    	while (digitalRead(linePin1) == HIGH && micros() - time < 3000);
    	int diff = micros() - time;
return diff;
}

int readQD2(){
	pinMode(linePin2, OUTPUT);
    	digitalWrite(linePin2, HIGH);
    	delayMicroseconds(10);

//read line value
    	pinMode(linePin2, INPUT);
    	long time = micros();
    	while (digitalRead(linePin2) == HIGH && micros() - time < 3000);
    	int diff = micros() - time;
return diff;	
}

