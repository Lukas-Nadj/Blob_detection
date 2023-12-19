import processing.video.*;
Capture video;
ArrayList<Blob> blobs = new ArrayList<Blob>();

Boolean bo = true;

color targetMin = color(23, 20, 40);
color targetMax = color(43, 100, 100);

void setup() {
  size(832, 624);
  video = new Capture(this);
  video.start();
  colorMode(HSB, 100);
  targetMin = color(23, 50, 50);
  targetMax = color(43, 100, 100);
  noStroke();
  frameRate(30);
}

void captureEvent(Capture video) {
  video.read();
}

void draw() {
  background(255);
  scale(-1, 1);
  if (bo) {
    image(video, -width, 0, width, height);
  }
  translate(-width, 0);
  println(blobs.size());
  loadPixels();
  PVector avgPos = findBlobs();
  drawBlobs();
  pushStyle();
  fill(#F02252);
  ellipse(map(avgPos.x, 0, video.width, 0, width)-10, map(avgPos.y, 0, video.height, 0, height)-10, 20, 20);
  popStyle();
}


void keyPressed() {
  bo = !bo;
}

void mousePressed() {

  loadPixels();
  color temp = video.get((int)map(mouseX, 0, width, video.width, 0), (int)map(mouseY, 0, height, 0, video.height));
  targetMin = color(hue(temp)-5, 50, 20);
  targetMax = color(hue(temp)+5, 50, 100);
}
