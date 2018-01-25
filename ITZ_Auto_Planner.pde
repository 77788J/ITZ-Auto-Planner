PImage field;
ArrayList<Line> lines;
float scale;
int scroll_offset = 0;
int min_dim;
float current_scroll = 0f;
int initial_size;
float draw_scale = 1;

void setup() {
 
  field = loadImage("http://i.imgur.com/aPlzffN.jpg");
  size(900, 600);
  surface.setResizable(true);
  frameRate(60);
  lines = new ArrayList();
  min_dim = min(width, height);
  initial_size = min_dim;
  scale = (min_dim * 0.98375f) / 144f;
  
}

void draw() {
  
  min_dim = min(width, height);
  scale = (min_dim * 0.98375f) / 144f;
  draw_scale = (float) min_dim /(float) initial_size;
  
  background(196);
  image(field, 0, 0, min_dim, min_dim);
  
  stroke(0);
  fill(255);
  if (mouseX > min_dim) {
    stroke(0, 0, 0, 48);
    fill(255, 255, 255, 48);
  }
  for (int i = 0; i < lines.size(); i++) {
    
    Line l = lines.get(i);
    if (i > 0) {
      line((l.x1 * draw_scale), (l.y1 * draw_scale), (l.x2 * draw_scale), (l.y2 * draw_scale));
      textSize(12);
      text(String.format(java.util.Locale.US,"%.1f\"", (lines.get(i).getDistance() * draw_scale) / scale), ((l.x1 * draw_scale) + (l.x2 * draw_scale)) / 2, ((l.y1 * draw_scale) + (l.y2 * draw_scale)) / 2);
    }
    
    ellipse((l.x1 * draw_scale), (l.y1 * draw_scale), 5, 5);
    ellipse((l.x2 * draw_scale), (l.y2 * draw_scale), 5, 5);
    
  }
  
  if (mouseX <= min_dim) {
    pushMatrix();
    stroke(0, 0, 0, 100);
    noFill();
    translate(mouseX, mouseY);
    
    if (lines.size() > 0) {
      Line last = lines.get(lines.size() - 1);
      Line new_pos = new Line(last.x2, last.y2, round(mouseX / draw_scale), round(mouseY / draw_scale));
      line((last.x2 * draw_scale) - mouseX, (last.y2 * draw_scale) - mouseY, 0, 0);
      rotate(new_pos.getDir(false));
    }
    
    rect(-9 * scale, -9 * scale, 18 * scale, 18 * scale);
    
    for (float i = 0; i < TWO_PI; i += TWO_PI / 45) {
      line((cos(i) * 12.7f * scale), (sin(i) * 12.7f * scale), (cos(i + TWO_PI/180) * 12.7f * scale), (sin(i + TWO_PI/180) * 12.7f * scale));
    }
    
    popMatrix();
  }
  
  if (width - 128> height) {
    noStroke();
    fill(196);
    rect(min_dim, 0, width - min_dim, height);
    
    pushMatrix();
    
    current_scroll += (scroll_offset - current_scroll) / 3;
    if (abs(scroll_offset - current_scroll) <= 1) current_scroll = scroll_offset;
    translate(min_dim, current_scroll);
    
    for (int i = 0; i < lines.size(); i++) {
      
      if (i >= 1) {
        strokeWeight(2);
        stroke(180);
        fill(220);
        textSize(24);
        rect(16, 16 + (i - 1) * ( 2 * (textAscent() + textDescent()) + 32), width - min_dim - 32, 2 * (textAscent() + textDescent()) + 16, 12);
        
        noStroke();
        fill(24);
        textSize(24);
        textAlign(LEFT, TOP);
        float dir = lines.get(i).getDir(true) - lines.get(i - 1).getDir(true);
        if (dir > 180) dir -= 360;
        if (dir < -180) dir += 360;
        if (i <= 1) dir = 0;
        text(String.format(java.util.Locale.US,"%.2f\"", (lines.get(i).getDistance() * draw_scale) / scale), 32, 24 + (i - 1) * ( 2 * (textAscent() + textDescent()) + 32));
        text(String.format(java.util.Locale.US,"%.1f°", dir), 32, 24 + (i - 1) * ( 2 * (textAscent() + textDescent()) + 32) + textAscent() + textDescent());
        
        if (mouseX > min_dim && mouseY - current_scroll > (i - 1) * (2 * (textAscent() + textDescent()) + 32) && mouseY - current_scroll < i * (2 * (textAscent() + textDescent()) + 32)) {
          stroke(0);
          Line l = lines.get(i);
          line((l.x1 * draw_scale) - min_dim, (l.y1 * draw_scale) - current_scroll, (l.x2 * draw_scale) - min_dim, (l.y2 * draw_scale) - current_scroll);
          fill(255);
          textSize(12);
          text(String.format(java.util.Locale.US,"%.1f\"", (lines.get(i).getDistance() * draw_scale) / scale), ((l.x1 * draw_scale) + (l.x2 * draw_scale)) / 2 - min_dim, ((l.y1 * draw_scale) + (l.y2 * draw_scale)) / 2 - current_scroll);
          strokeWeight(4);
          stroke(0, 0, 0, 64);
          fill(255, 255, 255, 100);
          textSize(24);
          rect(16, 16 + (i - 1) * ( 2 * (textAscent() + textDescent()) + 32), width - min_dim - 32, 2 * (textAscent() + textDescent()) + 16, 12);
        }
      }
    }
    
    popMatrix();
    strokeWeight(1);
  }
}

void mouseClicked() {
  
  if (mouseX <= 800) {
  
    if (lines.size() > 0) {
      Line last = lines.get(lines.size() - 1);
      lines.add(new Line(last.x2, last.y2, round(mouseX / draw_scale), round(mouseY / draw_scale)));
    }
    
    else {
      lines.add(new Line(round(mouseX / draw_scale), round(mouseY / draw_scale), round(mouseX / draw_scale), round(mouseY / draw_scale)));
    }
  }
}

void keyPressed() {
  if (key == 'z' && lines.size() > 0) {
    lines.remove(lines.size() - 1);
  }
}

void mouseWheel(MouseEvent event) {
  
  float dist = event.getCount();
  
  scroll_offset -= dist * 50;
  
  textSize(25);
  int m = -round(-24 + (lines.size() - 1) * ( 2 * (textAscent() + textDescent()) + 32) + textAscent() + textDescent()) + height;
  if (scroll_offset < m) scroll_offset = m;
  if (scroll_offset > 0) scroll_offset = 0;
  
}