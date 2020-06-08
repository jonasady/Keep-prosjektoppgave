#include <LiquidCrystal.h>

const int hoytaler = 8;
int roedt = 13;
int groent = 7;
int avslutt = 9;
int svar = 10;
int timer = 7;
bool svarf = false;
bool svarb = false;
int minutter = 9;
int sekunder = 0;
int timeteller =1;
int sekteller = 5;
int minteller = 5;
int buzzerPin = 8;
int lysVerdi = roedt;
int styrke;
int pot = A0;
const int rs = 12, en = 11, d4 = 5, d5 = 4, d6 = 3, d7 = 2;
LiquidCrystal lcd(rs, en, d4, d5, d6, d7);



void setup() {

lcd.begin(16, 2);
Serial.begin(9600);
  pinMode(pot, INPUT);
  pinMode(buzzerPin, OUTPUT);
  pinMode(roedt, OUTPUT);
  pinMode(groent, OUTPUT);
  pinMode(avslutt, INPUT);
  pinMode(svar, INPUT);
}

void loop() {
  styrke = analogRead(pot);
  
  int svarVerdi = digitalRead(svar);
  int avsluttVerdi = digitalRead(avslutt);
  Serial.println(styrke);
  if(timer == 8 && timeteller == 1){
      
   
    
    digitalWrite(roedt, LOW);
    digitalWrite(groent, 255);
   if(minutter == 0 && minteller == 0 && sekteller == 0){
       lcd.clear();
       lcd.print("Naa kan du ringe");
       
       alarm(440, 650);
     
    }
    else{
    if(1023/2 > styrke && svarf == false){
        lcd.clear();
        lcd.print("Ring frivillig");
    }
   
  
   if(svarVerdi == HIGH && 1023/2 > styrke){
          lcd.clear();
          lcd.print("Ringer.");
       
          delay(1000);
          lcd.clear();
          lcd.print("Ringer .");
          delay(1000);
          lcd.clear();
          lcd.print("Ringer  .");
          delay(1000);
          svarf = true;
          sekunder += 3;
    }
    
        
    if(svarf == true){
       lcd.clear();
       lcd.print("Frivllig svarte");
       
      if(avsluttVerdi == HIGH){
        lcd.clear();
        lcd.print("Avslutter");
        delay(1000);
        sekunder += 1;
        svarf = false;
      }
    }
    if(1023/2 < styrke && svarb == false){
        lcd.clear();
        lcd.print("Ring beboer");
    }

    if(svarVerdi == HIGH && 1023/2 < styrke){
           lcd.clear();
          lcd.print("Ringer.");
       
          delay(1000);
          lcd.clear();
          lcd.print("Ringer .");
          delay(1000);
          lcd.clear();
          lcd.print("Ringer  .");
          delay(1000);
          svarb = true;
          sekunder += 3;
    
    }
        
    if(svarb == true){
       lcd.clear();
       lcd.print("Beboer svarte");
       
      if(avsluttVerdi == HIGH){
        lcd.clear();
        lcd.print("Avslutter");
        delay(1000);
        sekunder += 1;
      
        svarb = false;
      }
    }
    }
   
  }
  
  else {
    digitalWrite(groent, LOW);
    digitalWrite(roedt, 255);
     lcd.clear();
     lcd.print(timeteller);
     lcd.print(timer);
     lcd.print(":");
     lcd.print(minteller);
     lcd.print(minutter);
     lcd.print(":");
     lcd.print(sekteller);
     lcd.print(sekunder);
  
  }
 
  delay(1000);
 sekunder ++;
 if(sekunder == 10){
  sekteller++;
  sekunder = 0;
  }
  if(sekteller == 6){
    sekteller = 0;
    minutter++;
  }
  if(minutter == 10){
    minutter =0;
    minteller ++;
  }
  if(minteller == 6){
    timer ++;
    minteller = 0;
  }
  if(timer == 10){
    timeteller++;
    timer = 0;
  }
  if(timeteller == 2 && timer == 4){
    sekteller = 0;
    sekunder = 0;
    minutter = 0;
    minteller = 0;
    timer = 0;
    timeteller = 0;
  }
  

}
  void alarm(int note, int duration){
  

  tone(buzzerPin, note, duration);
}
