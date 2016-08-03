const int outputPin = 12; 

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(outputPin, OUTPUT);
}

void loop() {
}

void serialEvent(){
  if((int)Serial.read() == 1){
    digitalWrite(outputPin, HIGH);
    delay(200);
    digitalWrite(outputPin, LOW);
  }   
}

