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

struct Point {
  int x;
  int y;
};

Point s1 = {0,0};
Point s2 = {1,0};
Point s3 = {2,0};

Point platformArray [3] = {s1, s2, s3};

void loop(){
  drawPlatform();              //creates moving platform on bottom of screen
  DisplaySlate();
  delay(100);
  ClearSlate();
  updatePlatform();
  
  drawBall();
  drawBricks();
   
}                  //ends loop

void drawPlatform(){            //creates moving platform on bottom of screen
  for (int i = 0; i < 3; i++){
    DrawPx(platformArray[i].x, 0, Yellow);
  }
}

void updatePlatform(){                 //shifts platform on the x axis
  CheckButtonsDown();          //check buttons being pressed, shifts platform on the x axis
  for (int i = 0; i < 3; i++){
    if(Button_Left)  
      platformArray[i].x ++;
    if(Button_Right) 
      platformArray[i].x --;
  
     if (platformArray[i].x < 0)          //creates boundaries, keeps the platform on screen
       platformArray[i].x = 0;
     if (platformArray[i].x > 7)
       platformArray[i].x = 7;
  }
}

void drawBall(){                       //creates ball
  DrawPx(ballX,ballY,Blue);
}

void drawBricks(){                     //creates the bricks on the top of the screen
  
}

//ball moves freely even if there is no player input
//allows ball to bounce when it hits the platform or the walls or the blocks
//bricks dissapear when hit by the dot
//if the ball touches the bottom of the screen lose a life
//lives displayed on aux LEDs
//when run out of lives, game over
//ball speed increases when level up (doesn't get faster after a certain point
//at level 2, extra layer of bricks are added
//at certain level, an extra ball is added
//creates powerup, will give an extra life
