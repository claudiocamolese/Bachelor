volatile char REQ;
volatile unsigned short NOVR, MLow, MHi, ResH, ResL;
volatile long NPCount, ResN;
double fck = 16e6;
long Tgate_ms = 1000;

void setup() 
{
    Serial.begin(57600);
    Serial.println("Ready");
    pinMode(8, INPUT);
    pinMode(9,OUTPUT);

    TCCR1A = 0b01000000; // Nessuna azione sui pin
    TCCR1B = 0b00001001; // Normal Mode, Prescaler 1:1
 
    TIFR1 |= 2; // Cancella IF cattura e IF Overflow
    TIMSK1 |= 2; // Abilita IE cattura e IE Overflow

    OCR1A = 80-1;
    OCR1B = 7000;

}



void loop()
{
}

