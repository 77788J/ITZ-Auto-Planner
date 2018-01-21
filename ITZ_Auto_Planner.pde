PImage field;
ArrayList<Line> lines;
float scale;
int scroll_offset = 0;
float current_scroll = 0f;

void setup() {
 
  field = loadImage("http://i.imgur.com/aPlzffN.jpg");
  size(1200, 800);
  frameRate(60);
  lines = new ArrayList();
  scale = 787f / 144f;
  
}

void draw() {
  
  background(0);
  image(field, 0, 0, 800, 800);
  
  stroke(0);
  fill(255);
  if (mouseX > 800) {
    stroke(0, 0, 0, 48);
    fill(255, 255, 255, 48);
  }
  for (int i = 0; i < lines.size(); i++) {
    
    Line l = lines.get(i);
    if (i > 0) {
      line(l.x1, l.y1, l.x2, l.y2);
      textSize(12);
      text(String.format(java.util.Locale.US,"%.1f\"", lines.get(i).getDistance() / scale), (l.x1 + l.x2) / 2, (l.y1 + l.y2) / 2);
    }
    
    ellipse(l.x1, l.y1, 5, 5);
    ellipse(l.x2, l.y2, 5, 5);
    
  }
  
  if (mouseX <= 800) {
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
    
    for (float i = 0; i < TWO_PI; i += TWO_PI / 45) {
      line((cos(i) * 12.7f * scale), (sin(i) * 12.7f * scale), (cos(i + TWO_PI/180) * 12.7f * scale), (sin(i + TWO_PI/180) * 12.7f * scale));
    }
    
    popMatrix();
  }
  
  noStroke();
  fill(196);
  rect(800, 0, 400, 800);
  
  pushMatrix();
  
  current_scroll += (scroll_offset - current_scroll) / 3;
  if (abs(scroll_offset - current_scroll) <= 1) current_scroll = scroll_offset;
  translate(800, current_scroll);
  
  for (int i = 0; i < lines.size(); i++) {
    
    if (i >= 1) {
      strokeWeight(2);
      stroke(180);
      fill(220);
      textSize(24);
      rect(16, 16 + (i - 1) * ( 2 * (textAscent() + textDescent()) + 32), 368, 2 * (textAscent() + textDescent()) + 16, 12);
      
      noStroke();
      fill(24);
      textSize(24);
      textAlign(LEFT, TOP);
      text(String.format(java.util.Locale.US,"%.2f\"", lines.get(i).getDistance() / scale), 32, 24 + (i - 1) * ( 2 * (textAscent() + textDescent()) + 32));
      text(String.format(java.util.Locale.US,"%.1f°", lines.get(i).getDir(true)), 32, 24 + (i - 1) * ( 2 * (textAscent() + textDescent()) + 32) + textAscent() + textDescent());
      
      if (mouseX > 800 && mouseY - current_scroll > (i - 1) * (2 * (textAscent() + textDescent()) + 32) && mouseY - current_scroll < i * (2 * (textAscent() + textDescent()) + 32)) {
        stroke(0);
        Line l = lines.get(i);
        line(l.x1 - 800, l.y1 - current_scroll, l.x2 - 800, l.y2 - current_scroll);
        fill(255);
        textSize(12);
        text(String.format(java.util.Locale.US,"%.1f\"", lines.get(i).getDistance() / scale), (l.x1 + l.x2) / 2 - 800, (l.y1 + l.y2) / 2 - current_scroll);
        strokeWeight(4);
        stroke(0, 0, 0, 64);
        fill(255, 255, 255, 100);
        textSize(24);
        rect(16, 16 + (i - 1) * ( 2 * (textAscent() + textDescent()) + 32), 368, 2 * (textAscent() + textDescent()) + 16, 12);
      }
    }
  }
  
  popMatrix();
  strokeWeight(1);
}

void mouseClicked() {
  
  if (mouseX <= 800) {
  
    if (lines.size() > 0) {
      Line last = lines.get(lines.size() - 1);
      lines.add(new Line(last.x2, last.y2, mouseX, mouseY));
    }
    
    else {
      lines.add(new Line(-10, -10, mouseX, mouseY));
    }
  }
}

void keyPressed() {
  if (key == 'z') {
    lines.remove(lines.size() - 1);
  }
}

void mouseWheel(MouseEvent event) {
  
  float dist = event.getCount();
  
  scroll_offset -= dist * 50;
  
}