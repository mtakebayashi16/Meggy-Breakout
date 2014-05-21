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
int dotX = 0;              //ball coordinates
int dotY = 4;
int directions = 315;      //the ball starts by going diagonally down/right
int counter = 0;        //counts times through the loop
int life = 8;        //the value is for the Aux LEDs, instead of the actual number of lives, the game starts with three lives
int livesLeft = 3;    //indicates the number of lives the player has
boolean gameOver = false;
int level = 1;              //what level the game starts at
int bricksLeft = 7;        //how many bricks are left on screen (starts at 0 and counts up)
int brickNumber;        //used in collision detection to determine which brick should be dark

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
Brick s4 = {6,7,1};
Brick s5 = {0,6,4};
Brick s6 = {2,6,6};
Brick s7 = {4,6,1};
Brick s8 = {6,6,4};
Brick s9 = {0,5,6};
Brick s10 = {2,5,1};
Brick s11 = {4,5,4};
Brick s12 = {6,5,6};

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
  
  if (counter % 400 == 0)
    checkDirections();        //moves the ball every 450th time through the loop
  
  collisionDetection();
  
  if (bricksLeft == 0)
    levelUp();
    
  if (livesLeft == 0)
    gameOver = true;
  
  if (gameOver)
    gameRestart();
  
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
  CheckButtonsDown();    //only moves the platform every 250th time through the loop, using CheckButtonsDown is smoother than having CheckButtonsPress,
  if (counter % 200 == 0){ 
     if (Button_Left)
       if (platformArray[0].x > 0){
         for (int i = 0; i < 3; i++){       //so now the player can hold down the directions instead of having to press every time
           platformArray[i].x --;             //moves platform left when Left button is pressed 
         }
       }
      if (Button_Right) 
        if (platformArray[2].x < 7){
          for (int i = 0; i < 3; i++){
            platformArray[i].x ++;          //moves platform right when Right button is pressed
          }
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
    livesLeft--;
    ClearSlate();
    delay(1000);
    dotX = 0;              //resets ball coordinates and direction
    dotY = 4;
    directions = 315;
  }
}         //end boundaries check

void collisionDetection(){
 for(int i = 0; i <= marker; i++){
   if (ReadPx(dotX, dotY+1) != Dark){    //collision detection for the bricks   
    brickNumber = dotX;    
    if (dotY == 6){                          //code to make the bricks on the top row disappear
      if (brickNumber % 2 == 0)             //code for every other brick (so every time two bricks are erased instead of just one if the ball hits the edges)
        brickNumber = brickNumber / 2;          //so the brickNumber correlates to the brickArray number     
      if (brickNumber % 2 == 1)                //code for the odd numbered bricks, they use a different formula to figure out which bricks to erase
        brickNumber = (brickNumber - 1) / 2;
    }
    if (dotY == 5){                          //code to make the bricks on the second row disappear      
     if (brickNumber % 2 == 0)
       brickNumber = (brickNumber / 2) + 4;
     if (brickNumber % 2 == 1)
       brickNumber = (brickNumber / 2) + 3.5;
    }
    if (dotY ==4){                            //code to make the bricks on the third row disappear
      if (brickNumber % 2 == 0)
        brickNumber = (brickNumber / 2) + 8;
      if (brickNumber % 2 == 1)
        brickNumber = (brickNumber / 2) + 7.5;
    }
    brickArray[brickNumber].color = 0;
    bricksLeft --;
    if (directions == 45)
      directions = 315;    //if the ball is going right/up, it will go right/down
    if (directions == 90)
      directions = 315;       //if the ball is going straight up, it will go right/down
    if (directions == 135)
      directions = 225;
  }
 }
 for (int i = 0; i < 3; i++){
  if (dotY == platformArray[i].y && dotX == platformArray[i].x){          //collision detection for the platform
    dotY = 1;
    int j = random(1,3);        //random sequence to determine which way the ball bounces
    if (directions == 225){
      if (j == 1)              
        directions = 135;        //if the ball is going left/down, half of the time it will go left/up
      if (j == 2)              //half of the time the ball will go straight up
        directions = 90;        
    }
    if (directions == 270){
      if (j ==1)
      directions = 45;        //if the ball is going straight down, half of the time it will go right/up
      if (j == 2)                  //half of the time the ball will go straight up
        directions = 90;
    }
    if (directions == 315){
      if (j == 1)
      directions = 45;        //if the ball is going right/down, half of the time it will go left/up
      if (j == 2)                      //half of the time the ball will go straight up
        directions = 90;
    }  
  }
 }
}      //end collision detection

void levelUp(){
  marker = 11;          //at level 2, extra layer of bricks are added
  ClearSlate();
  delay(200);
  dotX = 0;            
  dotY = 4;
  directions = 315;  
  bricksLeft = 11;
  counter = 0;
  for (int i = 0; i <=marker; i++){
    brickArray[i].color = random (1, 15);
  }
}                      //end levelUp

void gameRestart(){      //resets all the variables to original settings
  marker = 7;            
  dotX = 0;            
  dotY = 4;
  directions = 315;  
  livesLeft = 3;  
  life = 8;  
  level = 1;            
  bricksLeft = 7;
  for (int i = 0; i <=marker; i++){
    brickArray[i].color = random (1, 15);
  }
  ClearSlate();
  delay(2000);
  Tone_Start(ToneC3, 700);
  Tone_Start(ToneFs3, 700);
  gameOver = false;
}        //end gameRestart



//reset color of bricks at gameOver
//reset color of bricks during levelUp
//bricks dissapear when hit by the dot
//at certain level, an extra ball is added
//creates powerup, will give an extra life
