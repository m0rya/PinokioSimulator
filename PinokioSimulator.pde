
class Pinokio {

  ///body
  float angleRoot, angleWaist, angleNeck;
  PVector[] pivot = new PVector[4];

  int moveCount=0;

  //movement memorize
  boolean swt = false;
  String[] mov = new String[5000];
  int mem_cnt;
  int memorize_count=0;

  //movement input
  String[] inpt;
  int[][] inpt_result;
  int inpt_count=0;

  int inmv_count=0;

  //Perlin noise
  float xoff=0;


  //random walk
  boolean rndm_walk_init=true;
  float next_angleRoot = 0;
  float next_angleWaist = 0;
  float next_angleNeck = 0;

  //move many
  int rndm;
  boolean stup=true;
  float v1, v2, v3;


  //Bezier Movement
  Bz Bez;

  //constructor
  Pinokio() {
    pivot[0] = new PVector(width/2, height-50);
    PVector hm = new PVector(550,500);
    Bez = new Bz(5, 100,hm);
  }

  //move With Bezier
  PVector bezierMovement[] = new PVector[100];
  int bezierCount = 0;

  void setBezierMovement(){
    Bez.setPointRandom();
    bezierMovement = Bez.setBezierPoint();
  }

  void moveWithBezier(){
   if(bezierCount == 0) setBezierMovement(); 

   Bez.drawBz();
     angleRoot = map(bezierMovement[bezierCount].x, 0, width, -90, 90);
     angleWaist = map(bezierMovement[bezierCount].y, 0, height, 10, -150);
     bezierCount++;

     if(bezierCount == 100){
       bezierCount = 0;
     }

  }





  //interactiveWithMouse with mouse
  boolean boolInteractiveWithMouse = true;
  void setOnInteractiveWithMouse(){
    boolInteractiveWithMouse = true;
  };
  void setOffInteractiveWithMouse(){
    boolInteractiveWithMouse = false;
  };

  void interactiveWithMouse() { 
    if(boolInteractiveWithMouse){
      angleRoot = map(mouseX, 0, width, -90, 90);
      angleWaist = map(mouseY, 0, height, 10, -150);
      //angleNeck = an;
    } 
  }




  void updateAngle() {
    PVector tmp = new PVector(sin(radians(angleRoot))*100, -cos(radians(angleRoot))*100);
    pivot[1] = PVector.add(pivot[0], tmp);

    PVector tmp_2 = new PVector(sin(radians(angleWaist))*100, -cos(radians(angleWaist))*100);
    pivot[2] = PVector.add(pivot[1], tmp_2);

    PVector tmp_3 = new PVector(sin(radians(angleNeck))*30, -cos(radians(angleNeck))*30);
    pivot[3] = PVector.add(pivot[2], tmp_3);
  }


  void drawPinokio() {
    this.updateAngle();

    stroke(0);
    strokeWeight(4);
    //body
    line(pivot[0].x, pivot[0].y, pivot[1].x, pivot[1].y);
    line(pivot[1].x, pivot[1].y, pivot[2].x, pivot[2].y);
    line(pivot[2].x, pivot[2].y, pivot[3].x, pivot[3].y);

    //head
    pushMatrix();
    translate(pivot[3].x, pivot[3].y);
    rotate(radians(angleNeck));
    rect(-40, - 20, 50, 30);
    popMatrix();
  }



  //////
  /*
 t: start recording
   r: end   recording
   
   
   */

  void memorizeMovement() {

    if (!swt) {
      if (keyPressed && key == 't') {

        mem_cnt=0;
        for (int i=0; i<5000; i++) {
          mov[i] = null;
        }
        swt = true;
        println("memorize start");
        println("ill record mem_" + memorize_count + ".txt");
      }
    }

    if (swt) {
      mov[mem_cnt] = angleRoot + "/" + angleWaist + "/" + angleNeck;

      mem_cnt++;

      if (keyPressed && key == 'r') {
        String fname = "mem_"+ str(memorize_count) + ".txt";

        mov[mem_cnt] = str(100);
        saveStrings(fname, mov);
        swt=false;
        println("morize end");
        memorize_count++;
      }
    }
  }


