float k_goal = 1.4;
float k_avoid = 60;
float goalSpeed = 50;

public Vec2 calPointA(Vec2 center, float side){
    return new Vec2(center.x,center.y-0.577*side);
}

public Vec2 calPointB(Vec2 center, float side){
    return new Vec2(center.x-side*0.5,center.y+0.289*side);
}

public Vec2 calPointC(Vec2 center, float side){
    return new Vec2(center.x+side*0.5,center.y+0.289*side);
}
public class agent{
    Vec2 vel;
    Vec2 pos;
    //For triangle
    Vec2 posA;
    Vec2 posB;
    Vec2 posC;

    Vec2 acc;
    Vec2 goal;
    ArrayList<Vec2> path;
    ArrayList<Integer> neighbors;
    int pathIndex;
    int visibleIndex;
    int goalIndex;
    int myIndex;
    int id;
    
    float radius;
    //Triangle length
    float side;

    public agent(Vec2 Position, Vec2 goal, int goalID, ArrayList<Vec2> p, int id){
        this.path = p;
        this.vel = goal.minus(Position);
        if(this.vel.length() > 0){
            this.vel.setToLength(goalSpeed);
        }
        this.pos = Position;
        this.side = 17.3;
        this.acc = new Vec2(0,0);
        this.goal = goal;
        this.goalIndex = goalID;
        this.pathIndex = 0;
        this.visibleIndex = 0;
        this.id = id;
        this.radius = 20;
        this.neighbors = new ArrayList<Integer>();
    }

    public void setVel(Vec2 velocity){
        this.vel = velocity;
    }

    public void setPos(Vec2 position){
        this.pos = position;
    }

    public void setAcc(Vec2 acceleration){
        this.acc = acceleration;
    }

    public void setGoal(Vec2 goal){
        this.goal = goal;
    }

    public void setPath(ArrayList<Vec2> path){
        this.path = path;
    }

    public Vec2 getVel(){
        return this.vel;
    }

    public Vec2 getPos(){
        return this.pos;
    }
    
    public Vec2 getAcc(){
        return this.acc;
    }

    public Vec2 getGoal(){
        return this.goal;
    }

    public ArrayList<Vec2> getPath(){
        return this.path;
    }
    
    public float computeTTC(Vec2 pos2, Vec2 vel2, float radius2){
        return this.rayCircleIntersectTime(pos2,radius2+this.radius,this.pos,this.vel.minus(vel2));
    }
    public void computeAgentForces(ArrayList<agent> agents){
        Vec2 goal_vel = this.path.get(this.pathIndex).minus(this.pos);
        Vec2 goal_acc = goal_vel.minus(this.vel).times(k_goal);
        
        //TODO: computeTTC
        for(int i = 0; i < agents.size(); i++){
            if(i != this.id){
                float ttc = computeTTC(agents.get(i).pos,agents.get(i).vel,agents.get(i).radius);
                if(ttc > 0){
                    Vec2 idPos =  this.pos.plus(this.vel.times(ttc));
                    Vec2 iPos =  agents.get(i).pos.plus(agents.get(i).vel.times(ttc));
                    Vec2 fDir = (idPos.minus(iPos)).normalized();
                    goal_acc.add(fDir.times(k_avoid * (1/ttc)));
                }
            }
            
        }
        
        for(int i = 0; i < allObstacles.circles.size(); i++){
            if(i != id){
                float ttc = computeTTC(allObstacles.circles.get(i).center,new Vec2(0,0),allObstacles.circles.get(i).radius);
                if(ttc > 0){
                    Vec2 idPos =  this.pos.plus(this.vel.times(ttc));
                    Vec2 iPos =  allObstacles.circles.get(i).center;
                    Vec2 fDir = (idPos.minus(iPos)).normalized();
                    goal_acc.add(fDir.times(k_avoid * (1/ttc)));
                }
            }
        }
        this.acc = goal_acc;
    }

    public void checkVisibleNodes(){
        if(pathIndex >= this.path.size()){
           return; 
        }
        Vec2 rayToNextNode = this.pathIndex+1 < this.path.size() ? this.path.get(this.pathIndex+1).minus(this.pos).normalized() : null;
        
        if(rayToNextNode == null){
            return;
        }
        //TODO: Finish intersection test
        float distBetween = this.pos.distanceTo(path.get(pathIndex+1));
        hitInfo hit = allObstacles.rayCircleListIntersect(this.pos,rayToNextNode,distBetween,startAgentRadius);
        while(!hit.hit){
            this.pathIndex++;
            rayToNextNode = this.pathIndex+1 < this.path.size() ? this.path.get(this.pathIndex+1).minus(this.pos).normalized() : null;
            if(rayToNextNode == null){
                break; 
            }
            hit = allObstacles.rayCircleListIntersect(this.pos,rayToNextNode,distBetween,startAgentRadius);
        }
    }
    
    float rayCircleIntersectTime(Vec2 center, float r, Vec2 l_start, Vec2 l_dir){
        //Compute displacement vector pointing from the start of the line segment to the center of the circle
        Vec2 toCircle = center.minus(l_start);
    
        //Solve quadratic equation for intersection point (in terms of l_dir and toCircle)
        float a = l_dir.length()*l_dir.length();
        float b = -2*dot(l_dir,toCircle); //-2*dot(l_dir,toCircle)
        float c = toCircle.lengthSqr() - (r*r); //different of squared distances
        
        float d = b*b - 4*a*c; //discriminant
        
        if (d >=0 ){
            //If d is positive we know the line is colliding
            float t = (-b - sqrt(d))/(2*a); //Optimization: we typically only need the first collision!
            float t2 = (-b + sqrt(d))/(2*a);
            if(Math.signum(t) != Math.signum(t2)){
                return 0.01;
            }
            if (t >= 0) return t;
            return -1;
        }
        
        return -1; //We are not colliding, so there is no good t to return
    }
    
    public void drawAgent(){
        stroke(100,100,100);
        strokeWeight(1);
        fill(20,60,250);
        pushMatrix();
        translate(this.pos.x,this.pos.y);
        Vec2 dir = this.vel.normalized();
        rotate(atan2(dir.y,dir.x));
        triangle(-10, -13, -10, 13, 17, 0);
        popMatrix();  
    }

    public void draw3DAgent(){
        // stroke(100,100,100);
        // strokeWeight(1);
        // fill(20,60,250);
        // pushMatrix();
        // translate(this.pos.x,this.pos.y);
        // Vec2 dir = this.vel.normalized();
        // rotate(atan2(dir.y,dir.x));
        // triangle(-10, -13, -10, 13, 17, 0);
        // popMatrix();
        fill(20,60,250);
        noStroke();
        pushMatrix();
        translate(this.pos.x, this.pos.y, this.radius);
        sphere(this.radius/2);
        popMatrix();

        fill(250,30,50);
        noStroke();
        pushMatrix();
        translate(this.goal.x, this.goal.y, this.radius);
        sphere(this.radius/2);
        popMatrix();
    }

    public void update(float dt){
        if(this.path.size() > 0 && this.path.get(0).x == -1){
            return;
        }
        if(this.pathIndex >= this.path.size()){
            return;
        }
        this.checkVisibleNodes();
        this.computeAgentForces(agentList);
        
        this.vel.add(this.acc.times(dt));
        if(this.vel.length() > 50){
           this.vel.setToLength(50);
        }
        if(this.pathIndex != this.path.size()-1 && this.pos.distanceTo(this.path.get(this.pathIndex)) < this.vel.times(dt*5).length()){
             this.pathIndex++;
        }
        this.pos.add(this.vel.times(dt));
    }
}
