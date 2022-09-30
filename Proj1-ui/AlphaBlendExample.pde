Camera camera;
PImage spriteBlue;
PImage spriteRed;
PImage greenLand;
int numOfTrees = 120;
ObjMesh[] tree = new ObjMesh[numOfTrees];
ObjMesh people;
//randomPeople is the startPos
Vec2 randomPeople;
Vec2 goalPosition;
Vec2 peoplePos = new Vec2(0,0);
int numNodes = 120;
Vec2[] nodePos = new Vec2[numNodes];
ArrayList<Integer> curPath;
boolean noWay = false;
boolean direct = false;

PVector[] positions;
Vec2[] centers = new Vec2[numOfTrees];
float radius = 20;
float[] radii = new float[numOfTrees];
float speed = 50.0f;

void setup()
{
  size(600, 600, P3D);
  
  // Create a new camera and move it back in space to fit all quads in view.
  camera = new Camera();
  
  greenLand = loadImage("greenLand.png");
  
  
  // Prevent outlines around the textured quads.
  noStroke();
  
  // Set the blending mode to BLEND (this is standard "alpha blending").
  blendMode(BLEND);
  
  // Enable depth sorting.
  // NOTE: In Processing, you must enable depth sorting manually since it's considered an expensive operation.
  hint(ENABLE_DEPTH_SORT);
  
  // If the built-in depth sorting algorithm is too slow, you could get something similar with the following:
  // 1. hint(DISABLE_DEPTH_TEST);
  // 2. manually sort quads based on distance to camera (presumably faster than processings built in algorithm).
  // 3. draw sorted quads from furthest to nearest.
  // 4. hint(ENABLE_DEPTH_TEST);

  generateRandomTrees(numOfTrees, radius);

  for(int i = 0; i < numOfTrees; i++) {
    if(i < 15) {
      tree[i] = new ObjMesh("BirchTree_1.obj");
    }
    else if(i >= 15 && i < 30) {
      tree[i] = new ObjMesh("BirchTree_2.obj");
    }
    else if(i >= 30 && i < 45) {
      tree[i] = new ObjMesh("BirchTree_3.obj");
    }
    else {
      tree[i] = new ObjMesh("BirchTree_4.obj");
    }
    tree[i].position = new PVector(centers[i].x, centers[i].y, 0);
    tree[i].rotation = new PVector(-90, 0, 180);
    tree[i].scale = 40.0f;
  }

  randomPeople = new Vec2(random(-800, 800), random(-800, 800));
  peoplePos.x = randomPeople.x;
  peoplePos.y = randomPeople.y;
  boolean insideAnyCircle = circleInCircleList(centers, radius, randomPeople, radius, numOfTrees);
  while(insideAnyCircle) {
    randomPeople = new Vec2(random(-800, 800), random(-800, 800));
    insideAnyCircle = circleInCircleList(centers, radius, randomPeople, radius, numOfTrees);
  }
  people = new ObjMesh("Male_Shirt.obj");
  people.position = new PVector(randomPeople.x, randomPeople.y, 0);
  people.rotation = new PVector(-90, 0, 180);

  goalPosition = new Vec2(random(-800, 800), random(-800, 800));
  insideAnyCircle = circleInCircleList(centers, radius, goalPosition, radius, numOfTrees);
  while(insideAnyCircle) {
    goalPosition = new Vec2(random(-800, 800), random(-800, 800));
    insideAnyCircle = circleInCircleList(centers, radius, goalPosition, radius, numOfTrees);
  }

  camera.position = new PVector(randomPeople.x+200,randomPeople.y+200,500);

  for(int i = 0; i < numOfTrees; i++) {
    radii[i] = radius;
  }
  
  Vec2 dir = goalPosition.minus(randomPeople).normalized();
  float distBetween = randomPeople.distanceTo(goalPosition);
  hitInfo circleListCheck = rayCircleListIntersect(centers, radii, numOfTrees, randomPeople, dir, distBetween);
  if(!circleListCheck.hit) {
    direct = true;
  }

  generateRandomPeopleNodes(numNodes);
  for(int i = 0; i < numNodes; i++) {
    println("nodePos: ", nodePos[i]);
  }
  
  connectNeighbors(centers, radii, numOfTrees, nodePos, numNodes);
  curPath = planPath(randomPeople, goalPosition, centers, radii, numOfTrees, nodePos, numNodes);
  if(curPath.size() == 0 && !direct) {
    println("there is no way to go to the goal");
    noWay = true;
  }
  println("current path: ", curPath);

}

boolean paused = true;

void keyPressed()
{
  camera.HandleKeyPressed();

  if(key == ' ') {
    if(!noWay){
      println("move!!!");
      paused = !paused;
    }
  }
}

void keyReleased()
{
  camera.HandleKeyReleased();
}

