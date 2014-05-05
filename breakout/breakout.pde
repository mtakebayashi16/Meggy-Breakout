/*
0 = right
180 = left
*/

#include <MeggyJrSimple.h>     //Required code line 1 of 2

void setup(){
  MeggyJrSimpleSetup();        //Required code line 2 of 2
}

int ballX = 0;
int ballY = 4;
int life = 8;                    //the value is for the Aux LEDs, instead of the actual number of lives, the game starts with three lives
boolean gameOver = false;
int level = 1;
int widthMin = 0;
int widthMax = 8;
int brickRows = 2;
int bricksLeft;                //number of bricks that haven't been broken

struct Point {
  int x;
  int y;
};

Point s1 = {0,0};
Point s2 = {1,0};
Point s3 = {2,0};

Point platformArray [3] = {s1, s2, s3};

void loop(){
  SetAuxLEDs(life-1);        //displays the lives left on the aux LEDs
  drawPlatform();              //creates moving platform on bottom of screen
  DisplaySlate();
  delay(100);
  ClearSlate();
  updatePlatform();
  
  drawBricks();
  drawBall();
  
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

void updatePlatform(){                 //shifts platform on the x axis
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



//ball moves freely even if there is no player input
//allows ball to bounce when it hits the platform or the walls or the blocks
//bricks dissapear when hit by the dot
//ball speed increases when level up (doesn't get faster after a certain point
//at level 2, extra layer of bricks are added
//at certain level, an extra ball is added
//creates powerup, will give an extra life
