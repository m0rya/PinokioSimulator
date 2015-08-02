class CArduino {
  Arduino arduino;
  int neckAng;
  int baseAng;
  int angRoot;
  int angWaist;

  int Root;
  int Waist;
  int Base;
  int Neck;

  CArduino(Arduino _ard) {
    arduino = _ard;
    Root = 9;
    Waist = 11;
    Base = 12;
    Neck = 10;


    arduino.pinMode(Root, Arduino.SERVO);
    arduino.pinMode(Waist, Arduino.SERVO);
    arduino.pinMode(Base, Arduino.SERVO);
    arduino.pinMode(Neck, Arduino.SERVO);  //Base

    neckAng = 60;
  }


  //ARduino
  void interactiveWithSimulator(Pinokio pinokio) {

    if (frameCount > 10) {
      angRoot = int(map(pinokio.angleRoot, -90, 50, 30, 140));
      angWaist = int(map(pinokio.angleWaist, -40, -150, 0, 60));
    }
  }

  void randomNeckMove() {
    if (frameCount % 60 == 0) {
      neckAng = int(random(30, 160));
    }
  }

  void randomBaseMove() {
    if (frameCount % 120 == 0) {
      baseAng = int(random(30, 160));
    }
  }


  void allServoWrite() {
    arduino.servoWrite(Root, angRoot);
    arduino.servoWrite(Waist, angWaist);
    arduino.servoWrite(Neck, neckAng);
    arduino.servoWrite(Base, baseAng);
  }

  void initServo() {
    arduino.servoWrite(Root, 100);
    arduino.servoWrite(Waist, 30);
    arduino.servoWrite(Neck, 105);
    arduino.servoWrite(Base, 105);
  }



  void centerNeckBase() {
    arduino.servoWrite(Base, 105);
    arduino.servoWrite(Neck, 105);
  }

  void setNeckBase(int angN, int angB) {
    arduino.servoWrite(Base, angB);
    arduino.servoWrite(Neck, angN);
  }

  int turnTimes = 5;
  int neckTurnInterval;
  int baseTurnInterval;



  float preFaceX = 80;

  void turnTo() {

    float dis = abs(neckAng - baseAng);

    if (facePos.x > 110) {
      if (neckAng > baseAng) {
        if (frameCount % 3 == 0) {
          baseAng --;
          if (dis > 10) {
            neckAng ++;
          }
        } else {
          neckAng --;
        }
      }
    } else if (facePos.x < 50) {
      if (neckAng > baseAng) {
        if (frameCount % 3 == 0) {
          neckAng ++;
        } else {
          baseAng ++;
          if (dis > 10) {
            neckAng --;
          }
        }
      }
    }

    if (dis > 10 && frameCount % 3 == 0) {
      
      if (neckAng > baseAng) {
        neckAng --;
        baseAng ++;
      } else {
        neckAng ++;
        baseAng --;
      }
    }

    float disFaceX = facePos.x - preFaceX;
    if (disFaceX > 20) {
      if (neckAng > baseAng) {
        //baseAng -=2;
        neckAng ++;
      } else {
        baseAng ++;
        if (dis > 10) {
          neckAng --;
        }
      }
    } else if (disFaceX < -10) {
      if (neckAng > baseAng) {

        baseAng --;
        if (dis > 10) {
          neckAng ++;
        }
      } else {
        neckAng --;
      }
    }


    angWaist = int(map(angWaist, 0, 60, 0, 30));
    //preFaceX = facePos.x;
  }

  //boolean tracked = false;
  boolean getingClose = false;


  void integrate(OpenCV cv, Pinokio pinokio, Button[] button) {
    facePos = new PVector(80, 60);
    boolean tmp = faceDetect(cv);
    int staring = onceDetected(tmp);


    if (staring == 0 && !getingClose) {
      interactiveWithSimulator(pinokio);
      randomNeckMove();
      randomBaseMove();
    } else if (staring == 1 && !getingClose) {
      interactiveWithSimulator(pinokio);
      turnTo();
    } else if (staring == 2 || getingClose) {
      getingClose = ctrlPinokio(pinokio, button);
      interactiveWithSimulator(pinokio);
    }

    makeInterval(getingClose);


    allServoWrite();
  }

  int count = 48;
  int onceDetected(boolean tracked) {
    if (tracked && count == 48) {
      count = 0;
    } else if (count < 48) {
      count ++;
      if (count == 48) return 2;
    }

    if (count < 48) return 1;
    else           return 0;
  }



  PVector facePos = new PVector();

  boolean faceDetect(OpenCV cv) {

    Rectangle[] faces = cv.detect();
    noFill();
    stroke(255, 0, 0);
    strokeWeight(2);

    for (int i=0; i<faces.length; i++) {
      rect(faces[i].x, faces[i].y + height/2, faces[i].width, faces[i].height);
      facePos = new PVector(faces[i].x + faces[i].width/2, faces[i].y + faces[i].height/2);
    }

    if (faces.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  int memNum;

  int diCount = 48;
  boolean preGetingClose = false;
  void makeInterval(boolean gC) {
    if (preGetingClose = true && gC == false) {
      diCount = 0;
    }
    if (gC == false && diCount < 48) {
      interactiveWithSimulator(pinokio);
      randomNeckMove();
      randomBaseMove();
      diCount ++;
    }
    preGetingClose = gC;
  }

  boolean ctrlPinokio(Pinokio pinokio, Button[] button) {
    if (button[11].sw == true) {
      button[11].sw = false;
      memNum = int(random(10)) % 2;
    }

    boolean tmp = pinokio.moveWithTxtfileReturn(memNum);
    if (tmp == true) {
      button[11].sw = true;
      return false;
    }
    return true;
  }
}