  void loadTxtfile(String s) {
    inpt = loadStrings(s);

    int n=0;
    while (int (inpt[n]) != 100) {
      n++;
    }

    inpt_result = new int[n][3];

    while (true) {

      String[] inpt_angl = split(inpt[inpt_count], '/');

      //println(inpt_angl[inpt_count]);
      inpt_result[inpt_count][0] =  int(inpt_angl[0]);
      inpt_result[inpt_count][1] = int(inpt_angl[1]);
      inpt_result[inpt_count][2] = int(inpt_angl[2]);

      inpt_count++;

      if (int(inpt[inpt_count]) == 100) {
        println(inpt_count);
        inpt_count=0;
        break;
      }
    }

    println("input end" + s);
  }


  void loadTxtfile(int num) {
    String s = "mem_" + num + ".txt";
    inpt = loadStrings(s);

    int n=0;
    while (int (inpt[n]) != 100) {
      n++;
    }

    inpt_result = new int[n][3];

    while (true) {

      String[] inpt_angl = split(inpt[inpt_count], '/');

      //println(inpt_angl[inpt_count]);
      inpt_result[inpt_count][0] =  int(inpt_angl[0]);
      inpt_result[inpt_count][1] = int(inpt_angl[1]);
      inpt_result[inpt_count][2] = int(inpt_angl[2]);

      inpt_count++;

      if (int(inpt[inpt_count]) == 100) {
        println(inpt_count);
        inpt_count=0;
        break;
      }
    }

    println("input end " + s);
  }

  boolean mfi_b;

  void moveWithTxtfile(int num) {
    if (!mfi_b) {
      loadTxtfile(num);
      mfi_b = true;
    }

    if (inmv_count < inpt_result.length) {
      angleRoot = inpt_result[inmv_count][0];
      angleWaist = inpt_result[inmv_count][1];
      angleNeck = inpt_result[inmv_count][2];

      inmv_count++;
    } else {
      inmv_count =0;
    }
  }

  void moveWithTxtfile() {

    if (inmv_count < inpt_result.length) {
      angleRoot = inpt_result[inmv_count][0];
      angleWaist = inpt_result[inmv_count][1];
      angleNeck = inpt_result[inmv_count][2];

      inmv_count++;
    } else {
      inmv_count =0;
    }
  }





  int moveWithTxtfileRandom() {

    if (inmv_count == 0 && stup) {
      rndm = int(random(5));
      loadTxtfile(rndm);

      v1 = (inpt_result[rndm][0] - angleRoot)/50;
      v2 = (inpt_result[rndm][1] - angleWaist)/50;
      v3 = (inpt_result[rndm][2] - angleNeck)/50;

      stup = false;
    }

    if (!stup) {
      if (abs(angleRoot-inpt_result[rndm][0]) > 2) {
        angleRoot += v1;
        angleWaist += v2;
        angleNeck += v3;
      } else {
        inmv_count ++;
        stup = true;
      }
    } else {
      moveWithTxtfile();
    }

    return rndm;
  }




  //not regulated
  void random_walk(float interval) {

    if (rndm_walk_init) {
      angleRoot = 10;
      angleWaist = -110;
      angleNeck = 0;
      rndm_walk_init = false;
    } 

    //set next point
    if (!rndm_walk_init && frameCount%interval == 0) {

      next_angleRoot = random(-5, 5)/interval;
      next_angleWaist = random(-5, 5)/interval;
      next_angleNeck = random(-1, 1)/interval;

      if (angleRoot <-80) angleRoot += 5;
      if (angleRoot > 80) angleRoot -=5;
      if (angleWaist < -130) angleWaist += 5;
      if (angleWaist > 0) angleWaist -= 5;

      if (angleNeck>20 || angleNeck<-20) angleNeck = 0;
    }

    angleRoot += next_angleRoot;
    angleWaist += next_angleWaist;
    angleNeck += next_angleNeck;
  }

