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
int brickRows = 2;
int bricksLeft = 16;                //number of bricks that haven't been broken yet
int platformX = 0;            //x coord for platform


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
  
//  if (counter % ballSpeed == 1)        //controls the speed of the ball, speed changes depending on level
//    updateBall();

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
  //  Tone_Start(ToneA3, 500);
   // Tone_Start(ToneC3, 500);
    level = 1;                    //resets level
    life = 8;                     //resets number of lives
  }
}                  //ends loop

void drawPlatform(){            //creates moving platform on bottom of screen
  DrawPx(platformX, 0, Yellow);
  DrawPx(platformX+1, 0, Yellow);
  DrawPx(platformX+2, 0, Yellow);
}

void movePlatform(){                 //shifts platform on the x axis
   CheckButtonsPress();
  if (Button_Right)
    platformX ++;
  if (Button_Left)
    platformX --;
    
  if (platformX < 0)
    platformX = 0;
   
   if (platformX+2 > 7)
     platformX = 5;
}


void drawBall(){                       //creates ball
  DrawPx(ballX,ballY,Blue);
}

void updateBall(){                 //if the ball touches the bottom of the screen lose a life 
  if (ballY = 0)
    life = life/2;
}

void drawBricks(){                          //creates the bricks on the top of the screen
  for (int i = 7; i > 4; i++){
    for (int x = 0; x < 8; x++){
      DrawPx(x, i, Red);
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
