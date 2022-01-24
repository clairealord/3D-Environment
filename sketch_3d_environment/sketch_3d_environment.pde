//Claire Lord
//3D Environment

import java.awt.Robot;

Robot bob;

//color pallette
color black     = #000000; //baby shrek
color white     = #FFFFFF; //empty space
color lightBlue = #7092BE; //monster shrek

//map variables
int gridSize;
PImage map;

//textures
PImage shrekMonster;
PImage babyShrek;
PImage teethShrek;

boolean wkey, akey, skey, dkey;
boolean skipFrame;
float eyeX, eyeY, eyeZ, focusX, focusY, focusZ, upX, upY, upZ;
float leftRightHeadAngle, upDownHeadAngle;

float rotx, roty;

void setup() {
  
  shrekMonster = loadImage("shrekMonster.jpg");
  babyShrek = loadImage("babyShrek.jpg");
  teethShrek = loadImage("teethShrek.jpg");

  size(displayWidth, displayHeight, P3D);
  textureMode(NORMAL);
  wkey = akey = skey = dkey = false;

  eyeX = width/2;
  eyeY = 8*height/10;
  eyeZ = 0;

  focusX = width/2;
  focusY = height/2;
  focusZ = 10;

  upX = 0;
  upY = 1;
  upZ = 0;

  leftRightHeadAngle = 0;
  noCursor();

  try {
    bob = new Robot();
  }
  catch(Exception e) {
    e.printStackTrace();
  }

  map = loadImage("map3d.png");
  gridSize = 100;

  skipFrame = false;
}

void draw() {
  background(0);
  
  pointLight(255, 255, 255, eyeX, eyeY, eyeZ);
  //lights();
  
  camera(eyeX, eyeY, eyeZ, focusX, focusY, focusZ, upX, upY, upZ);
  drawFloor(-2000, 2000, height, gridSize); //floor
  drawFloor(-2000, 2000, height-gridSize*4, gridSize); //ceiling
  drawFocalPoint();
  controlCamera();
  drawMap();
}

void drawMap() {

  for (int x = 0; x < map.width; x++) {
    for (int y = 0; y < map.height; y++) {
      color c = map.get(x, y);
      if (c == lightBlue) {
        texturedCube(x*gridSize-2000, height-gridSize, y*gridSize-2000, shrekMonster, gridSize);
        texturedCube(x*gridSize-2000, height-gridSize*2, y*gridSize-2000, shrekMonster, gridSize);
        texturedCube(x*gridSize-2000, height-gridSize*3, y*gridSize-2000, shrekMonster, gridSize);
      }
      if (c == black) {
        texturedCube(x*gridSize-2000, height-gridSize, y*gridSize-2000, babyShrek, gridSize);
        texturedCube(x*gridSize-2000, height-gridSize*2, y*gridSize-2000, babyShrek, gridSize);
        texturedCube(x*gridSize-2000, height-gridSize*3, y*gridSize-2000, babyShrek, gridSize);
      }
    }
  }
}

void drawFocalPoint() {
  pushMatrix();
  translate(focusX, focusY, focusZ);
  sphere(5);
  popMatrix();
}

void drawFloor(int start, int end, int level, int gap) {
  stroke(255);
  int x = start;
  int z = start;
  while (z < end) {
    texturedCube(x, level, z, teethShrek, gap);
    x = x + gap;
    if (x >= end) {
      x = start;
      z = z + gap;
    }
  }
}

void controlCamera() {
  if (wkey) {
    eyeX = eyeX + cos(leftRightHeadAngle)*10;
    eyeZ = eyeZ + sin(leftRightHeadAngle)*10;
  }
  if (skey) {
    eyeX = eyeX - cos(leftRightHeadAngle)*10;
    eyeZ = eyeZ - sin(leftRightHeadAngle)*10;
  }
  if (akey) {
    eyeX = eyeX - cos(leftRightHeadAngle + PI/2)*10;
    eyeZ = eyeZ - sin(leftRightHeadAngle + PI/2)*10;
  }
  if (dkey) {
    eyeX = eyeX - cos(leftRightHeadAngle - PI/2)*10;
    eyeZ = eyeZ - sin(leftRightHeadAngle - PI/2)*10;
  }

  leftRightHeadAngle = leftRightHeadAngle + (mouseX - pmouseX)*0.01;
  upDownHeadAngle = upDownHeadAngle + (mouseY - pmouseY)*0.01;
  if (upDownHeadAngle > PI/2.5) upDownHeadAngle = PI/2.5;
  if (upDownHeadAngle < -PI/2.5) upDownHeadAngle = -PI/2.5;

  focusX = eyeX + cos(leftRightHeadAngle) * 300;
  focusZ = eyeZ + sin(leftRightHeadAngle) * 300;
  focusY = eyeY + tan(upDownHeadAngle)*300;

  if (mouseX > width-2) bob.mouseMove (3, mouseY);
  else if (mouseX < 2) bob.mouseMove(width-3, mouseY);
  
  if (skipFrame == false) {
    leftRightHeadAngle = leftRightHeadAngle + (mouseX - pmouseX)*0.01;
    upDownHeadAngle = upDownHeadAngle + (mouseY - pmouseY)*0.01;
  }
  
  if (mouseX < 2) {
    bob.mouseMove(width-3, mouseY);
    skipFrame = true;
  }else if (mouseX > width-2) {
    bob.mouseMove(3, mouseY);
    skipFrame =  true;
  }else {
    skipFrame = false;
  }
  
}

void keyPressed() {
  if (key == 'W' || key == 'w') wkey = true;
  if (key == 'A' || key == 'a') akey = true;
  if (key == 'S' || key == 's') skey = true;
  if (key == 'D' || key == 'd') dkey = true;
}

void keyReleased() {
  if (key == 'W' || key == 'w') wkey = false;
  if (key == 'A' || key == 'a') akey = false;
  if (key == 'S' || key == 's') skey = false;
  if (key == 'D' || key == 'd') dkey = false;
}
