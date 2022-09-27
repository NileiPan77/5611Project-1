//You will only be turning in this file
//Your solution will be graded based on it's runtime (smaller is better), 
//the optimality of the path you return (shorter is better), and the
//number of collisions along the path (it should be 0 in all cases).

//You must provide a function with the following prototype:
// ArrayList<Integer> planPath(Vec2 startPos, Vec2 goalPos, Vec2[] centers, float[] radii, int numObstacles, Vec2[] nodePos, int numNodes);
// Where: 
//    -startPos and goalPos are 2D start and goal positions
//    -centers and radii are arrays specifying the center and radius of obstacles
//    -numObstacles specifies the number of obstacles
//    -nodePos is an array specifying the 2D position of roadmap nodes
//    -numNodes specifies the number of nodes in the PRM
// The function should return an ArrayList of node IDs (indexes into the nodePos array).
// This should provide a collision-free chain of direct paths from the start position
// to the position of each node, and finally to the goal position.
// If there is no collision-free path between the start and goal, return an ArrayList with
// the 0'th element of "-1".

// Your code can safely make the following assumptions:
//   - The function connectNeighbors() will always be called before planPath()
//   - The variable maxNumNodes has been defined as a large static int, and it will
//     always be bigger than the numNodes variable passed into planPath()
//   - None of the positions in the nodePos array will ever be inside an obstacle
//   - The start and the goal position will never be inside an obstacle

// There are many useful functions in CollisionLibrary.pde and Vec2.pde
// which you can draw on in your implementation. Please add any additional 
// functionality you need to this file (PRM.pde) for compatabilty reasons.

// Here we provide a simple PRM implementation to get you started.
// Be warned, this version has several important limitations.
// For example, it uses BFS which will not provide the shortest path.
// Also, it (wrongly) assumes the nodes closest to the start and goal
// are the best nodes to start/end on your path on. Be sure to fix 
// these and other issues as you work on this assignment. This file is
// intended to illustrate the basic set-up for the assignmtent, don't assume 
// this example funcationality is correct and end up copying it's mistakes!).

public class Pair {
  public int x;
  public float y;
}

//Here, we represent our graph structure as a neighbor list
//You can use any graph representation you like
ArrayList<Pair>[] neighbors = new ArrayList[maxNumNodes];   //A list of neighbors can can be reached from a given node
//We also want some help arrays to keep track of some information about nodes we've visited
Boolean[] visited = new Boolean[maxNumNodes]; //A list which store if a given node has been visited
int[] parent = new int[maxNumNodes]; //A list which stores the best previous node on the optimal path to reach this node
int startAgentRadius = 10;
int minDistance = 99999;
float[] distanceToGoal = new float[maxNumNodes];
boolean[] reach = new boolean[maxNumNodes];
HashMap<Integer, Float> dist = new HashMap<Integer, Float>();
HashMap<Integer, Integer> prev = new HashMap<Integer, Integer>();
ArrayList<Integer> q = new ArrayList<Integer> ();
int finalIndex = -1;

//Set which nodes are connected to which neighbors (graph edges) based on PRM rules
void connectNeighbors(Vec2[] centers, float[] radii, int numObstacles, Vec2[] nodePos, int numNodes){
  for (int i = 0; i < numNodes; i++){
    neighbors[i] = new ArrayList<Pair>();  //Clear neighbors list
    distanceToGoal[i] = nodePos[i].distanceTo(goalPos);
    for (int j = 0; j < numNodes; j++){
      if (i == j) continue; //don't connect to myself 
      Vec2 dir = nodePos[j].minus(nodePos[i]).normalized();
      float distBetween = nodePos[i].distanceTo(nodePos[j]);
      hitInfo circleListCheck = rayCircleListIntesect(centers, radii, nodePos[i], dir, distBetween);
      if (!circleListCheck.hit){
        Pair tmp = new Pair();
        tmp.x = j;
        tmp.y = distBetween;
        neighbors[i].add(tmp);
      }
    }
    reach[i] = false;
  }

  for(int i = 0; i < maxNumNodes; i++) {
      dist.put(i, 999999.0);
      prev.put(i, -1);
      q.add(i);
  }

  for(int i = 0; i < numNodes; i++) {
    Vec2 dir = nodePos[i].minus(startPos).normalized();
    float distBetween = nodePos[i].distanceTo(startPos);
    Vec2 dir2 = goalPos.minus(nodePos[i]).normalized();
    float distBetween2 = nodePos[i].distanceTo(goalPos);
    hitInfo circleListCheck = rayCircleListIntesect(centers, radii, startPos, dir, distBetween);
    hitInfo circleListCheck2 = rayCircleListIntesect(centers, radii, nodePos[i], dir2, distBetween2);
    if (!circleListCheck.hit){
      dist.put(i, distBetween);
    }
    if (!circleListCheck2.hit) {
      reach[i] = true;
    }
  }
}

