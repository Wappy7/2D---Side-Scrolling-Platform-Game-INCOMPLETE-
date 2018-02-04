package 
{	//Imports needed
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;
	import flash.geom.*;


	public class Game1 extends MovieClip
	{
		var samus:Samus1 = new Samus1(); //character
		var level1:Level1 = new Level1(); //map, it contains whole map, not just level1
		var coolintro:Wholeintro = new Wholeintro();
		var resumeb:Resumebtn = new Resumebtn();
		var pauseb:pausebtn = new pausebtn();
		var restartb:Restartbtn = new Restartbtn();
		var orbthing:orb = new orb();
		//private var isPaused:Boolean; // This is the variable that holds our paused/unpaused state
		//var gameTimer:Timer;
		
		
		var leftPressed:Boolean = false; //keys pressed by user
		var rightPressed:Boolean = false; 
		var upPressed:Boolean = false;
		var downPressed:Boolean = false;

		var leftBumping:Boolean = false;  //bumping points for the character
		var rightBumping:Boolean = false;
		var upBumping:Boolean = false;
		var downBumping:Boolean = false;

		var leftBumpPoint:Point = new Point(-30, -55);//a point is assigned to the charcter on its body, when those points collide with an object, they will repel
		var rightBumpPoint:Point = new Point(30, -55);
		var upBumpPoint:Point = new Point(0, -120);
		var downBumpPoint:Point = new Point(0, 0);

		var speedofgame:Number = 4;  //speed of the game
		var friction:Number = 0.9;  //friction of the character 
		var gravity:Number = 1.8;  //gravity of the game
		var impulsion:Number = -35; //impuslion of the jump
		var maxspeedofgame:Number = 18; //the maximum speed of the game can go

		var doubleJumpvar:Boolean = false;
		var intheAir:Boolean = false;

		
		
		var scrollX:Number = 0;  //X & Y scroll values for the level
		var scrollY:Number = 500;

		var xSpeed:Number = 0;   //speed used for player and map level
		var ySpeed:Number = 0;
		
		//var orbcollected:Boolean = false; //gem that the player has to collect
		var animationState:String = "idle"; //same as gotoAndStop but I wanted to name it something fancy
		var currentLevel:int = 1; //current level of the game
		var bulletList:Array = new Array();  //array for all bullets fired by player
		var enemyList:Array = new Array();  //array for list of enemies added on to map
		var bumperList:Array = new Array();  //array for bumpers that enemies collide with when moving



		public function Game1()  
		{
			// constructor code
			//isPaused = false; 
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);  //when the keys are pressed
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);      //when the keys are not pressed
			stage.addEventListener(Event.ENTER_FRAME, mainloop);			// main game loop that runs everything
			//stage.addEventListener(Event.ENTER_FRAME, cameraFollowCharacter);
			//addChild(star);
			addChild(level1); //adds level
			addChild(samus); //adds the character
			
			samus.x = 100;	  //position of the character 
			samus.y = 550;
			level1.x = stage.x;  //the position of the level must the same of the stage
			level1.y = stage.y;
			
			
			addEnemiesToLevel1(); //adding enemies and bumpers for the enemies
			addBumpersToLevel1();  //adding bumpers for enemies to collide with
		}

		function addEnemiesToLevel1():void  //enemy function where an x and y value are given to add an enemy to that location
		{
			addEnemy(1879.3, 510.65);
			
			addEnemy(3209.35, 388.9);
			
			addEnemy(7046, 617.75);
			
		}
		
		function addBumpersToLevel1():void  //bumper function where an x and y value are given to add a bumper to that location
		{
			addBumper(1600.65, 510.65);
			addBumper(1920.65, 510.65);
			
			addBumper(3100, 388.9);
			addBumper(3340, 388.9);
			
			addBumper(6500, 617.75);
			addBumper(7900, 617.75);
			
			
		}
		
		/*
		function cameraFollowCharacter(evt:Event) //Camera that follows character's y 
		{
			root.scrollRect = new Rectangle(samus.x - stage.stageWidth / 2,samus.y - stage.stageHeight / 2,stage.stageWidth,stage.stageHeight);
		}
		*/

		function mainloop(e:Event):void //this is the main game loop where all the functions run
		{
			
		
			if (level1.collisions.hitTestPoint(samus.x + leftBumpPoint.x,samus.y + leftBumpPoint.y,true))  //if collisions inside of level1 is in contact with one of samus's bumps, make the bumps equal true
			{
				//trace("leftBumping");
				leftBumping = true;
			}
			else
			{
				leftBumping = false;
			}

			if (level1.collisions.hitTestPoint(samus.x + rightBumpPoint.x,samus.y + rightBumpPoint.y,true))
			{
				//trace("rightBumping");
				rightBumping = true;
			}
			else
			{
				rightBumping = false;
			}

			if (level1.collisions.hitTestPoint(samus.x + upBumpPoint.x,samus.y + upBumpPoint.y,true))
			{
				//trace("upBumping");
				upBumping = true;
			}
			else
			{
				upBumping = false;
			}

			if (level1.collisions.hitTestPoint(samus.x + downBumpPoint.x,samus.y + downBumpPoint.y,true))
			{
				//trace("downBumping");
				downBumping = true;
			}
			else
			{
				downBumping = false;
			}


			if (leftPressed) // if left or right keys are pressed, scroll at the same speed of the game and change direction when needed to.
			{
				xSpeed -=  speedofgame;
				samus.scaleX = -1;

			}
			else if (rightPressed)
			{
				xSpeed +=  speedofgame;
				samus.scaleX = 1;
			}

			/*if(upKey){
			ySpeed -= speedofgame;
			
			} else if(downKey){
			ySpeed += speedofgame;
			
			}*/

			if (leftBumping)   //if any of the bumps collide multiply the speed by -0.5 so that it bounces back from the wall slowly when colldied
			{
				if (xSpeed < 0)
				{
					xSpeed *=  -0.5;
				}
			}

			if (rightBumping)
			{
				if (xSpeed > 0)
				{
					xSpeed *=  -0.5;
				}
			}

			if (upBumping)
			{
				if (ySpeed < 0)
				{
					ySpeed *=  -0.5;
				}
			}

			if (downBumping)
			{						//if samus is touching the floor
				if (ySpeed > 0)
				{
					ySpeed = 0;		//set his y speed to zero
				}
				if (upPressed)
				{
					ySpeed = impulsion;
				}

				//DOUBLE JUMP
				if (intheAir == true)      
				{
					intheAir = false;
				}
				if (doubleJumpvar == false)
				{
					doubleJumpvar = true;
				}
			}
			else
			{	//if samus is not touching the floor

				ySpeed +=  gravity;//accelerate downwards

				//DOUBLE JUMP
				if (upPressed == false && intheAir == false)
				{
					intheAir = true;
					//trace("intheAir");
				}
				if (doubleJumpvar && intheAir)
				{
					if (upPressed)
					{//and if the up arrow is pressed
						//trace("doubleJumpvar!");
						doubleJumpvar = false;
						ySpeed = impulsion;//set the y speed to the jump constant
					}
				}

			}
			
			//if(orbcollected == false){
			//if(level1.gem.orbthing.hitTestObject(samus)){
			//level1.gem.orbthing.visible = false;
			//orbcollected = true;
			//animationState = "celebrate";
			//trace("orb collected");
			//}
			//}
			

			if (xSpeed > maxspeedofgame)  // if the speed is higher than the max speed, make it equal to max speed
			{//moving right
				xSpeed = maxspeedofgame;
			}
			else if (xSpeed < (maxspeedofgame * -1))
			{//moving left
				xSpeed = (maxspeedofgame * -1);
			}

			xSpeed *=  friction;  //multiple by the friction to make the movement look smoother and realistic
			ySpeed *=  friction;

			if (Math.abs(xSpeed) < 0.5)
			{
				xSpeed = 0;
			}

			scrollX -=  xSpeed;
			scrollY -=  ySpeed;

			level1.x = scrollX;  //scroll the level using scrollX & Y
			level1.y = scrollY;

			//star.x = scrollX * 0.2;
			//star.y = scrollY * 0.2;

			if ( ( leftPressed || rightPressed || xSpeed > speedofgame || xSpeed < speedofgame *-1 ) && downBumping) //if any of thses conditions are true or in process, put samus in the running state
			{
				animationState = "running";
			}
			else if (downBumping)  //if he is on the floor and not moving or jumping, make him idle
			{
				animationState = "standing";
			}
			else
			{
				animationState = "jumping";  //otherwise he must jumping and go to his jumping state
			}

			if (samus.currentLabel != animationState) // if samus is not in any kind of state then make him go to the original standing state
			{
				samus.gotoAndStop(animationState);
			}

			
			if (enemyList.length > 0) // if there are any enemies left in the enemyList
			{
			for (var i:int = 0; i < enemyList.length; i++) // for each enemy in the enemyList
			{
			if (bulletList.length > 0) // if there are any bullets alive
			{
			for (var j:int = 0; j < bulletList.length; j++) // for each bullet in the bulletList
			{
			if ( enemyList[i].hitTestObject(bulletList[j]) )  //if the enemies colldie with the bullet
			{
			trace("Bullet and Enemy are colliding");
			enemyList[i].removeSelf();    //remove them both from the screen
			bulletList[j].removeSelf();
			}
			
	
			}
			}
			}
			}
			
			
			//touching the bad guys with bumpers
			if (enemyList.length > 0)
			{ //if there are any enemies left in the enemy array list
			for (var k:int = 0; k < enemyList.length; k++)
			{ // for each enemy in the enemyList
				if (bumperList.length > 0)
				{
			 		for (var h:int = 0; h < bumperList.length; h++)
					{ // for each bumper in the List
						if ( enemyList[k].hitTestObject(bumperList[h]) )
						{  //if the enemy hits the bumper, change its direction
							enemyList[k].changeDirection();
			                        }
			                    }
			                }
			            }
			        }
			
			//samus and enemy collisions
			if (enemyList.length > 0){ //enemies left?
			    for (var m:int = 0; m < enemyList.length; m++){ // for each enemy in the enemyList
			        if ( enemyList[m].hitTestObject(samus) ){ //if samus hits the enemy
			trace("DEAD");
			//gameTimer.stop();
			var dead:wasted = new wasted();  //show the wasted icon
			dead.x = 300;
			dead.y = 200;
			addChild(dead);
			//level1.frameRate = 0;
			//restartb.addEventListener( MouseEvent.CLICK, onClickRestart );
			/*function onClickRestart (event:MouseEvent):void
			{
				 //adds the character
				removeChild(dead);
				samus.x = 100;	  //position of the character 
				samus.y = 550;
				level1.x = stage.x;  //the position of the level must the same of the stage
				level1.y = stage.y;
				addEnemiesToLevel1(); //adding enemies and bumpers for the enemies
				addBumpersToLevel1();
			}
			*/
			//code to damage samus goes here, maybe integrate with a health bar?
			removeChild(samus);
			//enemyList[m].removeSelf();
			}
			}
			}
			
		}

		function keyDownHandler(event:KeyboardEvent):void  //standard keyboard commands for when any of the left, right, up or down arrow keys are pressed
		{
			if (event.keyCode == Keyboard.LEFT)
			{
				leftPressed = true;
				//trace("samus x="+samus.x);

			}
			else if (event.keyCode == Keyboard.RIGHT)
			{
				rightPressed = true;
				//trace("samus x="+samus.x);

			}
			else if (event.keyCode == Keyboard.UP)
			{
				upPressed = true;

			}
			else if (event.keyCode == Keyboard.DOWN)
			{
				downPressed = true;
				//trace("samus y="+samus.y);
			}
		}
		function keyUpHandler(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.LEFT)
			{
				leftPressed = false;

			}
			else if (e.keyCode == Keyboard.RIGHT)
			{
				rightPressed = false;

			}
			else if (e.keyCode == Keyboard.UP)
			{
				upPressed = false;

			}
			else if (e.keyCode == Keyboard.DOWN)
			{
				downPressed = false;
			}

			if (e.keyCode == Keyboard.SPACE)
			{
				shootBullet();
			}
		}

		function shootBullet():void
		{
			var playerDirection:String;  //which place the bullet should come from if the player is facing left or right
			if (samus.scaleX < 0)
			{
				playerDirection = "left";
			}
			else if (samus.scaleX > 0)
			{
				playerDirection = "right";
			}
			var bullet:Shoot = new Shoot(samus.x - scrollX, samus.y - scrollY,playerDirection,xSpeed); //varaible for the bullet
			level1.addChild(bullet);

			bullet.addEventListener(Event.REMOVED, bulletRemoved);  //removing the bullet listener
			bulletList.push(bullet);

		}

		function bulletRemoved(e:Event):void
		{
			e.currentTarget.removeEventListener(Event.REMOVED, bulletRemoved);
			//this just removes the eventListener so we don't get an error;
			bulletList.splice(bulletList.indexOf(e.currentTarget), 1);
		}
		//this removes 1 object from the bulletList, at the index of whatever object caused this function to activate;
		
		function addEnemy(xLocation:int, yLocation:int):void  //add an enemy to the map
	{
		var zombieenemy:zombieEnemy = new zombieEnemy(xLocation,yLocation); //given the x and y, put the enemy there
		level1.addChild(zombieenemy);
		zombieenemy.addEventListener(Event.REMOVED_FROM_STAGE, enemyRemoved); //remove the enemy listener
		enemyList.push(zombieenemy);
	}

	function addBumper(xLocation:int, yLocation:int):void //add a bumper to a certain location
	{
		var bumper:EnemyBumps = new EnemyBumps(xLocation,yLocation); //variable for the bumper
		level1.addChild(bumper);
		bumper.visible = false;
		bumperList.push(bumper);
	}

	function enemyRemoved(e:Event):void //remove the enemy from the map
	{
		e.currentTarget.removeEventListener(Event.REMOVED, enemyRemoved);
		//this just removes the eventListener so we don't get an error;
		enemyList.splice(enemyList.indexOf(e.currentTarget), 1);
	}
};

	
  
}
