//Importerer liquid crystal display fra arduino-bibloteket
#include <LiquidCrystal.h>

//Definerer hvor man finner inngangene til hoytaler, roed- og grønn verdi til RGB-lyset,
//avslutt og svar-knappen, samt definerer inngangene paa liquid crystal displayet.

//I tillegg defineres variablene svarf og svarb av typen boolean, styrke, lysverdi og verdier tilknyttet klokken
//(sekunder, minutter, timer, sekundteller, minteller, timeteller). Disse tidsverdiene er satt til at klokka skal 
//vaere 17:59:50 for at det fort(med et tidspenn på 10 sekunder) kan testes om implementasjonene som gjelder etter
//18:00:00 fungerer. I en realistisk situasjon stilles selvfoelgelig klokka etter faktisk tidspunkt.

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
int hoytalerPin = 8;
int lysVerdi = roedt;
int styrke;
int pot = A0;
const int rs = 12, en = 11, d4 = 5, d5 = 4, d6 = 3, d7 = 2;
LiquidCrystal lcd(rs, en, d4, d5, d6, d7);



void setup() {
//Definerer lcd-displayet kolonner(andre verdi) og rader(foerste verdi);
  lcd.begin(16, 2);
//Definerer at potentiometeret skal fungere som input
  pinMode(pot, INPUT);
  
//Definerer at de tilknytta inngangene for hoytalerPinm, roedt og groent skal sende ut signal
  pinMode(hoytalerPin, OUTPUT);
  pinMode(roedt, OUTPUT);
  pinMode(groent, OUTPUT);
  
//Definerer avslutt og svar som input
  pinMode(avslutt, INPUT);
  pinMode(svar, INPUT);
}

void loop() {
  //Styrke leser av verdien til potentiometeret
  styrke = analogRead(pot);
  
  //svarVerdi og avsluttVerdi leser av tilhørende verdi, altså verdien til svar eller avlsutt-knappen(HIGH eller LOW)
  int svarVerdi = digitalRead(svar);
  int avsluttVerdi = digitalRead(avslutt);
  
  //If-setningen blir gjeldenede om klokka er 18:00
  if(timer == 8 && timeteller == 1){
    //Setter lyset til å bli grønt: ved aa sette ned RGB-lysets roede verdi fra inngang 13 og legger groent med verdien 255)  
    digitalWrite(roedt, LOW);
    digitalWrite(groent, 255);
    
    //If-setningen sier at dersom klokka er 18:00:00 og sekunder erlik 0, vil hoytaleren pipe(se forklaring i alarm-metoden)
    //I praksis vil dette si at hoytaleren piper i 10 sekunder, ettersom sekunder er definert som ti-talls sekunder- altsaa 
    //at sekundtelleren teller antall sekunder, og variabelen skunder plusses på dersom sukundertelleren == 10
   if(minutter == 0 && minteller == 0 && sekteller == 0){
       lcd.clear();
       lcd.print("Naa kan du ringe");
       
       alarm(440, 650);
     
    }
    else{
    //Etter klokka er 18.00 og if-setningen over er ferdig etter ti-skunder vil else-setningen gjelde.
    //Om potentiometerverdien(styrke) er større enn 1023/2 og boolean svarf == false vil lcd kommunisere til brukeren at man kan ringe
    //en frivillig
    if(1023/2 > styrke && svarf == false){
        lcd.clear();
        lcd.print("Ring frivillig");
    }
   
  //Om brukeren trykker inn svar-knappen vil svarverdi vaere HIGH og styrken er lavere enn halvparten av max av 
  //potentiometerverdien(1023) vil lcd kommunisere til brukeren at man ringer
  //Sekunder plusses på 3 pga delay paa 3 skunder. Sekteller maa plusses paa for at klokken skal stemme.
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
    
    //Om svarf(eller svar for frivillig) erlik true vil "Frivillig svarte" staa paa lcd saa lenge 
    //brukeren ikke trykker paa avsluttverdi. Meningen er at frivillig kan "snakke" med beboer saa
    //lenge beboer ikke trykker paa knappen. Om knappen trykkes vil lcd gaa tilbake til valg mellom 
    //aa ringe frivillig eller beboer
    
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
    //Samme prinsipp som svarf, bare at naa putter man det i en beboerkontekst
    //Dersom man stiller inn paa beboer(altsaa at potentiometerverdien(styrke) er 
    //over halvparten saa stor som 1023 vil det samme som staar forklart for frivillig skje.
    
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
  //Setter roedt lys dersom klokken ikke er 18.00 og viser klokken
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
 //Etter ett delay paa 1 sekund vil sekunder plusses paa og sekteller, minutter 
 //minteller, timer og timeteler vil plusses paa deretter ettersom if-sjekkene oppfylles 
 //og klokka blir mer.
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
//Metoden legger til en note og tid (int) og legger dette til i den innebygde metoden tone for 
//aa gi ut lyd
  void alarm(int note, int duration){
  

  tone(hoytalerPin, note, duration);
}
