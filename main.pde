import gab.opencv.*;
import processing.video.*;
import java.awt.*;


Pinokio pinokio;
int buttonNum = 11;
Button[] button = new Button[buttonNum];
vis_ana visualize;

int mmtxt=0;

float tmp_intvl = 10.0;

//tracker
Capture video;
OpenCV opencv;
Tracker tracker;


void setup() {
  size(700, 700);
  pinokio = new Pinokio();
  visualize = new vis_ana();

  //Gui Button
  for (int i=0; i<buttonNum; i++) {
    button[i] = new Button(width-130, 10+i*30, 120, 20);
  }
  
  button[0].setName("moveMany");
  button[1].setName("randomMove");
  button[2].setName("randomMove2");
  button[3].setName("perlinMove");
  button[4].setName("perlinMove2");
  button[5].setName("mem_0.txt");
  button[6].setName("mem_1.txt");
  button[7].setName("mem_2.txt");
  button[8].setName("mem_3.txt");
  button[9].setName("mem_4.txt");
  button[10].setName("RESET");


  //Tracker
  
  video = new Capture(this, 160, 120);
  opencv = new OpenCV(this, 160, 120);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  video.start();
  tracker = new Tracker();

}



void draw() {
  fill(0);
  strokeWeight(5);
  background(255);

  //PINOKIO
  pinokio.interactiveWithMouse();

  pinokio.drawPinokio();
  pinokio.memorizeMovement();


  //VISUALIZER
  
  visualize.show_input(mmtxt);
  //visualize.show_diff(mmtxt);
  //visualize.show_corl(mmtxt);
  
  
  //TRACKER
  opencv.loadImage(video);
  image(video,0,height/2); 
  //println(tracker.faceDetect(opencv));
  
 
  
  
  ////TEXT MENU 
  fill(0);
  text("t : start record", 10, 10);
  text("r : stop recort", 10, 25);
  text("\"1\", \"2\", \"3\" : load txt file ,and move", 10, 40);
  text("x : stop moving", 10, 55);

  text("angleRoot : " + pinokio.angleRoot, 250, 10);
  text("angleWaist : " + pinokio.angleWaist, 250, 20);
  text("angleNeck : " + pinokio.angleNeck, 250, 30);
  text("interval('v','b') : " + tmp_intvl, 250, 45);


  //GUI BUTTON
  for (int i=0; i<buttonNum; i++) {
    button[i].showButton();
  }


  //func
  if (button[0].sw) {
    mmtxt = pinokio.moveWithTxtfileRandom();
    
  }
  if (button[1].sw) {
    pinokio.random_walk(tmp_intvl);
  }
  if (button[2].sw) {
    pinokio.random_walk_2(tmp_intvl);
  }

  if (button[3].sw) {
    pinokio.perlinNoise_walk(tmp_intvl);
  }

  if (button[4].sw) {
    pinokio.perlinNoise_walk2(tmp_intvl);
    if(tracker.faceDetect(opencv)) pinokio.moveWithTxtfile(0);
    
  }


  for (int i=0; i<5; i++) {
    if (button[i+5].sw) {
      pinokio.moveWithTxtfile(i);
      mmtxt = i;
      
    }
  }

  if (button[10].sw) {
    for (int i=0; i<buttonNum; i++) {
      button[i].on_off(false);
    }
  }
}

void keyPressed() {
  pinokio.keyPressed();

  if (key == 'q') {
    pinokio.setOffInteractiveWithMouse();
  }
  if (key == 'x') {
    pinokio.setOnInteractiveWithMouse();
  }


  if (key == 'v') {
    tmp_intvl += 2;
  }
  if (key == 'b') {
    tmp_intvl -=2;
  }
}


void mouseReleased() {
  //pinokio.mouseReleased();
  for (int i=0; i<buttonNum; i++) {
    button[i].on_off(false);
    pinokio.mfi_b = false;
  }

  for (int i=0; i<buttonNum; i++) {
    button[i].mouseReleased();
  }
  pinokio.setOffInteractiveWithMouse();

}

void captureEvent(Capture c){
  c.read();
}
