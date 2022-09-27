public class Obstacles{
    public ArrayList<Circle> circles;
    public ArrayList<Box> boxes;

    public main(ArrayList<Circle> c, ArrayList<Box> b){
        this.circles = c;
        this.boxes = b;
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
        return hit
    }
    public hitInfo rayBoxesIntersect(Vec2 ray_start, Vec2 ray_dir, float max_t){
        hitInfo hit = new hitInfo();
        hit.t = max_t;
        for (int i = 0; i < this.boxes.size(); i++){
            hitInfo boxHit = this.boxes.rayBoxIntersect(ray_start, ray_dir, hit.t);
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
    public boolean rayObstacleIntersection(Vec2 ray_start, Vec2 ray_dir, float max_t, float eps){
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