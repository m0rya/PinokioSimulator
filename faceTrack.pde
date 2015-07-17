
class Tracker {

  boolean faceDetect(OpenCV cv) {

    Rectangle[] faces = cv.detect();
    noFill();
    stroke(255, 0, 0);
    strokeWeight(2);

    for (int i=0; i<faces.length; i++) {
      rect(faces[i].x, faces[i].y + height/2 + 400, faces[i].width, faces[i].height);
    }
    
    if (faces.length > 0) return true;
    else                  return false;
    
  }
}
