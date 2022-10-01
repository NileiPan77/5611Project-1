# Project 1 Geometric Methods 

Team Member 1: 

- Name: Nilei Pan
- x500: pan00128
- ID: 5616867

Team Member 2:

- Name: Yizhou(Nick) Wang
- x500: wang9205
- ID: 5578858

#### Feature Implemented

##### Par2

- Single Agent Navigation <br />
![ezgif com-gif-maker](https://user-images.githubusercontent.com/57411086/193336458-3d989052-6cc4-4397-a900-52fad8be3373.gif) <br />
We implement the Single Agent Navigation function in Proj1-ui folder. By clicking the left left mouse button, the obsticles shall be established at the position where the mouse position is. When pressing the space key, the nodes are established with the neighbor lines connect with each other. When clicking the right mouse button, the start position shall be at where the mouse is(the blue triangle), and the goal position shall be randomized on the graph(the red circle). THe triangle shall navigate its path and goes to the goal position. <br />
- 3D Rendering & Camera <br />
![3D Rendering   Camera](https://user-images.githubusercontent.com/57411086/193339417-be29bc23-8788-48d3-a670-0caead26dbd4.gif) <br />
We implement the 3D Rendering & Camera in Proj1-3D folder. The stars can plan their own path, go through the trees and reach the crown goal position. <br />
- Improved Agent & Scene Rendering <br />
We implement the Improved Agent & Scene Rendering in Proj1-3D folder. The shown video is the same as 3D Rendering & Camera's video. We use the complex shapes (star represents the agent and crown represents the goalposition). <br />
- Orientation Smoothing <br />
![Multiple Agents Movement](https://user-images.githubusercontent.com/57411086/193342509-7853a701-a474-4465-aa8b-994bf30f2b56.gif) <br />
We implement the Orientation Smoothing in Proj1-ui folder. We use the triangles that represents the agents, and one of their angles always point towards to the directions. If the agents and goals can not generate straight lines, the triangles will rotatie based on thieir direction motions. <br />
- User Scenario Editing <br />
We implement the User Scenario Editing in Proj1-ui folder. The video is the same as Orientation Smoothing's video. As you can see from the video, you can click the left mouse button to set up the obsticles, and you can click the right mouse button to put the agents both from the beginning of the simulation and during the runtime. <br />
- Multiple Agents Planning <br />
We implement the Multiple Agents Planning in Proj1-ui folder. THe video is the same as Orientation Smoothing's video. From the video, you can see that multiple agents move smoothly and simulaneously in teh scene. All agents move towards to their own independent goals, adn each agent has their own paht planning. <br />

##### Part 3

- TTC collision avoidance <br />
![Part3 Crownd Simulation](https://user-images.githubusercontent.com/57411086/193348490-6efc9b07-b087-4595-a529-bdca9a0ce2f0.gif) <br />
We implement the Crowd Simulation in Proj1-ui folder. This is the first interesting senario where if you put multiple agents in the same place, they shall move like a boid behavior, which they goes together for a short time and reach to their own goal. <br />
![Part3 Crownd Simulation 2](https://user-images.githubusercontent.com/57411086/193349744-3c9ec728-238f-47d6-8d7d-08b492b91105.gif) <br />
This is another interesting senario where when two agents tend to collise with each other, they shall move together or one of the agent shall go out of the way and go back to its final position. <br />
![Part3 Crownd Simulation 3D ](https://user-images.githubusercontent.com/57411086/193353945-37ce6f90-0ff5-446b-a68c-760edf79ff65.gif)  <br />
As we can see above, the 3D model also support TTC function which when two star will crash to each other, they tend to move into other way and avoid collision. <br />



