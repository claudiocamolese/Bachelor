// Laboratorio 4 misure. v2

// dichiarazione variabili pin 
int Analog_pin_sens = A2;         // pin voltaggio sensore
int Analog_pin_volt = A3;         // pin voltaggio tensione di riferimento
int Digital_pin_led_high = 13;    // pin led high
int Digital_pin_led_ok = 12;      // pin led ok
int Digital_pin_led_low = 11;     // pin led low

// variables
int Volt_ref = 5.1064;
int Nadc_read;
int Vadc_read;
int Random_number;
float Beta = 513.8; 

float Sens_coeff = 0.01;    // coefficiente di sensibilita'
float Nadc_read_sum;        // 0 to 1023 misura letta
float Temp_calc;            // temperatura calcolata
float Volt_calc;            // tensione sul sensore calcolata
float Temp_calc_x10;        // tensione calcolata moltiplicata x10 per poter essere trasmessa a Labview
float Volt_ref_calc;        // voltaggio di riferimento calcolato

char Led;                   // carattere letto da Labview

void setup() {
  // definizione modalita' pin
  pinMode(Digital_pin_led_high  , OUTPUT);  // led high
  pinMode(Digital_pin_led_ok    , OUTPUT);  // led ok
  pinMode(Digital_pin_led_low   , OUTPUT);  // led low

  pinMode(Analog_pin_sens       , INPUT);   // input sensore 
  pinMode(Analog_pin_volt       , INPUT);    
 
  // Utilities
  analogReference(DEFAULT);

  // apertura comunnicazione seriale
  Serial.begin(9600, SERIAL_8N1);
}



void loop() {
  
  // leggo i sample del voltaggio sul sensore
  // versione senza media
  Nadc_read = analogRead(Analog_pin_sens);
  
  /*
  // versione con la media dei campioni
  Nadc_read_sum = 0;
  for (int i = 0; i < 40; i++)
  {
    Nadc_read = analogRead(Analog_pin_sens);
    Nadc_read_sum = Nadc_read_sum + Nadc_read;
    delay(1);
  }
  */

  /*
  // calcoli senza media
  Volt_calc = Nadc_read * (Volt_ref / 1024.0);
  Temp_calc = (Volt_calc / Sens_coeff) - 273.15;
  Temp_calc_x10 = Temp_calc * 10;
  */

  
  Temp_calc = ((Nadc_read / 1024.0) * Beta ) - 273.15;
  Temp_calc_x10 = Temp_calc * 10;
  
  /*
  Volt_calc = ((Nadc_read_sum/40.0) * (Volt_ref / 1024.0));
  Temp_calc = (Volt_calc / Sens_coeff) - 273.15;
  Temp_calc_x10 = Temp_calc * 10;
  */

  // lettura carattere inviato da Labview
  if (Serial.available() > 0 )
  {
      Led = Serial.read();  // salvo il primo carattere letto
  }


  // scrivo la temperatura letta nel foramto voluto
  Serial.println(Temp_calc_x10,0);
  Serial.println(Nadc_read);
  // resetto le luci
  digitalWrite(Digital_pin_led_low, LOW);
  digitalWrite(Digital_pin_led_ok, LOW);
  digitalWrite(Digital_pin_led_high, LOW);

  // in base al dato ricevuto abilito il led corretto
  if (Led == 'A')
  {
    digitalWrite(Digital_pin_led_low, HIGH);
  }
  else if (Led == 'B')
  {
    digitalWrite(Digital_pin_led_high, HIGH);
  }
  else if (Led == 'C')
  {
    digitalWrite(Digital_pin_led_ok, HIGH);
  }
  
  // misura ogni 250 ms 
  // si tolgonno 40 ms se si deve fare la media delle misure
  delay(250-40);
}