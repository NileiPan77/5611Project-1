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
Vec2 circlePos[] = new Vec2[maxNumObstacles]; //Circle positions
float circleRad[] = new float[maxNumObstacles];  //Circle radii





Vec2 startPos = new Vec2(100,500);
Vec2 goalPos = new Vec2(500,200);

int numAgents = 0;
int maxNumAgents = 10;
Vec2 agents[] = new Vec2[maxNumAgents];

int startAgentRadius = 10;
static int maxNumNodes = 1000;
Vec2[] nodePos = new Vec2[maxNumNodes];

//Generate non-colliding PRM nodes
void generateRandomNodes(int numNodes, Vec2[] circleCenters, float[] circleRadii){
  
  for (int i = 0; i < numNodes; i++){
    Vec2 randPos = new Vec2(random(width),random(height));
    boolean insideAnyCircle = pointInCircleList(circleCenters,circleRadii,numObstacles,randPos,2);
    //boolean insideBox = pointInBox(boxTopLeft, boxW, boxH, randPos);
    while (insideAnyCircle){
      randPos = new Vec2(random(width),random(height));
      insideAnyCircle = pointInCircleList(circleCenters,circleRadii,numObstacles,randPos,2);
      //insideBox = pointInBox(boxTopLeft, boxW, boxH, randPos);
    }
    nodePos[i] = randPos;
  }
}

void placeRandomObstacles(int numObstacles){
  //Initial obstacle position
  //for (int i = 0; i < numObstacles; i++){
  //  circlePos[i] = new Vec2(random(50,950),random(50,700));
  //  circleRad[i] = (10+40*pow(random(1),3));
  //}
  circleRad[0] = 30; //Make the first obstacle big
  numObstacles = 1;
}

ArrayList<Integer>[] curPath = new ArrayList[maxNumAgents];


int strokeWidth = 2;
void setup(){
  size(1024,768);
  circlePos[0] = new Vec2(100,100);
  circleRad[0] = 30;
  numObstacles = 1;
  testPRM();
  //camera = new Camera();
  //camera.position = new PVector(0,0,25);
  //noStroke();
  
  //// Set the blending mode to BLEND (this is standard "alpha blending").
  //blendMode(BLEND);
  
  //// Enable depth sorting.
  //// NOTE: In Processing, you must enable depth sorting manually since it's considered an expensive operation.
  //hint(ENABLE_DEPTH_SORT);
}

int numCollisions;
float pathLength;
boolean reachedGoal;

//void pathQuality(){
//  Vec2 dir;
//  hitInfo hit;
//  float segmentLength;
//  numCollisions = 9999; pathLength = 9999;
//  if (curPath.size() == 1 && curPath.get(0) == -1) return; //No path found  
  
//  pathLength = 0; numCollisions = 0;
  
//  if (curPath.size() == 0 ){ //Path found with no nodes (direct start-to-goal path)
//    segmentLength = startPos.distanceTo(goalPos);
//    pathLength += segmentLength;
//    dir = goalPos.minus(startPos).normalized();
//    hit = rayCircleListIntersect(circlePos, circleRad, numObstacles, startPos, dir, segmentLength, startAgentRadius);
//    if (hit.hit) numCollisions += 1;
//    return;
//  }
  
//  segmentLength = startPos.distanceTo(nodePos[curPath.get(0)]);
//  pathLength += segmentLength;
//  dir = nodePos[curPath.get(0)].minus(startPos).normalized();
//  hit = rayCircleListIntersect(circlePos, circleRad, numObstacles, startPos, dir, segmentLength, startAgentRadius);
//  if (hit.hit) numCollisions += 1;
  
  
//  for (int i = 0; i < curPath.size()-1; i++){
//    int curNode = curPath.get(i);
//    int nextNode = curPath.get(i+1);
//    segmentLength = nodePos[curNode].distanceTo(nodePos[nextNode]);
//    pathLength += segmentLength;
    
