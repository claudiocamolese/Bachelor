volatile char REQ;
volatile unsigned short NOVR, MLow, MHi, ResH, ResL;
volatile long NPCount, ResN;
double fck = 15979377.7754;
long Tgate_ms = 1000;

void setup() {

  Serial.begin(57600);
  Serial.println("Ready");
  pinMode(8, INPUT);

  TCCR1A = 0b00000000;   
  TCCR1B = 0b00000001;  
  TIFR1 |= 32+1;  
  TIMSK1 |= 32+1; 

  delay(2000);
}

ISR(TIMER1_OVF_vect)
{
   NOVR++;
}

ISR(TIMER1_CAPT_vect) 
{
  MLow = ICR1;
  MHi = NOVR;
  NPCount++;
  if (REQ)
   {
    ResH = MHi;
    ResL = MLow;
    ResN = NPCount;
    REQ = 0;
   }
}

void loop(void){
 unsigned long m1,m2,m;
 unsigned N1,N2,NP;
 bool done;
 
 done=false;
 REQ=1;
  while(REQ==1){}
  m1=(unsigned long) ResL | ((unsigned long) ResH<<16);
  N1=ResN;
  
  delay(Tgate_ms);
  
  REQ=1;
  while(REQ==1){}  //aspetto che torni 0
  m2=(unsigned long) ResL | ((unsigned long) ResH<<16);
  N2=ResN;
  
  m=m2-m1;
  NP=N2-N1;
  
 // Serial.println(m);
  double freq = (fck/(double)m)*((double)NP);
  Serial.println("Frequenza letta: " + String(freq) + " Hz");
  Serial.println("freq_oscillatore: " + String((((float)freq)/(double)1)*(double)fck)+ " Hz"); 

  delay(500);
  
}
