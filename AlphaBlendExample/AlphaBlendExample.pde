Camera camera;
PImage spriteBlue;
PImage spriteRed;

PVector[] positions;
PVector startPos;
PVector goalPos;
float radius = 1.0f;
float stroke = 2.0;


void setup()
{
  size(600, 600, P3D);
  
  // Create a new camera and move it back in space to fit all quads in view.
  camera = new Camera();
  camera.position = new PVector(0,0,25);
  
  // Load in our sprites.
  spriteRed = loadImage("sprite_red.png");
  spriteBlue = loadImage("sprite_blue.png");
  
  // Pick random positions to draw our quads in.
  positions = new PVector[250];
  for (int i = 0; i < positions.length; i++)
  {
    positions[i] = new PVector(random(-5, 5), random(-5, 5), random(-20,20));
  }
  
  startPos = new PVector(random(-5, 5), random(-5, 5), random(-2, 20));
  boolean insideAnyObsticle = goalInObsticlesList(positions, radius, 250, startPos, 0.05f);
  while(insideAnyObsticle) {
    startPos = new PVector(random(-5, 5), random(-5, 5), random(-2, 20));
    insideAnyObsticle = goalInObsticlesList(positions, radius, 250, startPos, 0.05f);
  }
  goalPos = new PVector(random(-5, 5), random(-5, 5), random(-20, 20));
  insideAnyObsticle = goalInObsticlesList(positions, radius, 250, goalPos, 0.05f);
  while(insideAnyObsticle) {
    goalPos = new PVector(random(-5, 5), random(-5, 5), random(-20, 20));
    insideAnyObsticle = goalInObsticlesList(positions, radius, 250, goalPos, 0.05f);
  }

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

}

boolean goalInObsticles(PVector obsticle, float r, PVector goal, float eps) {
  float dist = obsticle.dist(goal);
  if(dist < r*2+eps) {
    return true;
  }
  return false;
}

boolean goalInObsticlesList(PVector[] obsticles, float radius, int numObsticles, PVector goal, float eps) {
  for(int i = 0; i < numObsticles; i++) {
    PVector obsticle = obsticles[i];
    float r = radius;
    if(goalInObsticles(obsticle, r, goal, eps)) {
      return true;
    }
  }
  return false;
}

class hitInfo{
  public boolean hit = false;
  public float t = 9999999;
}

hitInfo rayBallIntersect(PVector center, float r, PVector l_start, PVector l_dir, float max_t, float eps) {
  hitInfo hit = new hitInfo();
  r = r*2;
  r += eps;

  PVector toBall = new PVector();
  toBall = center.copy();
  toBall.sub(l_start);

  float a = 1;
  PVector tmpL_dir = new PVector();
  tmpL_dir = l_dir.copy();
  float b = -2*tmpL_dir.dot(toBall);
  float c = toBall.magSq() - (r+stroke)*(r+stroke);

  float d = b*b-4*a*c;

  if(d >= 0) {
    float t1 = (-b - sqrt(d)) / (2*a);
    float t2 = (-b + sqrt(d)) / (2*a);

    if(t1 > 0 && t1 < max_t) {
      hit.hit = true;
      hit.t = t1;
    }
    else if(t1 < 0 && t2 > 0) {
      hit.hit = true;
      hit.t = -1;
    }
  }

  return  hit;
}

hitInfo rayBallListIntersect(PVector[] centers, float r, int numObsticles, PVector l_start, PVector l_dir, float max_t, float eps) {
  hitInfo hit = new hitInfo();
  hit.t = max_t;
  for(int i = 0; i < numObsticles; i++) {
    PVector center = centers[i].copy();

    hitInfo BallHit = rayBallIntersect(center, r, l_start, l_dir, hit.t, eps);
    if(BallHit.t > 0 && BallHit.t < hit.t) {
      hit.hit = true;
      hit.t = BallHit.t;
    }
    else if(BallHit.hit && BallHit.t < 0) {
      hit.hit = true;
      hit.t = -1;
    }
  }
  return hit;
} 

void keyPressed()
{
  camera.HandleKeyPressed();
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
  camera.Update(1.0/frameRate);
  
  directionalLight(255.0, 255.0, 255.0, -1, 1, -1);
  
  for (PVector pos : positions)
  {
     drawTexturedQuad(pos, 1.0f, spriteBlue);
  }

  drawTexturedQuad(startPos, 1.0f, spriteRed);
  drawTexturedQuad(goalPos, 1.0f, spriteRed);
}
