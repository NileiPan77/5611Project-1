public class Box{
    Vec2 topLeft;
    float width;
    float height;

    public Box(Vec2 topleft, float w, float h){
        this.topLeft = topleft;
        this.width = w;
        this.height = h;
    }

    public boolean pointInBox(Vec2 pointPos){
        if(this.topLeft.x < pointPos.x && pointPos.x < this.topLeft.x+this.width &&
            this.topLeft.y < pointPos.y && pointPos.y < this.topLeft.y + this.height){
                return true;
        }
        return false;
    }

    public hitInfo rayBoxIntersect(Vec2 ray_start, Vec2 ray_dir, float max_t){
        hitInfo hit = new hitInfo();
        hit.hit = true;
        
        float t_left_x, t_right_x, t_top_y, t_bot_y;
        t_left_x = (this.topLeft.x - ray_start.x)/ray_dir.x;
        t_right_x = (this.topLeft.x + this.width - ray_start.x)/ray_dir.x;
        t_top_y = (this.topLeft.y - ray_start.y)/ray_dir.y;
        t_bot_y = (this.topLeft.y + this.height - ray_start.y)/ray_dir.y;
        
        float t_max_x = max(t_left_x,t_right_x);
        float t_max_y = max(t_top_y,t_bot_y);
        float t_max = min(t_max_x,t_max_y); //When the ray exists the box
        
        float t_min_x = min(t_left_x,t_right_x);
        float t_min_y = min(t_top_y,t_bot_y);
        float t_min = max(t_min_x,t_min_y); //When the ray enters the box
        
        
        //The the box is behind the ray (negative t)
        if (t_max < 0){
            hit.hit = false;
            hit.t = t_max;
            return hit;
        }
        
        //The ray never hits the box
        if (t_min > t_max){
            hit.hit = false;
        }
        
        //The ray hits, but further out than max_t
        if (t_min > max_t){
            hit.hit = false;
        }
        
        hit.t = t_min;
        return hit;
}


}
