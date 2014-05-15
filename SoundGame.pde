/**
  * This sketch demonstrates how to monitor the currently active audio input 
  * of the computer using an <code>AudioInput</code>. What you will actually 
  * be monitoring depends on the current settings of the machine the sketch is running on. 
  * Typically, you will be monitoring the built-in microphone, but if running on a desktop
  * its feasible that the user may have the actual audio output of the computer 
  * as the active audio input, or something else entirely.
  * <p>
  * When you run your sketch as an applet you will need to sign it in order to get an input. 
  */

import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioInput in;
FFT fft;
float highest=0;

void setup()
{
  size(1024, 400, P2D);

  minim = new Minim(this);

  in = minim.getLineIn(Minim.MONO, width, 44100, 16);
  fft = new FFT(in.bufferSize(), in.sampleRate());

 
}

void draw()
{
  background(0);
  stroke(128);
  strokeWeight(2);
  
  line(0,200,width,201); //x-axis
  line(1,0,2,height); //y-axis
  rectangle(((2*width)/3),20,((2*width)/3)+200,100); //info box
  
  int counter = 0;
  for(int i=180;i>=20;i-=20)
  {
    counter++;
    line(0,i,10,i);
    text((300/10)*counter,15,i+5);
  }

  //negative y-axis next part
  counter = 0;
  for(int i=220;i<=380;i+=20)
  {
    counter++;
    line(0,i,10,i);
    text("-"+(300/10)*counter,15,i+5);
  }
  
  stroke(255);
  
   for (int i = 0; i < in.bufferSize() - 1; i++)
   {
     smooth();
     
     if(in.left.get(i)>highest)
      highest = in.left.get(i);
      
     line(i, 200 + in.left.get(i)*300, i+1, 200 + in.left.get(i+1)*300);
   }
   stroke(128);
   text("Highest Amplitude per frame : "+(int)(highest*300),2*width/3+10,35); //text message
   stroke(255);
   highest = 0.0;

/////// FFT ///////
 
  fft.forward(in.mix);
 
  stroke(255, 0, 0, 128);
  for(int i = 0; i < fft.specSize(); i++)
  {
    line(i*5, height, i*5, height - fft.getBand(i)*16);
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

