public class Obstacles{
    public ArrayList<Circle> circles;
    public ArrayList<Box> boxes;

    public Obstacles(ArrayList<Circle> c, ArrayList<Box> b){
        this.circles = c;
        this.boxes = b;
    }
    
    public boolean pointInCircleList(Vec2 pointPos, float eps){
      for (int i = 0; i < circles.size(); i++){
        if(circles.get(i).pointInCircle(pointPos,eps)){
          return true;
        }
      }
      return false;
    }
    
    public boolean pointInBoxList(Vec2 pointPos){
      for(int i = 0; i < boxes.size(); i++){
         if(boxes.get(i).pointInBox(pointPos)){
             return true;
         }
      }
      return false;
    }
    public hitInfo rayCircleListIntersect(Vec2 ray_start, Vec2 ray_dir, float max_t, float eps){
        hitInfo hit = new hitInfo();
        hit.t = max_t;
        for(int i = 0; i < this.circles.size(); i++){
            hitInfo circleHit = this.circles.get(i).rayCircleIntersect(ray_start, ray_dir,hit.t,eps);
            if (circleHit.t > 0 && circleHit.t < hit.t){
                hit.hit = true;
                hit.t = circleHit.t;
            }
            else if (circleHit.hit && circleHit.t < 0){
                hit.hit = true;
                hit.t = -1;
            }
        }
        
        return hit;
    }
    public hitInfo rayBoxesIntersect(Vec2 ray_start, Vec2 ray_dir, float max_t){
        hitInfo hit = new hitInfo();
        hit.t = max_t;
        for (int i = 0; i < this.boxes.size(); i++){
            hitInfo boxHit = this.boxes.get(i).rayBoxIntersect(ray_start, ray_dir, hit.t);
            if (boxHit.t > 0 && boxHit.t < hit.t){
                hit.hit = true;
                hit.t = boxHit.t;
            }
            else if (boxHit.hit && boxHit.t < 0){
                hit.hit = true;
                hit.t = -1;
            }
        }
        
        return hit;
    }
    public hitInfo rayObstacleIntersection(Vec2 ray_start, Vec2 ray_dir, float max_t, float eps){
        hitInfo hitCircles = this.rayCircleListIntersect(ray_start, ray_dir, max_t,eps);
        hitInfo hitBoxes = this.rayBoxesIntersect(ray_start, ray_dir, max_t);
        if(hitBoxes.hit && hitCircles.hit){
            return hitBoxes.t < hitCircles.t ? hitBoxes : hitCircles;
        }else if(hitCircles.hit){
            return hitCircles;
        }
        return hitBoxes;
    }
}