void mousePressed(){
  camera.mousePressed(); 
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
// Draws a scaled, textured quad at the given position.
void drawTexturedQuad(PVector position, float scale, PImage texture)
{
  pushMatrix();
  translate(position.x, position.y, position.z);
  scale(scale, scale, scale);
  beginShape();
  texture(texture);
  vertex(-1, -1, 0, 0, 0);
  vertex(1, -1, 0, texture.width, 0);
  vertex(1, 1, 0, texture.width, texture.height);
  vertex(-1, 1, 0, 0, texture.height);
  endShape();
  popMatrix();
}

void draw()
{
  background(255);
  camera.update(1.0/frameRate);
  
  directionalLight(255.0, 255.0, 255.0, 0, -1, -1);

  PVector pos = new PVector(0,0,0);
  drawTexturedQuad(pos, 1000.0f, greenLand);

  for(int i = 0; i < numOfTrees; i++) {
    tree[i].draw();
  }

  fill(20, 200, 150);
  for(int i = 0; i < numOfTrees; i++) {
    circle(centers[i].x, centers[i].y, radius*2);
  }

  if(!paused) {
    update(1.0/frameRate);
  }

  people.draw(peoplePos);
}

boolean circleInCircle(Vec2 center, float r, Vec2 pointPos, float eps){
  float dist = pointPos.distanceTo(center);
  if (dist < r+eps+2){
    return true;
  }
  return false;
}

boolean circleInCircleList(Vec2[] centers, float radii, Vec2 pointPos, float eps, int amountCenter){
  for (int i = 0; i < amountCenter; i++){
    Vec2 center =  centers[i];
    float r = radii;
    if(center == null) {
      println("code goes to circleInCircleList");
    }
    if(circleInCircle(center,r,pointPos,eps)){
      return true;
    }
  }
  return false;
}

void generateRandomTrees(int numTrees, float radius) {
  int nums = 0;
  Vec2 center = new Vec2(random(-100,100), random(-100, 100));
  centers[nums] = center;
  nums++;
  while(nums < numTrees) {
    center = new Vec2(random(-800, 800), random(-800, 800));
    boolean insideAnyCircle = circleInCircleList(centers, radius, center, radius, nums);
    while(insideAnyCircle) {
      center = new Vec2(random(-800, 800), random(-800, 800));
      insideAnyCircle = circleInCircleList(centers, radius, center, radius, nums);
    }
    centers[nums] = new Vec2(0,0);
    centers[nums].x = center.x;
    centers[nums].y = center.y;
    nums++;
  }
}

void generateRandomPeopleNodes(int numNodes) {
  for(int i = 0; i < numNodes; i++) {
    Vec2 randomPos = new Vec2(random(-500, 500),random(-500, 500));
    boolean insideAnyCircle = circleInCircleList(centers, radius, randomPos, radius, numOfTrees);
    while(insideAnyCircle) {
      randomPos = new Vec2(random(-500, 500),random(-500, 500));
      insideAnyCircle = circleInCircleList(centers, radius, randomPos, radius, numOfTrees);
    }
    nodePos[i] = new Vec2(0,0);
    nodePos[i].x = randomPos.x;
    nodePos[i].y = randomPos.y;
    println("randomPos ", randomPos);
  }
}

int posIndex = 0;

void update(float dt) {
  println("code in update");
  if(posIndex < curPath.size() && (abs(peoplePos.x - nodePos[curPath.get(posIndex)].x) > 50 || abs(peoplePos.y - nodePos[curPath.get(posIndex)].y) > 50)) {
    Vec2 dir = nodePos[curPath.get(posIndex)].minus(peoplePos).normalized();
    //println("dir: ", dir);
    Vec2 tmpPos = peoplePos.plus(dir.times(dt*speed));
    peoplePos.x = tmpPos.x;
    peoplePos.y = tmpPos.y;
  }
  else if(posIndex < curPath.size() && (abs(peoplePos.x - nodePos[curPath.get(posIndex)].x) <= 50 && abs(peoplePos.y - nodePos[curPath.get(posIndex)].y) < 50)) {
    posIndex++;
    if(posIndex < curPath.size() && peoplePos.x != nodePos[curPath.get(posIndex)].x && peoplePos.y != nodePos[curPath.get(posIndex)].y) {
      Vec2 dir = nodePos[curPath.get(posIndex)].minus(peoplePos).normalized();
      //println("dir: ", dir);
      Vec2 tmpPos = peoplePos.plus(dir.times(dt*speed));
      peoplePos.x = tmpPos.x;
      peoplePos.y = tmpPos.y;
    }
  }
  else if(posIndex >= curPath.size() && (abs(peoplePos.x -goalPos.x) > 50 || abs(peoplePos.y - goalPos.y) > 50)) {
    Vec2 dir = goalPosition.minus(peoplePos).normalized();
    //println("dir: ", dir);
    Vec2 tmpPos = peoplePos.plus(dir.times(dt*speed));
    peoplePos.x = tmpPos.x;
    peoplePos.y = tmpPos.y;
  }
  else if(posIndex >= curPath.size() && (abs(peoplePos.x - goalPos.x) <= 50 && abs(peoplePos.y - goalPos.y) <= 50)) {
    posIndex++;
  }
  else if(abs(peoplePos.x - goalPosition.x) < 50 && abs(peoplePos.y - goalPosition.y) < 50) {
    return;
  }
  if(posIndex < curPath.size()) {
    println("position: ", peoplePos, " nodePos: ", nodePos[curPath.get(posIndex)], " goalPos: ", goalPosition);
  }
  else {
    println("position: ", peoplePos, " goalPos: ", goalPosition);
  }
  

}
