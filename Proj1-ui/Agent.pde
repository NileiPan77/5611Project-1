public class Agent{
    Vec2 vel;
    Vec2 pos;
    Vec2 acc;
    Vec2 goal;
    ArrayList<Vec2> path;
    int pathIndex;
    int visibleIndex;
    int id;


    public main(Vec2 velocity, Vec2 Position, Vec2 goal, ArrayList<Vec2> p, int id){
        this.path = p;
        this.vel = velocity;
        this.pos = Position;
        this.acc = new Vec2(0,0);
        this.goal = goal;
        this.pathIndex = 0;
        this.visibleIndex = 0;
        this.id = id;
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

    public void setPath(Vec2 path){
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

    public void computeAgentForces(ArrayList<Agent> agents){
        Vec2 goal_vel = this.path.get(this.pathIndex);
        Vec2 goal_acc = goal_vel.minus(this.vel).times(k_goal);
        
        //TODO: computeTTC
        for(int i = 0; i < agents.size(); i++){

        }
        this.acc = goal_acc;
    }

    public void checkVisibleNodes(){
        Vec2 currentNode = path.get(pathIndex);
        Vec2 rayToNextNode = this.pathIndex+1 < this.path.size() ? path.get(pathIndex+1).minus(this.pos) : null;
        
        if(rayToNextNode == null){
            return;
        }
        //TODO: Finish intersection test
        float distBetween = this.pos.distanceTo(path.get(pathIndex+1));
        hitInfo hit = allObstacles.rayCircleListIntersect(this.pos,rayToNextNode,distBetween,startAgentRadius).hit;
        while(rayToNextNode && !hit.hit){
            this.pathIndex++;
            rayToNextNode = this.pathIndex+1 < this.path.size() ? path.get(pathIndex).minus(this.pos) : null;
            hit = allObstacles.rayCircleListIntersect(this.pos,rayToNextNode,distBetween,startAgentRadius).hit;
        }
    }
    public void update(float dt,ArrayList<Agent> agents){
        if(this.path.size() > 0 && this.path.get(0) == -1){
            return;
        }
        if(this.pathIndex >= this.path.size()){
            return;
        }
        this.checkVisibleNodes();
        this.computeAgentForces(agents);
        this.vel.add(this.acc.times(dt));
        this.pos.add(this.vel.times(dt));

    }
}