//    dir = nodePos[nextNode].minus(nodePos[curNode]).normalized();
//    hit = rayCircleListIntersect(circlePos, circleRad, numObstacles, nodePos[curNode], dir, segmentLength, startAgentRadius);
//    if (hit.hit) numCollisions += 1;
//  }
  
//  int lastNode = curPath.get(curPath.size()-1);
//  segmentLength = nodePos[lastNode].distanceTo(goalPos);
//  pathLength += segmentLength;
//  dir = goalPos.minus(nodePos[lastNode]).normalized();
//  hit = rayCircleListIntersect(circlePos, circleRad, numObstacles, nodePos[lastNode], dir, segmentLength, startAgentRadius);
//  if (hit.hit) numCollisions += 1;
//}

Vec2 sampleFreePos(){
  Vec2 randPos = new Vec2(random(width),random(height));
  boolean insideAnyCircle = pointInCircleList(circlePos,circleRad,numObstacles,randPos,2);
  while (insideAnyCircle){
    randPos = new Vec2(random(width),random(height));
    insideAnyCircle = pointInCircleList(circlePos,circleRad,numObstacles,randPos,2);
  }
  return randPos;
}

void testPRM(){
  
  if(!paused){
      long startTime, endTime;
      
      goalPos = sampleFreePos();
      
      generateRandomNodesGoalCentric(agents,goalPos,circlePos, circleRad, numObstacles,nodePos, numNodes,numAgents);
      //generateRandomNodes(numNodes, circlePos, circleRad);
      connectNeighbors(circlePos, circleRad, numObstacles, nodePos, numNodes);
      
      startTime = System.nanoTime();
      ArrayList<Integer>[] tempPaths  = planPath(circlePos, circleRad, numObstacles, nodePos, numNodes,numAgents);
      for(int i = 0; i < tempPaths.length; i++){
         curPath[i] = tempPaths[i]; 
      }
      endTime = System.nanoTime();
      //pathQuality();
      
      for(int i = 0; i < numAgents; i++){
        println("Nodes:", numNodes," Obstacles:", numObstacles," Time (us):", int((endTime-startTime)/1000),
              " Path Len:", pathLength, " Path Segment:", curPath[i].size()+1,  " Num Collisions:", numCollisions);
      }
      
   }
  
}


int []curPathIndex = new int[maxNumAgents];
float speed = 30;
Vec2 agentDir;


