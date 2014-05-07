/*
0 = right
180 = left
*/

#include <MeggyJrSimple.h>     //Required code line 1 of 2

void setup(){
  MeggyJrSimpleSetup();        //Required code line 2 of 2
}

int counter = 0;
int ballSpeed = 3;              //speed of the ball, the higher the speed, the slower the ball
int ballX = 0;
int ballY = 4;
int life = 8;        //the value is for the Aux LEDs, instead of the actual number of lives, the game starts with three lives
boolean gameOver = false;
int level = 1;
int widthMin = 0;
int widthMax = 8;
int brickRows = 2;
int bricksLeft = 16;                //number of bricks that haven't been broken yet

struct Point {
  int x;
  int y;
};

Point s1 = {0,0};
Point s2 = {1,0};
Point s3 = {2,0};

Point platformArray [3] = {s1, s2, s3};

void loop(){
  if (counter > 20){
    counter = 0;
  }
  else{
    counter ++;
  }
  SetAuxLEDs(life-1);        //displays the lives left on the aux LEDs
  drawPlatform();              //creates moving platform on bottom of screen
  drawBricks();
  
  if (counter % 3 == 0)    //determines how many times the loop runs before the platform can move
    movePlatform();
  
  drawBall();
  
  if (counter % ballSpeed == 1)        //controls the speed of the ball, speed changes depending on level
    updateBall();

  DisplaySlate();

  if (ReadPx(ballX, ballY) == Red){
    bricksLeft --; 
  }
  
  if (bricksLeft = 0)
    levelUp();
  
  if (life = 1)                  //when run out of lives, game over
    gameOver = true;
    
  if (gameOver){                    //game over sequence
    ClearSlate();
    delay(2000);
    Tone_Start(ToneA3, 500);
    Tone_Start(ToneC3, 500);
    level = 1;                    //resets level
    life = 8;                     //resets number of lives
  }
}                  //ends loop

void drawPlatform(){            //creates moving platform on bottom of screen
  for (int i = 0; i < 3; i++){
    DrawPx(platformArray[i].x, 0, Yellow);
    CheckButtonsDown();          //check buttons being pressed, shifts platform on the x axis
    if(Button_Left)  
      platformArray[0].x --;
    if(Button_Right) 
      platformArray[3].x ++;
  
    if (platformArray[0].x < 0){          //creates boundaries, keeps the platform on screen
       platformArray[0].x = 0;
       
     }
    if (platformArray[3].x > 7)
       platformArray[3].x = 7;
  }
}

void movePlatform(){                 //shifts platform on the x axis
  for (int i = 3; i > 0; i--){
   platformArray[i].x = platformArray[i-1].x;
   platformArray[i].y = platformArray[i-1].y;
  }
}


void drawBall(){                       //creates ball
  DrawPx(ballX,ballY,Blue);
}

void updateBall(){                 //if the ball touches the bottom of the screen lose a life 
  if (ballY = 0)
    life = life/2;
}

void drawBricks(){                          //creates the bricks on the top of the screen
  for (int i = 1; i < brickRows; i++){
    for (int x = 0; x < 8; x++){
      DrawPx(x, 7-i, Red);
    }
  }
}

void levelUp(){                            
  if (ballSpeed < 1){        //ball speed increases when level up (doesn't get faster after a certain point
    ballSpeed = 1;
  }
  else{
   ballSpeed --; 
  }
   
  drawBricks(); 
}

//ball moves freely even if there is no player input
//allows ball to bounce when it hits the platform or the walls or the blocks
//bricks dissapear when hit by the dot
//at level 2, extra layer of bricks are added
//at certain level, an extra ball is added
//creates powerup, will give an extra life
