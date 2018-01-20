PImage field;
ArrayList<Line> lines;
float scale;

void setup() {
 
  field = loadImage("http://i.imgur.com/aPlzffN.jpg");
  size(800, 800);
  frameRate(60);
  lines = new ArrayList();
  scale = 787f / 144f;
  
}

void draw() {
  
  background(0);
  image(field, 0, 0, 800, 800);
  
  stroke(0);
  fill(255);
  for (int i = 0; i < lines.size(); i++) {
    
    Line l = lines.get(i);
    if (i > 0) {
      line(l.x1, l.y1, l.x2, l.y2);
      text(l.getDistance() / scale, (l.x1 + l.x2) / 2, (l.y1 + l.y2) / 2);
    }
    
    ellipse(l.x1, l.y1, 5, 5);
    ellipse(l.x2, l.y2, 5, 5);
    
  }
  
  pushMatrix();
  stroke(0, 0, 0, 100);
  noFill();
  translate(mouseX, mouseY);
  
  if (lines.size() > 0) {
    Line last = lines.get(lines.size() - 1);
    Line new_pos = new Line(last.x2, last.y2, mouseX, mouseY);
    line(last.x2 - mouseX, last.y2 - mouseY, 0, 0);
    rotate(new_pos.getDir(false));
  }
  
  rect(-9 * scale, -9 * scale, 18 * scale, 18 * scale);
  popMatrix();
  
}

void mouseClicked() {
  
  if (lines.size() > 0) {
    Line last = lines.get(lines.size() - 1);
    lines.add(new Line(last.x2, last.y2, mouseX, mouseY));
  }
  
  else {
    lines.add(new Line(-10, -10, mouseX, mouseY));
  }
  
}

void keyPressed() {
  
  if (key == 'z') {
    
    lines.remove(lines.size() - 1);
    
  }
  
}