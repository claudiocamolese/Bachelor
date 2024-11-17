#include <math.h>
#define Prescaler_Tim 1
#define R_s 99627
#define Vref 5.01
double Freq_correct = 15979377;



void setup() {
  // settaggio generale porte e pin
  Serial.begin(57600);
  pinMode(9, OUTPUT);
  pinMode(10, OUTPUT);
  
  // ------------configurazione timer--------------
  TCCR1B = 0b00001000;    // modalita CTC e modalita' STOP
  // 76 -> OC mode soglia A (11 -> set on match, 10 -> clear on match, 01 -> toggle on match)
  // 54 -> OC mode soglia B 
  TCCR1A = 0b11000000;    // settaggio set on soglia A 
  // 7 -> control soglia A, 6 -> control soglia B
  TCCR1C = 0b10000000;    // forzo evento soglia A

  TCCR1A = 0b10010000;    // settaggio A in clear on match e B in toggle on match

  // 210 -> prescaler, 43 -> mode (01 -> CTC)
  TCCR1B = 0b00001000;    // modalita CTC e modalita' STOP

  //OCR1A = 3306;   // soglia A
  OCR1A = 10000;
  //OCR1B = 15;     // soglia B
  OCR1B = 10;
  TCNT1 = 3306-1;   // valore inizializzazione contatore A-1
  
  TIFR1 |= 4;    // da pdf  per portare a 0 la IF con routine vuota
  TIMSK1 |= 4;   // da pdf


  // ------------configurazione ADC--------------
  // leggo dal pin analogico
  analogRead(A2); // arduino imposta automaticamente molti registri

  //setto registro A ADC 
  // 7 -> on, 6 -> avvio, 5 -> trigger hw attivato inizio conv
  // 4-> flag interrupt fine conversione 3-> flag gestione interrupt
  // 210 -> prescaler ADC (111 -> 128)
  ADCSRA=0b10110111;
  //setto registro B ADC 
  // 6 -> collegamento  analog
  // 210 -> trigger source (101 -> compare match B)
  ADCSRB=0b00000101;
  
  Serial.println("Ready");
}

//Interrupt service routines vuote
ISR (TIMER1_COMPA_vect){
}
ISR (TIMER1_COMPB_vect){
}


void loop() {
  // definizione variabili locali
  float V_0,V_1;
  float C_x,T;

  // attesa carica condensatore
  delay(10); //tau = 3.3e-4 (3.3nF * R) -> delay >= 10tau

  // prescaler timer = 1
  TCCR1B|=1;
  
  // --- misura V0 ---
  ADCSRA|=16;                     // cancellazione IF ADC
  while(!(ADCSRA & 16));          // Attesa IF ADC
  V_0=(float)(ADC/1024.0)*Vref;   // lettura di V_0 dall'ADC

  // --- misura V1 ---
  ADCSRA|=16;                     // cancellazione IF ADC
  while(!(ADCSRA & 16));          // Attesa IF ADC
  V_1=(float)(ADC/1024.0)*Vref;     // lettura di V_1 dall'ADC

  // complemento bit a bit
  TCCR1B&=~1;     // stop timer, prescaler = 0 
  
  // --- calcolo capacita' ---
  T = (OCR1A + 1) * Prescaler_Tim * (1 / Freq_correct);
  C_x = 1000000000 * T / (R_s * log(double(V_0 / V_1)));

  Serial.println("Capacita': " + String(C_x,10) + " nF");
  Serial.println("Intervallo T: " + String(T*1000,7) + " ms");

  // stop programma
  while(1);
}
