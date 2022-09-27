//CSCI 5611 - Graph Search & Planning
//PRM Sample Code [Proj 1]
//Instructor: Stephen J. Guy <sjguy@umn.edu>

//This is a test harness designed to help you test & debug your PRM.

//USAGE:
// On start-up your PRM will be tested on a random scene and the results printed
// Left clicking will set a red goal, right clicking the blue start
// The arrow keys will move the circular obstacle with the heavy outline
// Pressing 'r' will randomize the obstacles and re-run the tests

import java.util.*;
//Camera camera;
//Change the below parameters to change the scenario/roadmap size
int numObstacles = 50;
int numNodes  = 200;
boolean paused = true;
boolean firstTimeSetup = true;
//A list of circle obstacles
static int maxNumObstacles = 1000;



Obstacles allObstacles = new Obstacles(new ArrayList<Circle>(),new ArrayList<Box>());

Vec2 startPos = new Vec2(100,500);
Vec2 goalPos = new Vec2(500,200);

int maxNumAgents = 10;
ArrayList<Agent> agentList = new ArrayList<>();

int startAgentRadius = 10;
static int maxNumNodes = 1000;
Vec2[] nodePos = new Vec2[maxNumNodes];

//Generate non-colliding PRM nodes
void generateRandomNodes(int numNodes){
  for (int i = 0; i < numNodes; i++){
    Vec2 randPos = new Vec2(random(width),random(height));
    boolean insideAnyCircle = allObstacles.pointInCircleList(randPos,2);
    //boolean insideBox = pointInBox(boxTopLeft, boxW, boxH, randPos);
    while (insideAnyCircle){
      randPos = new Vec2(random(width),random(height));
      insideAnyCircle = allObstacles.pointInCircleList(randPos,2);
      //insideBox = pointInBox(boxTopLeft, boxW, boxH, randPos);
    }
    nodePos[i] = randPos;
  }
}
Vec2 sampleFreePos(){
  Vec2 randPos = new Vec2(random(width),random(height));
  boolean insideAnyCircle = allObstacles.pointInCircleList(randPos,startAgentRadius);
  while (insideAnyCircle){
    randPos = new Vec2(random(width),random(height));
    insideAnyCircle = allObstacles.pointInCircleList(randPos,startAgentRadius);
  }
  return randPos;
}

int strokeWidth = 2;
void setup(){
  size(1024,768);
  agentList = new ArrayList<>();
  allObstacles.circles.add(new Circle(new Vec2(100,100),30));
  testPRM();
}


void testPRM(){
  
  if(!paused){
      long startTime, endTime;
      for(int i = 0; i < agentList.size(); i++){
         agentList.get(i).goal = sampleFreePos();
         println("goal is: ", agentList.get(i).goal);
      }
      generateRandomNodesGoalCentric(nodePos, numNodes);
      //generateRandomNodes(numNodes, circlePos, circleRad);
      connectNeighbors(nodePos, numNodes);
      
      startTime = System.nanoTime();
      planPath(numNodes);
      endTime = System.nanoTime();
      //pathQuality();
      
      //for(int i = 0; i < agentList.size(); i++){
      //  println("Nodes:", numNodes," Obstacles:", numObstacles," Time (us):", int((endTime-startTime)/1000),
      //        " Path Len:", pathLength, " Path Segment:", curPath[i].size()+1,  " Num Collisions:", numCollisions);
      //}
      
   }
  
}


//int []curPathIndex = new int[maxNumAgents];
float speed = 30;
Vec2 agentDir;


//void updateAgent(float dt, int agentId){
//   if (curPath[agentId].size() >0 && curPath[agentId].get(0) == -1) return;
//   if(curPathIndex[agentId] >= curPath[agentId].size()) return;
//   Vec2 curGoal = nodePos[curPath[agentId].get(curPathIndex[agentId])];
//   agentDir = nodePos[curPath[agentId].get(curPathIndex[agentId])].minus(agents[agentId]);
//   if(agents[agentId].distanceTo(curGoal) < speed * dt){
//       agents[agentId] = curGoal;
//       curPathIndex[agentId]++;
//   }else{
//       //println("moving towards: ",curPath.get(curPathIndex));
//       agentDir.normalize();
//       agents[agentId].add(agentDir.times(speed*dt));
//   }
//}

