package  {
        import flash.display.MovieClip;
        import flash.events.Event;

        public class zombieEnemy extends MovieClip {
        	private var xSpeedConst:int = 2; //x speed of enemy
			private var flip:int = 1;  //flip the character 
            
			public function zombieEnemy(xLocation:int, yLocation:int) { //variables for the enemies' location
            	// constructor code
                x = xLocation;
                y = yLocation;
                addEventListener(Event.ENTER_FRAME, loop);  //loop
            }

           public function loop(e:Event):void {
              	if ((flip%2) == 1){   // flip the character and move the character
					x += xSpeedConst;
				}
				else if((flip%2) == 0){
					x += (-xSpeedConst);
				}
            }
			
            public function removeSelf():void {  //remove function that will remove the enemy
                //trace("remove enemy");
                removeEventListener(Event.ENTER_FRAME, loop);
                this.parent.removeChild(this);
            }

			public function changeDirection():void{ //change the diraction and the where the enemies facing
	           //	trace("x ="+x);
            	flip++;
            }
			
		}
	}
