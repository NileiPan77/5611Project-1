public class Circle{
    Vec2 center;
    float radius;
    
    public main(Vec2 center, float r){
        this.center = center;
        this.radius = r;
    }

    public boolean pointInCircle(Vec2 pointPos, float eps){
        float dist = pointPos.distanceTo(this.center);
        if (dist < this.radius+eps){
            return true;
        }
        return false;
    }
    
    public hitInfo rayCircleIntersect(Vec2 l_start, Vec2 l_dir, float max_t, float eps){
        hitInfo hit = new hitInfo();
        radius += eps+2;
        //Step 2: Compute W - a displacement vector pointing from the start of the line segment to the center of the circle
        Vec2 toCircle = this.center.minus(l_start);
        
        //Step 3: Solve quadratic equation for intersection point (in terms of l_dir and toCircle)
        float a = 1;  //Length of l_dir (we normalized it)
        float b = -2*dot(l_dir,toCircle); //-2*dot(l_dir,toCircle)
        float c = toCircle.lengthSqr() - (this.radius + eps)*(this.radius + eps); //different of squared distances
        
        float d = b*b - 4*a*c; //discriminant 
        
        if (d >=0 ){ 
            //If d is positive we know the line is colliding, but we need to check if the collision line within the line segment
            //  ... this means t will be between 0 and the length of the line segment
            float t1 = (-b - sqrt(d))/(2*a); //Optimization: we only need the first collision
            float t2 = (-b + sqrt(d))/(2*a); //Optimization: we only need the first collision
            //println(hit.t,t1,t2);
            if (t1 > 0 && t1 < max_t){
                hit.hit = true;
                hit.t = t1;
            }
            else if (t1 < 0 && t2 > 0){
                hit.hit = true;
                hit.t = -1;
            }
        
        }
        
        return hit;
    }
}