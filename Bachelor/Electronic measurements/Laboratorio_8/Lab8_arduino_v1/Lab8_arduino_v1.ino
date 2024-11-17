#define NPOINTS 151
#define DT 120
void setup() {
  Serial.begin(57600);
  pinMode(9, OUTPUT);
  pinMode(10, OUTPUT);
  // Configurazione TIMER 1
  TCCR1B = 0b00001000; // Modalita CTC, no clock
  TCCR1A = 0b11010000; // Configura PIN HI su soglia A
  TCCR1C |=0b10000000; // Forza l'output (HI) simulando l’evento soglia A
  TCCR1A = 0b01010000; // Configura PIN Toggle su soglia A
  OCR1A = 21013-1; // Usa un periodo "asincrono" con 20 mS (1/50 Hz)
  OCR1B = 0; // TA = 0 us
  TCNT1 = OCR1A-1; // Inizia quasi subito la scarica
  TIFR1 |= 4; // Cancella interrupt soglia B
  TIMSK1 |= 4; // Abilita interrupt soglia B
  // Configurazione ADC
  analogRead(A2);
  ADCSRA = 0b10110111; // ON, ADATE=1, IF Clear, IE = 0, Prescaler = 111 (1:128)
  ADCSRB = 0b00000101; // Trigger hardware: Timer 1 soglia B
}

ISR(TIMER1_COMPB_vect) {}

void loop() {
  unsigned short TAB = 0; // Memorizza il tempo TAB desiderato
  TCCR1B |= 1; // Start counting: prescaler 1:1
  for(int d=0; d<200; d++) // Scarta 200 campioni in attesa che C si stabilizzi
  {
    ADCSRA |= 16; // Clear IF
    while(!(ADCSRA & 16)); // Attende campione
  }
  while(1) // Ciclo di acquisizione infinito
  {
    TAB = 0; // Azzera il tempo TAB desiderato
    signed long NextB; // Variabile di supporto
    for(int r=0; r < NPOINTS; r++) // Ciclo di acquisizione di NPOINTS punti
  {
  NextB = (signed long) TAB - 255; // Calcola la soglia B reale
  if (NextB < 0) NextB = (OCR1A+1) + NextB; // Corregge la soglia B reale
  OCR1B = NextB; // Rende effettiva la soglia B reale
  ADCSRA |= 16; // Clear IF ADC
  while(!(ADCSRA & 16)); // Attende primo campione
  ADCSRA |= 16; // Clear IF ADC
  Serial.print(ADC); // Invia il campione al computer
  Serial.print(" "); // Invia uno spazio separatore al computer
  while(!(ADCSRA & 16)); // Attende campione
  TAB += DT; // Incrementa il tempo TAB desiderato di DT
  }
    Serial.println(""); // Termina la linea di testo con campioni
  }
}