void updateAgent(float dt, int agentId){
   if (curPath[agentId].size() >0 && curPath[agentId].get(0) == -1) return;
   if(curPathIndex[agentId] >= curPath[agentId].size()) return;
   Vec2 curGoal = nodePos[curPath[agentId].get(curPathIndex[agentId])];
   agentDir = nodePos[curPath[agentId].get(curPathIndex[agentId])].minus(agents[agentId]);
   if(agents[agentId].distanceTo(curGoal) < speed * dt){
       agents[agentId] = curGoal;
       curPathIndex[agentId]++;
   }else{
       //println("moving towards: ",curPath.get(curPathIndex));
       agentDir.normalize();
       agents[agentId].add(agentDir.times(speed*dt));
   }
}

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
    for(int i = 0; i < numAgents; i++){
      updateAgent(1/frameRate,i);
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
      //circle(nodePos[goalNode].x,nodePos[goalNode].y,20);
      circle(goalPos.x,goalPos.y,20);
      
      //No path found
      for(int i = 0; i < numAgents; i++){
          if (curPath[i].size() >0 && curPath[i].get(0) != -1){
              //Draw Planned Path
              stroke(20,255,40);
              strokeWeight(5);
              if (curPath[i].size() == 0){
                line(agents[i].x,agents[i].y,goalPos.x,goalPos.y);
                return;
              }
              //line(startPos.x,startPos.y,nodePos[curPath.get(0)].x,nodePos[curPath.get(0)].y);
              
              for (int j = curPathIndex[i] == 0 ? 0:curPathIndex[i]-1; j < curPath[i].size()-1; j++){
                int curNode = curPath[i].get(j);
                int nextNode = curPath[i].get(j+1);
                line(nodePos[curNode].x,nodePos[curNode].y,nodePos[nextNode].x,nodePos[nextNode].y);
              }
              //line(goalPos.x,goalPos.y,nodePos[curPath.get(curPath.size()-1)].x,nodePos[curPath.get(curPath.size()-1)].y);
        }
      }
      
      
      
  }
   
  //Draw Start and Goal
  stroke(100,100,100);
  strokeWeight(1);
  fill(20,60,250);
  for(int i = 0; i < numAgents; i++){
      circle(agents[i].x,agents[i].y,2*startAgentRadius);
  }
  
  
  
  strokeWeight(1);
  stroke(0,0,0);
  fill(255,255,255);
  //Draw the circle obstacles
  for (int i = 0; i < numObstacles; i++){
    Vec2 c = circlePos[i];
    float r = circleRad[i];
    circle(c.x,c.y,r*2);
  }
  //Draw the first circle a little special b/c the user controls it
  fill(240);
  strokeWeight(2);
  circle(circlePos[0].x,circlePos[0].y,circleRad[0]*2);
  strokeWeight(1);
  
  
  
  
  
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
      curPathIndex = new int[maxNumAgents];
      return;
    }
    
  }
  
  if (keyCode == SHIFT){
    shiftDown = true;
  }
  
  float speed = 10;
  if (shiftDown) speed = 30;
  if (keyCode == RIGHT){
    circlePos[0].x += speed;
  }
  if (keyCode == LEFT){
    circlePos[0].x -= speed;
  }
  if (keyCode == UP){
    circlePos[0].y -= speed;
  }
  if (keyCode == DOWN){
    circlePos[0].y += speed;
  }
  if(!paused && !firstTimeSetup){
    connectNeighbors(circlePos, circleRad, numObstacles, nodePos, numNodes);
    curPath = planPath(circlePos, circleRad, numObstacles, nodePos, numNodes, numAgents);
    curPathIndex = new int[maxNumAgents];;
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
       circlePos[numObstacles] = new Vec2(mouseX,mouseY);
       circleRad[numObstacles++] = (10+40*pow(random(1),3));
    }else{
       
       agents[numAgents%maxNumAgents] = new Vec2(mouseX,mouseY);
       numAgents++;
       if(numAgents > maxNumAgents){
          numAgents = maxNumAgents; 
       }
       nodePos[numNodes + numAgents] = goalPos;
    }
  }
  else if (mouseButton == RIGHT){
     int indextoPlace = numAgents%maxNumAgents;
     agents[indextoPlace] = new Vec2(mouseX,mouseY);
     nodePos[indextoPlace+numNodes] = agents[indextoPlace];
     numAgents++;
     if(numAgents > maxNumAgents){
        numAgents = maxNumAgents; 
     }
     nodePos[numNodes + numAgents] = goalPos;
     connectNeighbors(circlePos,circleRad,numObstacles,nodePos,numNodes);
     ArrayList<Integer>[] tempPaths  = planPath(circlePos, circleRad, numObstacles, nodePos, numNodes,numAgents);
      for(int i = 0; i < tempPaths.length; i++){
         curPath[i] = tempPaths[i]; 
      }
      curPathIndex = new int[maxNumAgents];
  }
  else{
    goalPos = new Vec2(mouseX, mouseY);
    nodePos[numNodes + numAgents] = goalPos;
    connectNeighbors(circlePos,circleRad,numObstacles,nodePos,numNodes);
    ArrayList<Integer>[] tempPaths  = planPath(circlePos, circleRad, numObstacles, nodePos, numNodes,numAgents);
    for(int i = 0; i < tempPaths.length; i++){
       curPath[i] = tempPaths[i]; 
    }
    curPathIndex = new int[maxNumAgents];
  }
}
