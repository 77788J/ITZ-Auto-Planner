public class Line {
 
  int x1;
  int y1;
  int x2;
  int y2;
  
   public Line(int x1, int y1, int x2, int y2) {
     
      this.x1 = x1;
      this.y1 = y1;
      this.x2 = x2;
      this.y2 = y2;
     
   }
   
   public float getDistance() {
     
      int dist_x = x2 - x1;
      int dist_y = y2 - y1;
      
      return sqrt((dist_x * dist_x) + (dist_y * dist_y));
     
   }
   
   public float getDir(boolean degrees) {
     
     float dir = atan2(y2 - y1, x2 - x1);
     
     if (degrees) return degrees(dir);
     else return dir;
     
   }
  
}