# WorldsHardestGame

This project uses a VGA connector to display a game with a user-controlled square that needs to navigate to the safe zone on the other side without hitting the moving circles. Each circle alternates in the direction that it is moving, The buttons [buttons] are used to control the square up down left, and right. If the square hits any circle it moves back to the starting position. There is a stopwatch that counts up once the reset button is hit. Once it reaches the other safe zone on the other side, the stopwatch stops counting up. 

Inspiration for our game was taken from "World's Hardest Game" as shown below
![Portrait](PicsandVids/World'sHardestGame.png)


### Vivado and Nexys A7 Implementation
We used the Pong Lab 6 code as the starter code.
1. We had to use a VGA connector to display our code on the screen. 
2. We repurposed the bat to be a square rather than a rectangle and gave it x and y motion rather than just x motion
3. We added two safe zones on both sides of the screen, one to spawn in and the other to signify victory once the player has entered it. 
4. We took away the x motion of the ball so that it continuously moves up and down. Then we proceeded to duplicate the balls so that there were 6 moving in the same direction.
5. Then we added 6 more balls moving in opposite directions of the initial 6 balls
6. We decided to keep to the speed logic from the switches as a way to change the difficulty of the game. 

### Modifications
#### Multiple balls
![Portrait](PicsandVids/MultipleBalls.png)
Multiple balls were added to the screen, other than just 1 in the pong game. Each one was set to start halfway up the screen and was aligned 100 pixels apart. Then another 6 balls were added going in the opposite direction, also 100 pixels apart. A total of 12 balls were added, each ball alternates in its direction.
   
### Conclusion
Started the project on Tuesday, and decided to make a version of "World's Hardest Game"; On Wednesday started the initial changing of existing components; By Thursday  we had all 12 balls on screen and everything was appearing as it should; Friday collision logic was finished... 

There was an issue trying to make both sets of balls bounce on the walls at the same time. Sometimes they would bounce at different times causing both sets of balls to move in the same direction which would cause the game to be unplayable. We initially tried changing the starting location, but after that didn't work we realized that the starting locations of the balls were constantly being overridden in the temp sections of the code. They were all initially 440 from the pong lab and we needed the balls to start at 300 for the purposes of our project... 

John Shea - Wrote parts of the code, responsible for the GitHub README.md, worked on slides

Joris Wilson - Wrote parts of the code, Held onto the Nexys board and was responsible for running the code, worked on slides

---------

*A description of the expected behavior of the project, attachments needed (speaker module, VGA connector, etc.), related images/diagrams, etc. (10 points of the Submission category)
high-level block diagram showing how different parts of your program connect together and/or showing how what you have created might fit into a more complete system could be appropriate instead.*

*A summary of the steps to get the project to work in Vivado and on the Nexys board (5 points of the Submission category)*

*Description of inputs from and outputs to the Nexys board from the Vivado project (10 points of the Submission category)
As part of this category, if using starter code you should add at least one input and at least one output appropriate to your project to demonstrate your understanding of modifying the ports of your various architectures and components in VHDL as well as the separate .xdc constraints file.*

*Images and/or videos of the project in action interspersed throughout to provide context (10 points of the Submission category)*

*“Modifications” (15 points of the Submission category)
If building on an existing lab describe your “modifications” – the changes made to that starter code to improve the code, create entirely new functionalities, etc.

*Conclude with a summary of the process itself – who was responsible for what components, the timeline of work completed, any difficulties encountered and how they were solved, etc. (10 points of the Submission category)*
