package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Stage;
	
	public class Shoot extends MovieClip {
		
		private var speed:int = 30; //speed of the bullet
		private var initialX:int; // the intial place of the bullet
		
		public function Shoot(playerX:int, playerY:int, playerDirection:String, playerSpeed:int) { //variables needed when the character shoots the bullet
			
			// constructor code
			if(playerDirection == "left") {  //if the player facing left, shoot the bullets from the left
				speed = -30 + playerSpeed; //speed is faster if player is running
				x = playerX - 25;
			} else if(playerDirection == "right") { //otherwise if the player is facing the right, shoot the bullets to the right
				speed = 30 + playerSpeed;
				x = playerX + 25
			}
			y = playerY - 35;  //the y direction of the bullet
			
			initialX = x; 
			
			addEventListener(Event.ENTER_FRAME, loop);
		}
		
		public function loop(e:Event):void //main loop of the shoot class
		{
			//looping code goes here
			x += speed;
			
			if(speed > 0) { //if player is facing right
				if(x > initialX + 800) { //and the bullet is more than 800px to the right of where it was spawned
					removeSelf(); //remove it
				}
			} else { //else if player is facing left
				if(x < initialX - 800) {  //and bullet is more than 800px to the left of where it was spawned
					removeSelf(); //remove it
				}
			}
		}
		
		public function removeSelf():void  //the remove function of bullet
		{
			trace("remove self");
			removeEventListener(Event.ENTER_FRAME, loop); //stop the loop
			this.parent.removeChild(this); //tell this object's "parent object" to remove this object
			//in our case, the parent is the background because in the main code we said:
			
		}

	}
	
}
