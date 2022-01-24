import java.awt.Robot;

Robot rbt;
float rotx, roty;
//colours
color black=#000000; //diamond
color white = #FFFFFF;
color blue = #7092BE; //dirt
PImage diamond;
PImage dirt;
PImage grasstop;
PImage grassbottom;
PImage grassside;
//map
int gridsize;
PImage map;

boolean wkey, akey, skey, dkey, space, shift;
float eyex, eyey, eyez, focusx, focusy, focusz, tiltx, tilty, tiltz;
float leftrightheadangle, updownheadangle;


void setup() {  
  size(displayWidth, displayHeight, P3D);
  textureMode(NORMAL);
  wkey=akey=skey=dkey=false;
  eyex=width/2;
  eyey=8*height/10;
  eyez=0;
  focusx=width/2;
  focusy=height/2;
  focusz=10;
  tiltx=0;
  tilty=1;
  tiltz=0;
  leftrightheadangle=radians(270);
  noCursor();
  try {
    rbt=new Robot();
  }
  catch(Exception e) {
    e.printStackTrace();
  }

  //map
  map=loadImage("map.png");
  gridsize =100;
  diamond=loadImage("diamond.jpg");
  dirt=loadImage("dirt.jpg");
  grasstop=loadImage("grasstop.jpg");
  grassbottom=loadImage("grassbottom.jpg");
  grassside=loadImage("grassside.jpg");
}

void draw() {
  background(0);
  pointLight(255, 255, 255, eyex, eyey, eyez);
  camera(eyex, eyey, eyez, focusx, focusy, focusz, tiltx, tilty, tiltz);
  drawfloor(-2000, 2000, height, 100);
  drawfloor(-2000, 2000, height-gridsize*4, 100);
  drawfocalpoint();
  controlcamera();
  drawmap();
}

void drawfocalpoint() {
  pushMatrix();
  translate(focusx, focusy, focusz);
  sphere(5);
  popMatrix();
}

void drawfloor(int start, int end, int level, int gap) {
  stroke(255);
  strokeWeight(1);
  int x = start;
  int z= start;
  while (z<end) {
    texturedcube(x, level, z, grasstop, gap);
    x=x+gap;
    if (x>= end) {
      x=start;
      z=z+gap;
    }
  }
}


void controlcamera() {
  if (wkey) {
    eyex=eyex+ cos(leftrightheadangle)*10;
    eyez=eyez+ sin(leftrightheadangle)*10;
  }
  if (skey) {
    eyez=eyez-sin(leftrightheadangle)*10;
    eyex=eyex- cos(leftrightheadangle)*10;
  }
  if (akey) {
    eyez=eyez-sin(leftrightheadangle+PI/2)*10;
    eyex=eyex- cos(leftrightheadangle+PI/2)*10;
  }
  if (dkey) {
    eyez=eyez-sin(leftrightheadangle-PI/2)*10;
    eyex=eyex- cos(leftrightheadangle-PI/2)*10;
  }
  if (space) {
    eyey=eyey-10;
  }
  if (shift) {
    eyey=eyey+10;
  }

  leftrightheadangle=leftrightheadangle+(mouseX-pmouseX)*0.01;
  updownheadangle=updownheadangle+ (mouseY-pmouseY)*0.01;
  if (updownheadangle> PI/2.5)updownheadangle=PI/2.5;
  if (updownheadangle< -PI/2.5)updownheadangle=-PI/2.5;

  focusx=eyex + cos(leftrightheadangle)*300;
  focusz=eyez+ sin(leftrightheadangle)*300;
  focusy=eyey+tan(updownheadangle)*300;

  if (mouseX>width-2)rbt.mouseMove(2, mouseY);
  else if (mouseX<2)rbt.mouseMove(width-2, mouseY);
}

void drawmap() {
  for (int x = 0; x<map.width; x++) {
    for (int y =0; y< map.height; y++) {
      color c = map.get(x, y);
      if (c == blue) {
        texturedcube(x*gridsize-2000, height-gridsize, y*gridsize-2000, dirt, gridsize);
        texturedcube(x*gridsize-2000, height-gridsize*2, y*gridsize-2000, dirt, gridsize);
        texturedcube(x*gridsize-2000, height-gridsize*3, y*gridsize-2000, dirt, gridsize);
      }
      if (c==black) {
        texturedcube(x*gridsize-2000, height-gridsize, y*gridsize-2000, diamond, gridsize);
        texturedcube(x*gridsize-2000, height-gridsize*2, y*gridsize-2000, diamond, gridsize);
        texturedcube(x*gridsize-2000, height-gridsize*3, y*gridsize-2000, diamond, gridsize);
      }
    }
  }
}

void keyPressed() { 
  if (key=='w' ||key=='W') wkey=true;
  if (key=='s'||key=='S')skey=true;
  if (key=='a' ||key=='A')akey=true;
  if (key=='d'||key=='D')dkey=true;
  if (key==' ')space=true;
  if (key == CODED) {
    if (keyCode == SHIFT) shift=true;
  }
}
void keyReleased() {
  if (key=='w' ||key=='W')wkey=false;
  if (key=='s'||key=='S')skey=false;
  if (key=='a' ||key=='A')akey=false;
  if (key=='d'||key=='D')dkey=false;
  if (key==' ')space=false;
  if (key == CODED) {
    if (keyCode == SHIFT) shift=false;
  }
}
