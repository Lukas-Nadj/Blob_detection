PVector findBlobs() {
  // Clear the list of blobs
  blobs.clear();

  // Loop through all pixels in the image
  int[] labels = new int[video.width * video.height];
  int labelCount = 1;

  for (int y = 0; y < video.height; y++) {
    for (int x = 0; x < video.width; x++) {
      int index = y * video.width + x;
      int pixel = video.pixels[index];

      // Check if the pixel is green
      if (brightness(pixel) > brightness(targetMin) && saturation(pixel) > brightness(targetMin) && hue(pixel) > hue(targetMin) && hue(pixel) < hue(targetMax)) {
        int label = 0;
        boolean neighborFound = false;
        
        // Look in a 5x5 grid around the current pixel
        for (int j = -2; j <= 2; j++) {
          for (int i = -2; i <= 2; i++) {
            int neighborX = x + i;
            int neighborY = y + j;
            if (neighborX >= 0 && neighborX < video.width && neighborY >= 0 && neighborY < video.height) {
              int neighborIndex = neighborY * video.width + neighborX;
              int neighborPixel = video.pixels[neighborIndex];
              if (labels[neighborIndex] > 0 && hue(neighborPixel) > hue(targetMin) && hue(neighborPixel) < hue(targetMax)) {
                if (label == 0 || label > labels[neighborIndex]) {
                  label = labels[neighborIndex];
                  neighborFound = true;
                }
              }
            }
          }
        }
        
        if (!neighborFound) {
          label = labelCount;
          labelCount++;
        }

        labels[index] = label;

        // If the label is not already in the blobs list, create a new blob
        if (label > 0 && label <= blobs.size()) {
          Blob blob = blobs.get(label - 1);
          blob.addPixel(x, y);
        } else {
          Blob blob = new Blob(x, y);
          blobs.add(blob);
        }
      }
    }
  }
  
  int largestSize = 0;
  PVector averagePosition = new PVector();
  for (Blob blob : blobs) { 
    if (blob.getSize() > largestSize) {
      largestSize = blob.getSize();
      averagePosition = blob.getAveragePosition();
    }
  }

  // Print the average position of the largest blob
  println("Average position: " + averagePosition.x + ", " + averagePosition.y);

  // Remove small blobs
  for (int i = blobs.size() - 1; i >= 0; i--) {
    if (blobs.get(i).getSize() < 20) {
      blobs.remove(i);
    }
  }
  return averagePosition;
}



void drawBlobs() {
  for (Blob blob : blobs) {
    blob.draw();
  }
}





class Blob {
  ArrayList<PVector> pixels;

  Blob(int x, int y) {
    pixels = new ArrayList<PVector>();
    addPixel(x, y);
  }

  void addPixel(int x, int y) {
    pixels.add(new PVector(x, y));
  }

  boolean contains(int x, int y) {
    for (PVector pixel : pixels) {
      if (dist(pixel.x, pixel.y, x, y) < 10) {
        return true;
      }
    }
    return false;
  }

  int getSize() {
    return pixels.size();
  }

  void draw() {
    if (pixels.size() > 0) {
      for (PVector pixel : pixels) {
        fill(random(100), 100, 100);
        noStroke();
        rect(map(pixel.x, 0, video.width, 0, width), map(pixel.y, 0, video.height, 0, height), 2, 2);
      }
    }
  }
  PVector getAveragePosition() {
  int maxBlobSize = 0;
  Blob largestBlob = null;
  for (Blob blob : blobs) {
    int size = blob.getSize();
    if (size > maxBlobSize) {
      maxBlobSize = size;
      largestBlob = blob;
    }
  }
  if (largestBlob == null) {
    return null;
  }
  ArrayList<PVector> pixels = largestBlob.pixels;
  int numPixels = pixels.size();
  float sumX = 0;
  float sumY = 0;
  for (PVector pixel : pixels) {
    sumX += pixel.x;
    sumY += pixel.y;
  }
  float avgX = sumX / numPixels;
  float avgY = sumY / numPixels;
  return new PVector(avgX, avgY);
}

  
  
  
}
