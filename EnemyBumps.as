package  {
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class EnemyBumps extends MovieClip{
		public function EnemyBumps(xLocation:int, yLocation:int) { //bumps for the enemies to bump along while moving 
			// constructor code
			x = xLocation; 
			y = yLocation;
			
			addEventListener(Event.ENTER_FRAME, bumper);
		}

		public function bumper(e:Event):void{
			//just a function, I don't need anything here
		}
	}
	
}
