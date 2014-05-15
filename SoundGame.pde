
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

Minim minim;
AudioInput in;
FFT fft;
HighPassSP highpass;
float highest=0;

float previousHighest = 0;

void setup()
{

  size(1024, 400, P2D);   // P2D, P3D, OPENGL

  minim = new Minim(this);

  in = minim.getLineIn(Minim.MONO, width, 44100, 16);
  
  fft = new FFT(in.bufferSize(), in.sampleRate());
  fft.linAverages(128);
  rectMode(CORNERS);

  highpass = new HighPassSP(120, in.sampleRate());
  in.addEffect(highpass);
 
}

void draw()
{
  background(0);
  stroke(128,128,128);
  strokeWeight(2);
  fill(255,255,255,255);
  
  line(0,200,width,201); //x-axis
  line(1,0,2,height); //y-axis
  rectangle(((2*width)/3),20,((2*width)/3)+200,100); //info box
  
  ///////////////////////////////////////////////////////////////
  //       AXIS LINES AND GRID VALUE FOR POSITIVE Y-AXIS       //
  ///////////////////////////////////////////////////////////////
  
  int counter = 0;
  for(int i=180;i>=20;i-=20)
  {
    counter++;
    line(0,i,10,i);
    text((300/10)*counter,15,i+5);
  }

  ///////////////////////////////////////////////////////////////
  //       AXIS LINES AND GRID VALUE FOR NEGATIVE Y-AXIS       //
  ///////////////////////////////////////////////////////////////
  counter = 0;
  for(int i=220;i<=380;i+=20)
  {
    counter++;
    line(0,i,10,i);
    text("-"+(300/10)*counter,15,i+5);
  }
  
  stroke(255,255,255); //white stroke
  
  ///////////////////////////////////////////////////////////////
  //       WAVEFORM OF ANALOGUE VALUE FROM MICROPHONE          //
  ///////////////////////////////////////////////////////////////
   for (int i = 0; i < in.bufferSize() - 1; i++)
   {
     float micValue = in.left.get(i);
     float nextMicValue = in.left.get(i+1);
     
     smooth();
     
     if(micValue>highest || nextMicValue>highest) //find the highest amplitude in a frame and store it
      {  
        highest = (micValue>nextMicValue)?micValue:nextMicValue;
        
        if(previousHighest<highest)
         {
           previousHighest=highest+0.003333;
         }
        
      }
      
     line(i, 200 + micValue*300, i+1, 200 + nextMicValue*300);
   }
   
   stroke(128,128,128);                                                       //grey stroke
   text("Highest Amplitude per frame : "+(int)(highest*300),2*width/3+10,35); //display amplitude value in a box
   text("Push Amplitude: "+(int)(previousHighest*300),2*width/3+10,60);       //display amplitude value in a box
   int barLevel = 200-(int)(200*previousHighest);
   
   if(barLevel<=100)
     stroke(255,0,0);
   else
    stroke(0,255,0);
    
   line(0,barLevel,width,barLevel);
    
   highest = 0.0;
   
   
   /////// FFT ///////
 
  fft.forward(in.mix);
  stroke(255, 255, 0, 128);
  fill(255,255,0,255);
  int w = 5;
  int maxFFT = 0;
  
  for(int i = 0; i < fft.specSize(); i++)
  {
    rect(50+i*w, height, 51+i*w + w, height - fft.getBand(i)*16);
    if((height-fft.getBand(i)*16)>maxFFT)
     {
      // maxFFT = 
     }
     //line(

  }
  
}

void stop()
{
  // always close Minim audio classes when you are done with them
  in.close();
  minim.stop();

  super.stop();
}

void rectangle(int x1,int y1,int x2,int y2)
{
  line(x1,y1,x2,y1);
  line(x1,y2,x2,y2);
  line(x1,y1,x1,y2);
  line(x2,y1,x2,y2);
}

void mousePressed()
{
  //if(mouseX>=width-100 && mouseY>=height-100)
   {
     previousHighest = 0.0;
   }
}


