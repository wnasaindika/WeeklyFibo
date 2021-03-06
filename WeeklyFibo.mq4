#property copyright "Copyright 2018, Ultralogs Ltd"
#property link      "https://www.fx.ultralogs.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+

//---- input parameters
extern int nPeriod=10;
extern int Limit=350;
///---- int Widners Oscilator
int cnt,nCurBar=0;

int init()
  {
  //---- Output in Char
   for(cnt=0; cnt<=5; cnt++)
     {
      ObjectCreate("WSO-"+cnt,OBJ_HLINE,0,0,0);
      ObjectSet("WSO-"+cnt,OBJPROP_COLOR,Red);
      if(cnt<5)
        {
         ObjectCreate("Trend DN-"+cnt,OBJ_TREND,0,0,0,0,0);
         ObjectSet("Trend DN-"+cnt,OBJPROP_COLOR,FireBrick);
        }
      //----
      ObjectCreate("WRO-"+cnt,OBJ_HLINE,0,0,0);
      ObjectSet("WRO-"+cnt,OBJPROP_COLOR,FireBrick);
      if(cnt<5)
        {
         ObjectCreate("Trend UP-"+cnt,OBJ_TREND,0,0,0,0,0);
         ObjectSet("Trend Up-"+cnt,OBJPROP_COLOR,DarkGreen);
        }
     }
//----
    //---- indicators
      ObjectDelete("XIT_FIBO");
      ObjectDelete("XIT_FIBO2");
      Comment("");
    //----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
     for(cnt=0; cnt<=5; cnt++)
     {
      ObjectDelete("Trend UP-"+cnt);
      ObjectDelete("Trend DN-"+cnt);
      ObjectDelete("WSO-"+cnt);
      ObjectDelete("WRO-"+cnt);
     }
      ObjectDelete("XIT_FIBO");
      ObjectDelete("XIT_FIBO2");
      Comment("");
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
     int shift =1;
     int fhourshift=1;
     int hourshift=1;
     int thminshift=1;
     int fithminshift=1;
     int fibHigh=iHighest(Symbol(),PERIOD_W1,MODE_OPEN,1,1);
     int fibLow=iLowest(Symbol(),PERIOD_W1,MODE_CLOSE,1,1);
   
     if(DayOfWeek()==1)
     {
       shift=1;
       fhourshift=Hour()/4;
       hourshift =Hour();
       thminshift = Hour()*2;
       fithminshift =Hour()*4;
     }
     if(DayOfWeek()==2)
     {
       shift=2;
       fhourshift=6+Hour()/4;
       hourshift =24+Hour();
       thminshift = 48+Hour()*2;
       fithminshift =72+Hour()*4;
     }
      if(DayOfWeek()==3)
     {
       shift=3;
       fhourshift=12+Hour()/4;
       hourshift =48+Hour();
       thminshift = 96+Hour()*2;
       fithminshift =192+Hour()*4;
     }
      if(DayOfWeek()==4)
     {
       shift=4;
       fhourshift=24+Hour()/4;
       hourshift =72+Hour();
       thminshift = 144+Hour()*2;
       fithminshift =288+Hour()*4;
     }
      if(DayOfWeek()==5)
     {
       shift=5;
       fhourshift=30+Hour()/4;
       hourshift =96+Hour();
       thminshift = 196+Hour()*2;
       fithminshift =392+Hour()*4;
     }
   
     if(Period()==PERIOD_W1)
     {
         fibHigh=iHighest(Symbol(),PERIOD_W1,MODE_OPEN,1,1);
         fibLow=iLowest(Symbol(),PERIOD_W1,MODE_CLOSE,1,1);
     }
     if(Period()==PERIOD_D1)
     {
         fibHigh=iHighest(Symbol(),PERIOD_D1,MODE_OPEN,5,shift);
         fibLow=iLowest(Symbol(),PERIOD_D1,MODE_CLOSE,5,shift);
     }
     if(Period()==PERIOD_H4)
     {
         fibHigh=iHighest(Symbol(),PERIOD_H4,MODE_OPEN,30,fhourshift);
         fibLow=iLowest(Symbol(),PERIOD_H4,MODE_CLOSE,30,fhourshift);
     }
     if(Period()==PERIOD_H1)
     {
         fibHigh=iHighest(Symbol(),PERIOD_H1,MODE_OPEN,120,hourshift);
         fibLow=iLowest(Symbol(),PERIOD_H1,MODE_CLOSE,120,hourshift);
     }   
     if(Period()==PERIOD_M30)
     {
         fibHigh=iHighest(Symbol(),PERIOD_M30,MODE_OPEN,240,thminshift);
         fibLow=iLowest(Symbol(),PERIOD_M30,MODE_CLOSE,240,thminshift);
     }  
     if(Period()==PERIOD_M15)
     {
         fibHigh=iHighest(Symbol(),PERIOD_M15,MODE_OPEN,480,fithminshift);
         fibLow=iLowest(Symbol(),PERIOD_M15,MODE_CLOSE,480,fithminshift);
     } 
     
     datetime highTime = Time[fibHigh];
     datetime lowTime  = Time[fibLow];
     
   color levelColor = Red;
   if(fibHigh>fibLow)
   {
      WindowRedraw();
      ObjectCreate("XIT_FIBO",OBJ_FIBO,0,highTime,Open[fibHigh],lowTime,Close[fibLow]);
      ObjectCreate("XIT_FIBO2",OBJ_FIBO,0,lowTime,Open[fibLow],highTime,Close[fibHigh]);
   }
   else
   {
      WindowRedraw();
      ObjectCreate("XIT_FIBO2",OBJ_FIBO,0,highTime,Open[fibHigh],lowTime,Close[fibLow]);
      ObjectCreate("XIT_FIBO",OBJ_FIBO,0,lowTime,Open[fibLow],highTime,Close[fibHigh]);
   }
     ObjectSet("XIT_FIBO",OBJPROP_FIBOLEVELS,10);
     
        
     ObjectSet("XIT_FIBO",OBJPROP_FIRSTLEVEL+0,0.0);
     ObjectSet("XIT_FIBO",OBJPROP_FIRSTLEVEL+1,0.236);
     ObjectSet("XIT_FIBO",OBJPROP_FIRSTLEVEL+2,0.382);
     ObjectSet("XIT_FIBO",OBJPROP_FIRSTLEVEL+3,0.50);
     ObjectSet("XIT_FIBO",OBJPROP_FIRSTLEVEL+4,0.618);
     ObjectSet("XIT_FIBO",OBJPROP_FIRSTLEVEL+5,1.0);
     
     ObjectSet("XIT_FIBO",OBJPROP_FIRSTLEVEL+6,1.236);
     ObjectSet("XIT_FIBO",OBJPROP_FIRSTLEVEL+7,1.382);
     ObjectSet("XIT_FIBO",OBJPROP_FIRSTLEVEL+8,1.50);
     ObjectSet("XIT_FIBO",OBJPROP_FIRSTLEVEL+9,1.618);
 
     
     
     ObjectSet("XIT_FIBO",OBJPROP_LEVELCOLOR,levelColor);
     ObjectSet("XIT_FIBO",OBJPROP_LEVELWIDTH,1);
     ObjectSet("XIT_FIBO",OBJPROP_LEVELSTYLE,STYLE_SOLID);
     
     
     ObjectSetFiboDescription( "XIT_FIBO", 0,"0.0%"); 
     ObjectSetFiboDescription( "XIT_FIBO", 1,"23.6%"); 
     ObjectSetFiboDescription( "XIT_FIBO", 2,"38.2%"); 
     ObjectSetFiboDescription( "XIT_FIBO", 3,"50.0%");
     ObjectSetFiboDescription( "XIT_FIBO", 4,"61.8%");
     ObjectSetFiboDescription( "XIT_FIBO", 5,"100.0%");
   
     ObjectSetFiboDescription( "XIT_FIBO", 6,"123.6%"); 
     ObjectSetFiboDescription( "XIT_FIBO", 7,"138.2%");
     ObjectSetFiboDescription( "XIT_FIBO", 9,"150.0%");
     ObjectSetFiboDescription( "XIT_FIBO", 8,"161.8%");
     
   
   
     ObjectSet("XIT_FIBO2",OBJPROP_FIBOLEVELS,4);
     
        
     //ObjectSet("XIT_FIBO",OBJPROP_FIRSTLEVEL+0,0.0);
     //ObjectSet("XIT_FIBO",OBJPROP_FIRSTLEVEL+1,0.236);
     //ObjectSet("XIT_FIBO",OBJPROP_FIRSTLEVEL+2,0.382);
     //ObjectSet("XIT_FIBO",OBJPROP_FIRSTLEVEL+3,0.50);
    // ObjectSet("XIT_FIBO",OBJPROP_FIRSTLEVEL+4,0.618);
     //ObjectSet("XIT_FIBO",OBJPROP_FIRSTLEVEL+5,1.0);
     
     ObjectSet("XIT_FIBO2",OBJPROP_FIRSTLEVEL+1,1.236);
     ObjectSet("XIT_FIBO2",OBJPROP_FIRSTLEVEL+2,1.382);
     ObjectSet("XIT_FIBO2",OBJPROP_FIRSTLEVEL+3,1.50);
     ObjectSet("XIT_FIBO2",OBJPROP_FIRSTLEVEL+4,1.618);
 
     
     
     ObjectSet("XIT_FIBO2",OBJPROP_LEVELCOLOR,levelColor);
     ObjectSet("XIT_FIBO2",OBJPROP_LEVELWIDTH,1);
     ObjectSet("XIT_FIBO2",OBJPROP_LEVELSTYLE,STYLE_SOLID);
     
     
     //ObjectSetFiboDescription( "XIT_FIBO", 0,"0.0%"); 
     //ObjectSetFiboDescription( "XIT_FIBO", 1,"23.6%"); 
     //ObjectSetFiboDescription( "XIT_FIBO", 2,"38.2%"); 
     //ObjectSetFiboDescription( "XIT_FIBO", 3,"50.0%");
     //ObjectSetFiboDescription( "XIT_FIBO", 4,"61.8%");
     //ObjectSetFiboDescription( "XIT_FIBO", 5,"100.0%");
   
     ObjectSetFiboDescription( "XIT_FIBO2", 1,"-23.6%"); 
     ObjectSetFiboDescription( "XIT_FIBO2", 2,"-38.2%");
     ObjectSetFiboDescription( "XIT_FIBO2", 3,"-50.0%");
     ObjectSetFiboDescription( "XIT_FIBO2", 4,"-61.8%");
     
   
  
   
     //drawing trend line
   double r1,r2,r3,r4,r5,r6;
   int rt1,rt2,rt3,rt4,rt5,rt6;
   double s1,s2,s3,s4,s5,s6;
   int st1,st2,st3,st4,st5,st6;
   if(Bars<Limit) Limit=Bars-nPeriod;
   for(nCurBar=Limit; nCurBar>0; nCurBar--)
     {
      if(Low[nCurBar+(nPeriod-1)/2]==Low[Lowest(NULL,0,MODE_LOW,nPeriod,nCurBar)])
        {
         s6=s5; s5=s4; s4=s3; s3=s2; s2=s1; s1=Low[nCurBar+(nPeriod-1)/2];
         st6=st5; st5=st4; st4=st3; st3=st2; st2=st1; st1=nCurBar+(nPeriod-1)/2;
        }
      if(High[nCurBar+(nPeriod-1)/2]==High[Highest(NULL,0,MODE_HIGH,nPeriod,nCurBar)])
        {
         r6=r5; r5=r4; r4=r3; r3=r2; r2=r1; r1=High[nCurBar+(nPeriod-1)/2];
         rt6=rt5; rt5=rt4; rt4=rt3; rt3=rt2; rt2=rt1; rt1=nCurBar+(nPeriod-1)/2;
        }
     }
//---- Move Object in Chart

   ObjectMove("Trend DN-0",1,Time[st1],s1);
   ObjectMove("Trend DN-0",0,Time[st2],s2);
//----
   ObjectMove("Trend UP-0",1,Time[rt1],r1);
   ObjectMove("Trend UP-0",0,Time[rt2],r2);

   return(0);
  }
//+------------------------------------------------------------------+