//Initiate motors/////////////////////////////////////////////////////////////////
	int dirA1=3;
	int dirA2=4;
	int dirB1=6;
	int dirB2=7;
	int speedA=10;
	int speedB=11;


//Initiate linePin, create variable & array for processing////////////////////////
	int linePin = 8;

//Initiate pingPin, create variable & array for processing////////////////////////
	int pingPin = 2;
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
	pinMode(dirA1, OUTPUT);
	pinMode(dirA2, OUTPUT);
	pinMode(dirB1, OUTPUT);
	pinMode(dirB2, OUTPUT);
  	pinMode(speedA, OUTPUT);
  	pinMode(speedB, OUTPUT);
}


//logic//////////////////////////////////////////////////////////////////////////
void loop(){ 

//line detector//////////////////////////////////////////
	int QRE_Value = readQD();

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
  	if (pingValAvg <=4000 && QRE_Value <= 100)
{ 
    	goAttack();
    	Serial.println("Attack");
}

  		else if (pingValAvg >4001 && QRE_Value <= 100)
  		{ 
    			goHunt();
    			Serial.println("Hunt");  
  		}

  			else if (QRE_Value > 101)
  			{ 
    			survive();
    			Serial.println("Survive");
  			} 

  	Serial.println("line_value");
  	Serial.println(QRE_Value);
}

//Attack Mode///////////////////////////////////////////
void goAttack()
{
  	digitalWrite(dirA1, HIGH);
  	digitalWrite(dirA2, LOW);
  	digitalWrite(dirB1, HIGH);
  	digitalWrite(dirB2, LOW);
  	analogWrite(speedA, 255);
  	analogWrite(speedB, 255);
}

//Hunt Mode/////////////////////////////////////////////
void goHunt()
{
  	digitalWrite(dirA1, LOW);
  	digitalWrite(dirA2, HIGH);
  	digitalWrite(dirB1, HIGH);
  	digitalWrite(dirB2, LOW);
  	analogWrite(speedA, 200);
  	analogWrite(speedB, 200);
}

//Survive Mode//////////////////////////////////////////
void survive()
{
  digitalWrite(dirA1, LOW);
  digitalWrite(dirA2, HIGH);
  digitalWrite(dirB1, LOW);
  digitalWrite(dirB2, HIGH);
  analogWrite(speedA, 255);
  analogWrite(speedB, 255);
  delayMicroseconds(100);
}
  
int readQD(){
	pinMode(linePin, OUTPUT);
    	digitalWrite(linePin, HIGH);
    	delayMicroseconds(10);

//read line value
    	pinMode(linePin, INPUT);
    	long time = micros();
    	while (digitalRead(linePin) == HIGH && micros() - time < 3000);
    	int diff = micros() - time;
return diff;
}

