Camera camera;
PImage spriteBlue;
PImage spriteRed;
PImage greenLand;

PVector[] positions;

void setup()
{
  size(600, 600, P3D);
  
  // Create a new camera and move it back in space to fit all quads in view.
  camera = new Camera();
  camera.position = new PVector(0,25,0);
  
  // Load in our sprites.
  spriteRed = loadImage("sprite_red.png");
  spriteBlue = loadImage("sprite_blue.png");
  greenLand = loadImage("Preview.jpg");
  println(greenLand.width, " ", greenLand.height);
  
  // Pick random positions to draw our quads in.
  positions = new PVector[250];
  for (int i = 0; i < positions.length; i++)
  {
    positions[i] = new PVector(random(-5, 5), random(-5, 5), random(-20,20));
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
  camera.update(1.0/frameRate);
  
  directionalLight(255.0, 255.0, 255.0, -1, 1, -1);
  
  // for (PVector pos : positions)
  // {
  //    drawTexturedQuad(pos, 1.0f, spriteBlue);
  // }

  // PVector pos = positions[0];
  // drawTexturedQuad(pos, 1.0f, spriteBlue);

  PVector pos = new PVector(0,0,0);
  drawTexturedQuad(pos, 1.0f, greenLand);

}