void draw(){
  
  background(200); //Grey background
  strokeWeight(1);
  stroke(0,0,0);
  fill(255,255,255);
  
  
  if(!paused){
    
    if(firstTimeSetup){
      testPRM();
      firstTimeSetup = false;
    }
    
    for(int i = 0; i < agentList.size(); i++){
        agentList.get(i).update(1/frameRate);
    }
    
    
    //Draw PRM Nodes
    fill(0);
    for (int i = 0; i < numNodes; i++){
      circle(nodePos[i].x,nodePos[i].y,5);
    }
    //Draw graph
      stroke(100,100,100);
      strokeWeight(1);
      for (int i = 0; i < numNodes; i++){
        for (int j : neighbors[i]){
          line(nodePos[i].x,nodePos[i].y,nodePos[j].x,nodePos[j].y);
        }
      }
      
      
      fill(250,30,50);
      for(int i = 0; i < agentList.size(); i++){
          circle(agentList.get(i).goal.x,agentList.get(i).goal.y,2*agentList.get(i).radius);
      }
      
      
      
      
  }
   
  //Draw Start and Goal
  stroke(100,100,100);
  strokeWeight(1);
  fill(20,60,250);
  for(int i = 0; i < agentList.size(); i++){
      circle(agentList.get(i).pos.x,agentList.get(i).pos.y,2*agentList.get(i).radius);
  }
  
  
  
  strokeWeight(1);
  stroke(0,0,0);
  fill(255,255,255);
  //Draw the circle obstacles
  for (int i = 0; i < allObstacles.circles.size(); i++){
    Vec2 c = allObstacles.circles.get(i).center;
    float r = allObstacles.circles.get(i).radius;
    circle(c.x,c.y,r*2);
  }
  ////Draw the first circle a little special b/c the user controls it
  //fill(240);
  //strokeWeight(2);
  //circle(allObstacles.circles.get(0).center.x,allObstacles.circles.get(0).center.y,allObstacles.circles.get(0).radius*2);
  //strokeWeight(1);
  
  
  
  
  
}


boolean shiftDown = false;
void keyPressed(){
  //camera.HandleKeyPressed();
  if(key == ' '){
    paused = !paused;
  }
  if (key == 'r'){
    if(!paused){
      testPRM();
      return;
    }
    
  }
  
  if (keyCode == SHIFT){
    shiftDown = true;
  }
  
  float speed = 10;
  if (shiftDown) speed = 30;
  if (keyCode == RIGHT){
    allObstacles.circles.get(0).center.x += speed;
  }
  if (keyCode == LEFT){
    allObstacles.circles.get(0).center.x -= speed;
  }
  if (keyCode == UP){
    allObstacles.circles.get(0).center.y -= speed;
  }
  if (keyCode == DOWN){
    allObstacles.circles.get(0).center.y += speed;
  }
  if(!paused && !firstTimeSetup){
    connectNeighbors(nodePos, numNodes);
    planPath(numNodes);
  }
}

void keyReleased(){
  if (keyCode == SHIFT){
    shiftDown = false;
  }
}

void mousePressed(){
  if(paused){
    if(mouseButton == LEFT){
         allObstacles.circles.add(new Circle(new Vec2(mouseX,mouseY),(10+40*pow(random(1),3))));
    }else{
         int id = agentList.size();
         if(agentList.size() < maxNumAgents){
             agentList.add(new Agent(new Vec2(mouseX,mouseY),new Vec2(0,0),numNodes + id, new ArrayList<Vec2>(), id));
         }
    }
  }
  else if (mouseButton == RIGHT){
     int id = agentList.size();
     if(agentList.size() < maxNumAgents){
        agentList.add(new Agent(new Vec2(mouseX,mouseY),new Vec2(0,0),numNodes + id, new ArrayList<Vec2>(), id));
        agentList.get(id).goal = sampleFreePos();
        connectNeighbors(nodePos,numNodes);
        planPath(numNodes);
     }
     
  }
}
