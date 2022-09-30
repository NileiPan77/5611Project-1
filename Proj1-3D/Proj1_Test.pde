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

Camera camera;

int width = 600;
int height = 600;

Obstacles allObstacles = new Obstacles(new ArrayList<Circle>(),new ArrayList<Box>());
ObjMesh star;
ObjMesh crown;

int maxNumAgents = 3;
ArrayList<agent> agentList = new ArrayList<>();

int startAgentRadius = 20;
static int maxNumNodes = 1000;
Vec2[] nodePos = new Vec2[maxNumNodes];

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
  size(1024,768,P3D);
  agentList = new ArrayList<>();

  crown = new ObjMesh("./data/Crown.obj");
  star = new ObjMesh("./data/Star.obj");
  allObstacles.treeMesh = new ObjMesh("./data/BirchTree_Autumn_3.obj");
  allObstacles.treeMesh.position = new PVector(0,0,0);
  allObstacles.treeMesh.rotation = new PVector(-90, 0, 180);
  allObstacles.treeMesh.scale = 25;


  allObstacles.makeRandomPositions();

  for(int i = 0; i < maxNumAgents; i++){
    agentList.add(new agent(sampleFreePos(),new Vec2(0,0),numNodes + i, new ArrayList<Vec2>(), i));
    
  }

  camera = new Camera();
  blendMode(BLEND);
  hint(ENABLE_DEPTH_SORT);
  testPRM();
}


void testPRM(){
  
      for(int i = 0; i < agentList.size(); i++){
         agentList.get(i).goal = sampleFreePos();
      }
      generateRandomNodesGoalCentric(nodePos, numNodes);
      connectNeighbors(nodePos, numNodes);
      
      planPath(numNodes);
  
}


void draw(){
  background(255);

  camera.update(1.0/frameRate);
  directionalLight(255.0, 255.0, 255.0, -1, 1, -1);

  allObstacles.draw3DObstacles();

  

  fill(0,200,175);
  pushMatrix();
  translate(300, 300, 0); 
  box(600, 600, 1);
  popMatrix();

  for(int i = 0; i < agentList.size(); i++){
        agentList.get(i).update(1/frameRate);
        agentList.get(i).draw3DAgent();
  }
  
}


void keyPressed(){

  camera.HandleKeyPressed();
  // if(key == ' '){
  //   paused = !paused;
  // }
  if (key == 'r'){
      testPRM();
      return;
    }
    
  // }
  // if(!paused && !firstTimeSetup){
  //   connectNeighbors(nodePos, numNodes);
  //   planPath(numNodes);
  // }
}

void mousePressed(){
  camera.mousePressed(); 
  // if(paused){
  //   if(mouseButton == LEFT){
  //        allObstacles.circles.add(new Circle(new Vec2(mouseX,mouseY),(10+40*pow(random(1),3))));
  //   }else{
  //        int id = agentList.size();
  //        if(agentList.size() < maxNumAgents){
  //            agentList.add(new Agent(new Vec2(mouseX,mouseY),new Vec2(0,0),numNodes + id, new ArrayList<Vec2>(), id));
  //        }
  //   }
  // }
  // else if (mouseButton == RIGHT){
  //    int id = agentList.size();
  //    if(agentList.size() < maxNumAgents){
  //       agentList.add(new Agent(new Vec2(mouseX,mouseY),new Vec2(0,0),numNodes + id, new ArrayList<Vec2>(), id));
  //       agentList.get(id).goal = sampleFreePos();
  //       connectNeighbors(nodePos,numNodes);
  //       planPath(numNodes);
  //    }
  // }
}

void keyReleased()
{
  camera.HandleKeyReleased();
}
void mouseReleased(){
    camera.mouseReleased(); 
}

void mouseDragged(){
   camera.mouseDragged(); 
}

void mouseWheel(MouseEvent event){
  camera.mouseWheel(event);
}
