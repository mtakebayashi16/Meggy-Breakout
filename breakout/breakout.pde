/*
ball directions:
0 = right
45 = diagonally right/up
90 = up
135 = diagonally left/up
180 = left
225 = diagonally left/down
270 = down
315 = diagonally right/down
*/

#include <MeggyJrSimple.h>     //Required code line 1 of 2

void setup(){
  MeggyJrSimpleSetup();        //Required code line 2 of 2
}

int marker = 7;            //marks point in the array to indicate how many bricks are being shown
int dotX = 0;
int dotY = 4;
int directions = 315;      //the ball starts by going diagonally down/right
int counter = 0;        //counts times through the loop
int life = 8;        //the value is for the Aux LEDs, instead of the actual number of lives, the game starts with three lives
boolean gameOver = false;
int level = 1;
int bricksLeft = 16;

struct Platform{        
  int x;
  int y;
};

Platform p1 = {0,0};      //platform coordinates, creates the platform array
Platform p2 = {1,0};
Platform p3 = {2,0};

Platform platformArray[3] = {p1, p2, p3};

struct Brick{         
  int x;
  int y;
  int color;
};

Brick s1 = {0,7,1};          //coordinates for each brick, creates the brick array (only has coordinates for every other brick)
Brick s2 = {2,7,4};
Brick s3 = {4,7,6};
Brick s4 = {6,7,5};
Brick s5 = {0,6,5};
Brick s6 = {2,6,6};
Brick s7 = {4,6,4};
Brick s8 = {6,6,1};
Brick s9 = {0,5,1};
Brick s10 = {2,5,4};
Brick s11 = {4,5,6};
Brick s12 = {6,5,5};

Brick brickArray [12] =  {s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12};

void loop(){
  SetAuxLEDs(life-1);        //displays the lives left on the aux LEDs
  counter ++;
  if (counter > 1000)
    counter = 1;
  
  drawBricks();
  drawPlatform();
  movePlatform();
  drawDot();
  checkBoundaries();
  
  if (counter % 450 == 0)
    checkDirections();
  
 // collisionDetection();
  
  DisplaySlate();
  ClearSlate();
}                          //END OF LOOP

void drawBricks(){
  for (int i = 0; i <= marker; i++){
    DrawPx(brickArray[i].x, brickArray[i].y, brickArray[i].color);
    DrawPx(brickArray[i].x+1,brickArray[i].y, brickArray[i].color); 
  }
}                //end drawBricks

void drawPlatform(){                //draws the platform, it is three dots wide
  for (int i = 0; i < 3; i++){
   DrawPx(platformArray[i].x, platformArray[i].y, Yellow); 
  }
}                                    //end drawPlatform

void movePlatform(){
  CheckButtonsDown();              //only moves the platform when counter%300=0, I found it was smoother than having CheckButtonsPress,
  for (int i = 0; i < 3; i++){
    if (counter % 250 == 0){        // so now the player can hold down the directions instead of having to press every time
      if (Button_Right && platformArray[2].x < 7)
         platformArray[i].x ++;          //moves platform right when Right button is pressed
       if (Button_Left && platformArray[0].x > 0)
         platformArray[i].x --;             //moves platform left when Left button is pressed 
    }
  }
}                        //end movePlatform


void checkDirections(){        //keeps the ball moving in a certain direction
  if (directions == 0)          
    dotX ++;
  if (directions == 45){         
    dotX ++;
    dotY ++;
  }
  if (directions == 90)
    dotY ++;
  if (directions == 135){
    dotX --;
    dotY ++;
  }
  if (directions == 180)
    dotX --;
  if (directions == 225){
    dotX --;
    dotY --;
  }
  if (directions == 270)
    dotY --;
  if (directions == 315){
    dotX ++;
    dotY --;
  }
    
}            //end checkDirections

void drawDot(){              //draws the ball
 DrawPx(dotX, dotY, Blue); 
}                            //end drawDot

void checkBoundaries(){          //keeps ball in ball boundaries
  if (dotX == 0 && dotY == 0){   //if ball is in bottom left corner   
    int j = random(1,3);        //random sequence to determine which way the ball bounces
    if (j == 1)
      directions = 45;       //if ball hits a corner, make it go oout diagonally
    if (j == 2)
      directions = 90;
    dotX = 0;
    dotY = 0;
  }
  if (dotX == 0 && dotY ==7){     //if ball is in the top left corner
    int j = random(1,3);        //random sequence to determine which way the ball bounces
    if (j == 1)
      directions = 315;       //if ball hits a corner, make it go oout diagonally
    if (j == 2)
      directions = 270;
    dotX = 0;
    dotY = 7;
  }
  if (dotX == 7 && dotY == 0){    //if ball is in the bottom right corner
    int j = random(1,3);        //random sequence to determine which way the ball bounces
    if (j == 1)
      directions = 90;       //if ball hits a corner, make it go oout diagonally
    if (j == 2)
      directions = 135;
    dotX = 7;
    dotY = 0;
  }
  if (dotX == 7 && dotY == 7){    //if ball is in the top right corner
    int j = random(1,3);        //random sequence to determine which way the ball bounces
    if (j == 1)
      directions = 270;       //if ball hits a corner, make it go oout diagonally
    if (j == 2)
      directions = 225;
    dotX = 7;
    dotY = 7;
  }                    //end checking corners, the rest of the method is for checking the side of the screen
    
  if (dotX > 7){              //for when the ball hits the right side
    dotX = 7;
    if (directions == 0)
      directions = 225;    //if the ball is going directly right, it will go left/down
    if (directions == 45)
      directions = 135;     //if the ball is going right/up, it will go left/up
    if (directions == 315)
      directions = 225;     //if the ball is going right/down, it will go left/down
  }
  if (dotX <  0){             //for when the ball hits the left side
    dotX = 0;
    if (directions == 225)
      directions = 315;    //if the ball is going left/down, it will go right/down
    if (directions == 135)
      directions = 45;    //if the ball is going left/up, it will go right/up
    if (directions == 180)
      directions = 315;    //if the ball is going left, it will go right/down
  }
  if (dotY > 7){            //for when the ball hits the top of the screen
    dotY = 7;
    if (directions == 45)
      directions = 315;    //if the ball is going right/up, it will go right/down
    if (directions == 90)
      directions = 315;       //if the ball is going straight up, it will go right/down
    if (directions == 135)
      directions = 225;
  }
  if (dotY < 0){          //for when the ball hits the bottom of the screen
    dotY = 0;
    if (directions == 225)
      directions = 135;        //if the ball is going left/down, it will go left/up
    if (directions == 270)
      directions = 45;          //if the ball is going straight down, it will go right/up
    if (directions == 315)
      directions = 45;        //if the ball is going right/down, it will go left/up
   }
     
}         //end boundaries check

void collisionDetection(){
 for(int i = 0; i < marker; i++){
  if (ReadPx(brickArray[i].x, brickArray[i].y) == !Dark){
    DrawPx(brickArray[i].x, brickArray[i].y,0);
    DrawPx(brickArray[i].x+1, brickArray[i].y,0);
    dotY --;
    if (directions == 45)
      directions = 315;    //if the ball is going right/up, it will go right/down
    if (directions == 90)
      directions = 315;       //if the ball is going straight up, it will go right/down
    if (directions == 135)
      directions = 225;
  }
 } 
}


//bricks dissapear when hit by the dot
//at level 2, extra layer of bricks are added
//at certain level, an extra ball is added
//creates powerup, will give an extra life