  //regulated
  void random_walk_2(float interval) {

    if (rndm_walk_init) {
      angleRoot = 10;
      angleWaist = -110;
      angleNeck = 0;
      rndm_walk_init = false;
    } 

    //set next point
    if (!rndm_walk_init && frameCount%interval == 0) {

      next_angleRoot = random(-5, 5)/interval;
      next_angleWaist = random(-5, 5)/interval;
      next_angleNeck = random(-1, 1)/interval;
      //1_-90, 2_20
      if (angleRoot > 50) next_angleRoot = random(-7, -2)/interval;
      if (angleRoot < -10) next_angleRoot = random(2, 7)/interval;
      if (angleWaist > -60) next_angleWaist = random(-7, -2)/interval;
      if (angleWaist < -110) next_angleWaist = random(2, 7)/interval;



      if (angleRoot <-80) angleRoot += 5;
      if (angleRoot > 80) angleRoot -=5;
      if (angleWaist < -130) angleWaist += 5;
      if (angleWaist > 0) angleWaist -= 5;

      if (angleNeck>20 || angleNeck<-20) angleNeck = 0;
    }

    angleRoot += next_angleRoot;
    angleWaist += next_angleWaist;
    angleNeck += next_angleNeck;
  }


  void perlinNoise_walk(float interval) {

    if (rndm_walk_init) {
      angleRoot = 10;
      angleWaist = -110;
      angleNeck = 0;
      rndm_walk_init = false;
    } 

    //set next point
    if (!rndm_walk_init && frameCount%interval == 0) {

      next_angleRoot = (map(noise(xoff), 0, 1, -70, 70) - angleRoot )/interval;
      next_angleWaist = (map(noise(xoff), 0, 1, 0, -150) - angleWaist)/interval;
      next_angleNeck = ( map(noise(xoff), 0, 1, -30, 30) - angleNeck)/interval;



      if (angleRoot <-80) angleRoot += 5;
      if (angleRoot > 80) angleRoot -=5;
      if (angleWaist < -130) angleWaist += 5;
      if (angleWaist > 0) angleWaist -= 5;

      if (angleNeck>20 || angleNeck<-20) angleNeck = 0;
      xoff +=0.05;
    }

    angleRoot += next_angleRoot;
    angleWaist += next_angleWaist;
    angleNeck += next_angleNeck;
  }


  void perlinNoise_walk2(float interval) {

    if (rndm_walk_init) {
      angleRoot = 10;
      angleWaist = -110;
      angleNeck = 0;
      rndm_walk_init = false;
    } 

    //set next point
    if (!rndm_walk_init && frameCount%interval == 0) {

      next_angleRoot = map(noise(xoff), 0, 1, -5, 5)/interval;
      next_angleWaist = map(noise(xoff), 0, 1, -5, 5)/interval;
      next_angleNeck = map(noise(xoff), 0, 1, -1, 1)/interval;


      //1_-90, 2_20
      if (angleRoot > 50) next_angleRoot = random(-7, -2)/interval;
      if (angleRoot < 10) next_angleRoot = random(2, 7)/interval;
      if (angleWaist > -60) next_angleWaist = random(-7, -2)/interval;
      if (angleWaist < -110) next_angleWaist = random(2, 7)/interval;


      if (angleRoot <-80) angleRoot += 5;
      if (angleRoot > 80) angleRoot -=5;
      if (angleWaist < -130) angleWaist += 5;
      if (angleWaist > 0) angleWaist -= 5;

      if (angleNeck>20 || angleNeck<-20) angleNeck = 0;
      xoff +=0.05;
    }

    angleRoot += next_angleRoot;
    angleWaist += next_angleWaist;
    angleNeck += next_angleNeck;
  }




  void visualizeTxtfile(String s) {
    loadTxtfile(s);

    for (int i=0; i<inpt_result.length; i++) {

      stroke(255, 0, 0);
      point(i, inpt_result[i][0]+150);
      stroke(0, 255, 0);
      point(i, inpt_result[i][1]+350);
    }
  }


  ///keybord and mouse
  void keyPressed() {
    if (key == 'a') {
      angleNeck -= 10;
    }
    if (key == 's') {
      angleNeck += 10;
    }
  }



  ///will

  void setCloseToFace() {
  }

  void moveHappily() {
  }

  void lookAround() {
  }
};