//This is probably a bad idea and you shouldn't use it...
int closestNode(Vec2[] centers, float[] radii, Vec2 point, Vec2[] nodePos, int numNodes){
  int closestID = -1;
  float minDist = 999999;
  for (int i = 0; i < numNodes; i++){
    float dist = nodePos[i].distanceTo(point);
    Vec2 dir = point.minus(nodePos[i]).normalized();
    float distBetween = nodePos[i].distanceTo(point);
    hitInfo circleListCheck = rayCircleListIntesect(centers, radii, nodePos[i], dir, distBetween);
    if (dist < minDist && !circleListCheck.hit){
      closestID = i;
      minDist = dist;
    }
  }
  return closestID;
}

ArrayList<Integer> planPath(Vec2 startPos, Vec2 goalPos, Vec2[] centers, float[] radii, int numObstacles, Vec2[] nodePos, int numNodes){
  ArrayList<Integer> path = new ArrayList();
  
  Vec2 dir = startPos.minus(goalPos).normalized();
  float distBetween = goalPos.distanceTo(startPos);
  hitInfo circleListCheck = rayCircleListIntesect(centers, radii, goalPos, dir, distBetween);
  if(!circleListCheck.hit) {
    return path;
  }
  
  path = runBFS(nodePos, numNodes, centers, radii);
  
  
  return path;
}

//BFS (Breadth First Search)
HashMap<Integer, Integer> dijkstra(ArrayList<Pair>[] neighbors, Vec2[] centers, float[] radii) {
  long startTime, endTime;
  
  while(q.size() != 0) {
      float min = 99999;
      int index = -1;
      int ind = -1;
      startTime = System.nanoTime();
      for(int i = 0; i < q.size(); i++) {
          if(min > dist.get(q.get(i))+distanceToGoal[q.get(i)]) {
            min = dist.get(q.get(i))+distanceToGoal[q.get(i)];
            index = q.get(i);
            ind = i;
          }
      }
      if(index == -1) {
        return prev;
      }
      endTime = System.nanoTime();
      println(" Time (us):", int((endTime-startTime)/1000));
      q.remove(ind);
      
      for(int j = 0; j < neighbors[index].size(); j++) {
          float alt = dist.get(index) + neighbors[index].get(j).y;
          if(alt < dist.get(neighbors[index].get(j).x)) {
              dist.put(neighbors[index].get(j).x, alt);
              prev.put(neighbors[index].get(j).x, index);
          }
      }
    
    if(reach[index]) {
      println("code goes here"); 
      finalIndex = index;
      return prev;
    }
  }
    
  
  return prev;
}

ArrayList<Integer> runBFS(Vec2[] nodePos, int numNodes, Vec2[] centers, float[] radii) {
  HashMap<Integer, Integer> prev = dijkstra(neighbors, centers, radii);
  int next = prev.get(finalIndex);
  ArrayList<Integer> path = new ArrayList<Integer>();
  if(finalIndex == -1) {
    return path;
  }
  ArrayList<Integer> pathTmp = new ArrayList<Integer>();
  pathTmp.add(finalIndex);
  while(next != -1) {
    pathTmp.add(next);
    next = prev.get(next);
  }
  for(int i = pathTmp.size()-1; i >= 0; i--) {
    path.add(pathTmp.get(i));
  }
  return path;
}
