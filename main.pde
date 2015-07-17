import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import processing.serial.*;
import cc.arduino.*;




Pinokio pinokio;
int buttonNum = 12;
Button[] button = new Button[buttonNum];
vis_ana visualize;

int mmtxt=0;

float tmp_intvl = 10.0;

//tracker
Capture video;
OpenCV opencv;
Tracker tracker;

//Arduino
Arduino arduino;


boolean fd = false;

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
  button[11].setName("Bezier");


  //Tracker
  if (fd) {
    String[] cams = Capture.list();
    for (int i=0; i<cams.length; i++) {
      println(i + " : " + cams[i]);
    }
    //video = new Capture(this, 400, 300, "UCAM-C0220F", 30);
    video = new Capture(this, cams[18]);
    opencv = new OpenCV(this, 400, 300);
    opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
    video.start();
    tracker = new Tracker();
  }
  //Arduino 
  arduino = new Arduino(this, Arduino.list()[2], 57600);
  arduino.pinMode(9, Arduino.SERVO);
  arduino.pinMode(10, Arduino.SERVO);
  arduino.pinMode(11, Arduino.SERVO);
}


int preAng1=0;
int preAng2 = 0;
int neckAng=60;
void draw() {



  fill(0);
  strokeWeight(5);
  background(255);



  //ARduino
  int ang1=0;
  int ang2=0;

  if (frameCount > 10) {
    ang1 = int(map(pinokio.angleRoot, -90, 50, 30, 140));
    ang2 = int(map(pinokio.angleWaist, -40, -150, 0, 120));
    /*
    if (ang2 >= 60 && ang1 < 150 - ang2) {
     //background(200, 0, 0, 50);
     ang1 = preAng1;
     ang2 = preAng2;
     }
     */
    arduino.servoWrite(9, ang1);

    arduino.servoWrite(11, ang2);
    //    preAng1 = ang1;
    //    preAng2 = ang2;
    if (frameCount % 60 == 0) {
      neckAng = int(random(50, 140));
    }

    //println("nAng:" + neckAng);
    arduino.servoWrite(10, neckAng);
  }


  //PINOKIO
  pinokio.interactiveWithMouse();

  pinokio.drawPinokio();
  pinokio.memorizeMovement();



  //VISUALIZER

  visualize.show_input(mmtxt);
  //visualize.show_diff(mmtxt);
  //visualize.show_corl(mmtxt);


  //TRACKER
  if (fd) {
    opencv.loadImage(video);
    scale(0.5);
    image(video, 0, height/2+400); 
    // println(tracker.faceDetect(opencv));
    if (tracker.faceDetect(opencv)) {

      if (button[11].sw ==true) {
        button[11].sw = false;
      }

      pinokio.moveWithTxtfile(1);
    } else {
      if (button[11].sw == false) {
        button[11].sw = true;
      }

      pinokio.moveWithBezier();
    }
    scale(2);
  }




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
  text("ang1 : " + ang1, 250, 60);
  text("ang2 : " + ang2, 250, 75);

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
    //if(tracker.faceDetect(opencv)) pinokio.moveWithTxtfile(0);
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
  if (button[11].sw) {
    pinokio.moveWithBezier();
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

  if (key == 'd') {
    neckAng += 10;
  }
  if (key == 'f') {
    neckAng -=10;
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

void captureEvent(Capture c) {
  c.read();
}

